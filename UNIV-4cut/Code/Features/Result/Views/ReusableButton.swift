import SwiftUI

struct ReusableButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 140, height: 50)
                .background(Color.black)
                .cornerRadius(10)
        }
    }
}

struct ReusableButton_Previews: PreviewProvider {
    static var previews: some View {
        ReusableButton(title: "홈으로") {
            print("Button pressed")
        }
    }
}
