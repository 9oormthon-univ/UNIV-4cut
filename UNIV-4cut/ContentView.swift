import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        HomeView()
            .tabItem {
                        Image(selectedTab == 0 ? "icon_home_fill" : "icon_home")
                Text("홈")
            }.tag(0)
        // 이떄까지 만들어진 이미지들 보러가는 탭?
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
