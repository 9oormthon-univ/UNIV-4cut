import SwiftUI

struct IconTextComponent: View {
    var iconName: String
    var text: String
    var textColor: Color = .black
    var iconColor: Color = .black
    var textSize: CGFloat = 20

    var body: some View {
        HStack {
            Image(systemName: iconName) 
                .aspectRatio(contentMode: .fit)
                .foregroundColor(iconColor) // 아이콘 색상
            Text(text)
                .font(.custom("Pretendard-SemiBold", size: textSize))
                .foregroundColor(textColor) // 텍스트 색상
        }
    }
}


#Preview {
    IconTextComponent(iconName: "cloud", text: "하이")
}
