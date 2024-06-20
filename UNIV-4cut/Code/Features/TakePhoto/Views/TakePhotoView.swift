import SwiftUI

struct TakePhotoView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    @State private var isPresentingResultView = false

    var body: some View {
        ZStack {
            // 카메라 뷰를 배경으로 설정
            CustomCameraView(viewModel: cameraViewModel)
            
            VStack {
                // 남은 시간이 0보다 큰 경우
                if cameraViewModel.remainingTime > 0 {
                    VStack {
                        Text("남은 시간")
                            .font(.custom("Pretendard-SemiBold", size: 40))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        Text("\(cameraViewModel.remainingTime)")
                            .font(.custom("Pretendard-SemiBold", size: 100))
                            .foregroundColor(.black)
                    }
                } else {
                    // 남은 시간이 0인 경우
                    Text("📸")
                        .font(.title)
                        .padding()
                }
                
                Spacer() // 상단 여백 생성
                
                // 캡처된 이미지 수 표시
                Text("\(cameraViewModel.capturedImages.count)/4")
                    .foregroundColor(.white)
                    .font(.custom("Pretendard-SemiBold", size: 30))
                    .padding()
                    .padding(.horizontal, 17)
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(36)
                    .padding(.bottom, 40) // 상단 Safe Area를 고려한 여백 추가
            }
            .foregroundColor(.white)
        }
        .onAppear {
            // 화면이 나타날 때 촬영 시작
            cameraViewModel.startCapturing()
        }
        .fullScreenCover(isPresented: $isPresentingResultView) {
            // ResultView에 mergedImage가 nil인 경우에 대한 처리 추가
            FullScreenResultView(mergedImage: cameraViewModel.mergedImage)
        }
        .onChange(of: cameraViewModel.mergedImage) { _ in
            // mergedImage의 상태 변화가 감지되면 isPresentingResultView를 true로 설정하여 시트 표시
            isPresentingResultView = cameraViewModel.mergedImage != nil
        }
    }
}

// ResultView를 전체 화면에 표시하기 위한 뷰
struct FullScreenResultView: View {
    let mergedImage: UIImage?

    var body: some View {
        let imageToShow = mergedImage ?? UIImage(named: "4cut_example") ?? UIImage()

        GeometryReader { geometry in
            if geometry.size.width > 600 {
                // iPad 레이아웃
                ResultView(mergedImage: imageToShow)
            } else {
                // iPhone 레이아웃
                MobileResultView(mergedImage: imageToShow)
            }
        }
    }
}

// SwiftUI 미리보기
struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
