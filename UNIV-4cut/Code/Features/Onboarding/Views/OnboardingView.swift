import SwiftUI
import AVFoundation

struct OnboardingView: View {
    
    @State private var showingTakePhotoView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View {
        Button{
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left") // 화살표 Image
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
                Text("뒤로")
                    .foregroundColor(Color.black)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("찍기전에 보고 갈까요?!")
                .font(.custom("Pretendard-SemiBold", size: 30))
                .foregroundColor(.black)
                .padding(.top, 40.0) // 텍스트 색상
                .padding(.bottom, 20.0) // 텍스트 색상
            
            Spacer()
            VStack(alignment: .leading,spacing: 10){
                IconTextComponent(iconName: "cloud", text: "타이머는 6초입니다")
                IconTextComponent(iconName: "cloud.fill", text: "재촬영은 1번 가능합니다.")
                IconTextComponent(iconName: "cloud", text: "총 4번의 사진이 촬영됩니다.")
                IconTextComponent(iconName: "camera", text: "아래와 같이 촬영됩니다!")
            }
            
            // 프레임 이미지 로딩을 개선합니다.
            if let frameImage = UIImage(named: "4cut_exmaple_onboarding") {
                Image(uiImage: frameImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.7) // 이미지 크기를 80%로 줄임
                
            } else {
                // 프레임 이미지 로딩 실패 시 로그를 남깁니다.
                Text("프레임 이미지를 불러올 수 없습니다.")
                    .foregroundColor(.red)
            }
            
            // "촬영하기" 버튼
            Spacer()
            Button("촬영하기") {
                showingTakePhotoView = true
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.black)
            .cornerRadius(10)
            .fullScreenCover(isPresented: $showingTakePhotoView) {
                TakePhotoView()
            }
        }
        .onAppear {
            requestCameraPermission()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)  // <-- 👀 버튼을 등록한다.
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
