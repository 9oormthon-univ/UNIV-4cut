import SwiftUI

struct MobileResultView: View {
    @StateObject private var viewModel = ResultViewModel()
    let mergedImage: UIImage
    
    // 변수 리스트
    // showingQRView : 큐알 화면
    // showingHomeView : 홈 뷰
    @State private var showingQRView = false
    @State private var showingHomeView = false
    @State private var selectedFrameIndex = 0
    
    // 프로세서
    let processor = ImageProcessor()
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            GeometryReader { geometry in
                ZStack {
                    // 병합 이미지
                    Image(uiImage: mergedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 100.0)
                        .frame(width: geometry.size.width, height: geometry.size.height - 235)
                        .navigationBarHidden(true)
                    
                    // 프레임 이미지 로딩
                    if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
                        Image(uiImage: frameImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height - 200)
                            .navigationBarHidden(true)
                    } else {
                        Text("프레임 이미지를 불러올 수 없습니다.")
                            .foregroundColor(.red)
                            .navigationBarHidden(true)
                    }
                }
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    FrameSelectionView(selectedFrameIndex: $selectedFrameIndex)
                        .padding(.bottom, 30.0)
                    
                    ButtonActionView(
                        viewModel: viewModel,
                        showingHomeView: $showingHomeView,
                        showingQRView: $showingQRView,
                        mergedImage: mergedImage,
                        selectedFrameIndex: selectedFrameIndex,
                        processor: processor
                    )
                    .padding(.bottom, 20.0)
                }
            }
            .padding(.all)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MobileResultView_Previews: PreviewProvider {
    static var previews: some View {
        if let exampleImage = UIImage(named: "4cut_example") {
            MobileResultView(mergedImage: exampleImage)
        } else {
            MobileResultView(mergedImage: UIImage())
        }
    }
}
