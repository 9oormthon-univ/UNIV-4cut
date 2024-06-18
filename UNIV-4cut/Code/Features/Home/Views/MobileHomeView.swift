import SwiftUI

// Home View : 로고, 촬영하기 버튼
struct MobileHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                // logo image
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                Spacer()
                // 촬영하기 버튼 -> 온보딩 뷰로 이동 : 네비게이션 링크 방식
                NavigationLink(destination: MobileOnboardingView()) {
                    Text("촬영하기")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Stack View Style
    }
}

// SwiftUI 미리보기
struct MobileHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MobileHomeView()
    }
}
