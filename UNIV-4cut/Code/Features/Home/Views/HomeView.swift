import SwiftUI

// Home View : 로고, 촬영하기 버튼
struct HomeView: View {
        var body: some View {
            GeometryReader { geometry in
                
            NavigationView {
                VStack {
                    Spacer()
                    
                    // logo image
                    logoImage(for: geometry.size.width)
                    
                    Spacer()
                    
                    // 촬영하기 버튼 -> 온보딩 뷰로 이동 : 네비게이션 링크 방식
                    NavigationLink(destination: OnboardingView()) {
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
    
    // 로고 이미지를 반환하는 함수
    private func logoImage(for width: CGFloat) -> some View {
        let imageSize: CGFloat = width > 600 ? 400 : 300
        return Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageSize, height: imageSize)
    }
}

// SwiftUI 미리보기
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
