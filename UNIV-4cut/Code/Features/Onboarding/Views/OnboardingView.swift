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
                .padding(.top, 60.0) // 텍스트 색상
                .padding(.bottom, 120.0) // 텍스트 색상
            
            
            VStack(alignment: .leading,spacing: 10){
                IconTextComponent(iconName: "cloud", text: "타이머는 6초입니다!")
                
                IconTextComponent(iconName: "cloud.fill", text: "촬영 기회는 딱 한번! 예쁘게 찍어봐요!.")
                IconTextComponent(iconName: "cloud", text: "사진 촬영은 총 4번 됩니다.")
                IconTextComponent(iconName: "cloud.fill", text: "촬영하기를 누르면 바로 촬영이 시작돼요!")
                IconTextComponent(iconName: "camera", text: "촬영 완료 후 아래 4가지 프레임 중 1가지를 선택할 수 있어요!")
            }
            
            // 프레임 이미지 로딩을 개선합니다.
            if let frameImage = UIImage(named: "4cut_exmaple_onboarding") {
                Image(uiImage: frameImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.9) // 이미지 크기를 80%로 줄임
                
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
                // 사용자가 카메라 접근을 허용
                print("카메라 접근 허용됨")
            } else {
                // 사용자가 카메라 접근을 거부
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
