import SwiftUI

struct TakePhotoView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    @State private var isPresentingResultView = false

    var body: some View {
        // ToDO : 상단 safeArea제거하기
        ZStack {
            // 카메라 뷰를 배경으로 설정
            CustomCameraView(viewModel: cameraViewModel)
            // VStack으로 위에 씌우기
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
                    // 더 극적인 효과가 필요함
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
                
                // 버튼 HStack
                HStack(alignment: .center) {
                    ReusableButton(title: "5초 지연") {
                        // 5초 지연 -> remain time + 5sec
                        cameraViewModel.response5sec()
                    }
                    ReusableButton(title: "바로 촬영") {
                        // 즉각 촬영함수
                        cameraViewModel.directCapture()
                    }   
                }
            }
            .foregroundColor(.white)
        }
        .onAppear {
            // 화면이 나타날 때 촬영 시작
            cameraViewModel.startCapturing()
        }
        .fullScreenCover(isPresented: $isPresentingResultView) {
            // ResultView에 mergedImage가 nil인 경우에 대한 처리를 추가
            if let exampleImage = UIImage(named: "4cut_example") {
                ResultView(mergedImage: cameraViewModel.mergedImage ?? exampleImage)
            } else {
                ResultView(mergedImage: UIImage())
            }
        }
        .onChange(of: cameraViewModel.mergedImage) { _ in
            // mergedImage의 상태 변화가 감지되면 isPresentingResultView를 true로 설정하여 시트 표시
            isPresentingResultView = cameraViewModel.mergedImage != nil
        }
    }
}

// SwiftUI 미리보기
struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
