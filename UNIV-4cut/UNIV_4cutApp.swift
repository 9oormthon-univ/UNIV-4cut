import SwiftUI
import Firebase

@main
struct UNIV_4cutApp: App {
    // 파베 초기화
    init() {
         FirebaseApp.configure()
     }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
