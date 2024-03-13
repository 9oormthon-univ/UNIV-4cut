import SwiftUI

struct TakePhotoView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    @State private var isPresentingResultView = false

    var body: some View {
        ZStack {
            // 카메라 뷰를 배경으로 설정
            CustomCameraView(viewModel: cameraViewModel)
            
            VStack {
                Spacer() // 상단 여백 생성
                Text("\(cameraViewModel.capturedImages.count)/4")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.top, 50) // 상단 Safe Area를 고려한 여백 추가
                // 타이머 표시
                if cameraViewModel.remainingTime > 0 {
                    Text("남은 시간: \(cameraViewModel.remainingTime)초")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                } else {
                    Text("사진 촬영 중...")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            cameraViewModel.startCapturing()
        }
        .fullScreenCover(isPresented: $isPresentingResultView) {
            // ResultView에 mergedImage가 nil인 경우에 대한 처리를 추가합니다.
                ResultView(mergedImage: cameraViewModel.mergedImage ?? UIImage())
        }
        .onChange(of: cameraViewModel.mergedImage) { _ in
            // mergedImage의 상태 변화가 감지되면, isPresentingResultView를 true로 설정하여 sheet를 표시합니다.
            isPresentingResultView = true // 항상 true로 설정합니다.

        }
    }
}


// SwiftUI 미리보기
struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
