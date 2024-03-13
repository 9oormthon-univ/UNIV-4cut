import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("유니브 네컷")
                    .font(.largeTitle)
                    .padding()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                // 촬영하기 버튼
                NavigationLink(destination: OnboardingView()) {
                    Text("촬영하기")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

// SwiftUI 미리보기
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
