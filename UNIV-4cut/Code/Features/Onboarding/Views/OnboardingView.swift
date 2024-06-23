import SwiftUI
import AVFoundation

struct OnboardingView: View {
    
    @State private var showingTakePhotoView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 상수 선언
    private let titleText = "찍기전에 보고 갈까요?!"
    private let iconTexts: [(iconName: String, text: String)] = [
        ("cloud", "타이머는 6초입니다!"),
        ("cloud.fill", "촬영 기회는 딱 한 번! 예쁘게 찍어봐요!"),
        ("cloud", "사진은 총 4번 촬영됩니다!"),
        ("cloud.fill", "촬영하기를 누르면 바로 촬영이 시작돼요!"),
        ("camera", "촬영 완료 후 아래 4가지 프레임 중 1가지를 선택할 수 있어요!")
        ]
    private let frameImageName = "4cut_exmaple_onboarding"
    
    // 뒤로가기 버튼 뷰
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left") // 화살표 이미지
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
                Text("뒤로")
                    .foregroundColor(Color.black)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 제목 텍스트
                Text(titleText)
                    .font(.custom("Pretendard-SemiBold", size: 30))
                    .foregroundColor(.black)
                    .padding(.top, 60.0)
                    .padding(.bottom, geometry.size.width > 600 ? 120.0 : 60.0)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(iconTexts.enumerated()), id: \.offset) { index, item in
                        IconTextComponent(iconName: item.iconName, text: item.text, textSize: geometry.size.width > 600 ? 20 : 16)
                    }
                }
                .padding(.bottom, geometry.size.width > 600 ? 0.0 : 30.0)

                
                // 프레임 이미지
                if let frameImage = UIImage(named: frameImageName) {
                    Image(uiImage: frameImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(geometry.size.width > 600 ? 0.9 : 0.8)

                } else {
                    Text("프레임 이미지를 불러올 수 없습니다.")
                        .foregroundColor(.red)
                }
                
                Spacer()
                ReusableButton(title: "촬영하기") {
                    showingTakePhotoView = true
                }.fullScreenCover(isPresented: $showingTakePhotoView) {
                    TakePhotoView()
                }
            }
            .onAppear {
                requestCameraPermission()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .padding(.horizontal, geometry.size.width > 600 ? 40.0 : 0.0)

        }
    }
    
    // 카메라 권한 요청 함수
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("카메라 접근 허용됨")
            } else {
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
