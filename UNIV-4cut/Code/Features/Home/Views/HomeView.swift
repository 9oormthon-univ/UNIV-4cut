import SwiftUI


struct HomeView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                Spacer()
                // 촬영하기 버튼
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// SwiftUI 미리보기
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
