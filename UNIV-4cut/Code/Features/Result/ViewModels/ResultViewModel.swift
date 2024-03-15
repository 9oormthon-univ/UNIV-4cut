import SwiftUI

class ResultViewModel: ObservableObject {
    @Published var isFirst = true
    
    
    // 다시 찍기를 누르면 isFrist를 False로 바꿈
    func retakeProcess() {
        // False
        isFirst = false
    }
    
    
    // QR만들기를 누르면 해당 이미지를 FireStore에 저장하고 이미지 링크를 전달받고 QR Generator를 통해 큐알코드를 만듬
    

}
