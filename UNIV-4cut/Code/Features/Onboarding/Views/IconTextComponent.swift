import SwiftUI
/**
 IconTextComponent: 아이콘과 텍스트를 같은 수평 행에 표시하는 SwiftUI 컴포넌트입니다.

 이 컴포넌트는 시스템 이미지 아이콘과 텍스트 요소를 포함하는 HStack으로 구성됩니다. 아이콘 이름, 텍스트 내용, 아이콘 색상, 텍스트 색상 및 텍스트 크기를 사용자 정의할 수 있습니다.

 - 매개변수:
    - iconName: 표시할 시스템 이미지 아이콘의 이름입니다. 필수 매개변수입니다.
    - text: 아이콘 옆에 표시할 텍스트입니다. 필수 매개변수입니다.
    - textColor: 텍스트의 색상입니다. 기본값은 검정색입니다.
    - iconColor: 아이콘의 색상입니다. 기본값은 검정색입니다.
    - textSize: 텍스트의 글꼴 크기입니다. 기본값은 20입니다.

 - 예시: IconTextComponent(iconName: "cloud", text: "하이", textColor: .blue, iconColor: .red, textSize: 18)
 이 예시는 구름 아이콘과 "하이" 텍스트를 생성하며, 텍스트는 파란색, 아이콘은 빨간색, 텍스트 크기는 18로 설정됩니다.
 */
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
