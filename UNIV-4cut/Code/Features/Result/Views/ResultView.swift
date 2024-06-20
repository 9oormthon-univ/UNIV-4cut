import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel = ResultViewModel()
    let mergedImage: UIImage
    
    // 변수 리스트
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
                    Image(uiImage: mergedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, adjustedValue(for: geometry, large: 200, medium: 180, small: 100))
                        .frame(width: geometry.size.width, height: adjustedValue(for: geometry, large: geometry.size.height - 280, medium: geometry.size.height - 255, small: geometry.size.height - 235))
                        .navigationBarHidden(true)
                    
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
    
    // 화면 너비에 따라 높이를 조정하는 함수
    private func adjustedValue(for geometry: GeometryProxy, large: CGFloat, medium: CGFloat, small: CGFloat) -> CGFloat {
        switch geometry.size.width {
        case 1000...:
            return large
        case 600..<1000:
            return medium
        default:
            return small
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
