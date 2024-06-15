import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel = ResultViewModel()
    let mergedImage: UIImage
    
    @State private var showingTakePhotoView = false
    @State private var showingQRView = false
    @State private var showingHomeView = false
    @State private var selectedFrameIndex = 0
    
    let processor = ImageProcessor()
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            GeometryReader { geometry in
                ZStack {
                    Image(uiImage: mergedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 180.0)
                        .frame(width: geometry.size.width, height: geometry.size.height - 255)
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

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        if let exampleImage = UIImage(named: "4cut_example") {
            ResultView(mergedImage: exampleImage)
        } else {
            ResultView(mergedImage: UIImage())
        }
    }
}
