import SwiftUI
import AVFoundation

struct OnboardingView: View {
    @State private var showingTakePhotoView = false
    var body: some View {
            VStack {
                Text("찍는 방법은 블라블라 일케 절케함")
                    .font(.largeTitle)
                    .padding()
                Text("찍는 방법은 블라블라 일케 절케함")
                    .font(.largeTitle)
                    .padding()
                                
                // 촬영하기 버튼
//                NavigationLink(destination: TakePhotoView()) {
//                    Text("촬영하기")
//                        .foregroundColor(.white)
//                        .frame(width: 200, height: 50)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }

                // "촬영하기" 버튼
                Button("촬영하기") {
                    showingTakePhotoView = true
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .fullScreenCover(isPresented: $showingTakePhotoView) {
                    TakePhotoView()
                }
            }
            .onAppear {
                requestCameraPermission()
            }
            .navigationBarBackButtonHidden(false)
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                // 사용자가 카메라 접근을 허용했습니다.
                print("카메라 접근 허용됨")
            } else {
                // 사용자가 카메라 접근을 거부했습니다.
                print("카메라 접근 거부됨")
            }
        }
    }
}

// SwiftUI 미리보기
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
