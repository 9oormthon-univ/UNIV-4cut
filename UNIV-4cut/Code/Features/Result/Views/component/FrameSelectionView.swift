import SwiftUI

struct FrameSelectionView: View {
    @Binding var selectedFrameIndex: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            ForEach(0..<4) { index in
                Circle()
                    .frame(width: 50, height: 60)
                    .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 1, y: 1)
                    .foregroundColor(frameColor(for: index))
                    .overlay(
                        Circle()
                            .stroke(selectedFrameIndex == index ? .grayUniv : Color.clear, lineWidth: 3)
                    )
                    .onTapGesture {
                        selectedFrameIndex = index
                    }
            }
        }
    }
    
    private func frameColor(for index: Int) -> Color {
        switch index {
        case 0:
            return .white
        case 1:
            return .black
        case 2:
            return .mintUniv
        case 3:
            return .skyBlueUniv
        default:
            return .clear
        }
    }
}

struct FrameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(0) { FrameSelectionView(selectedFrameIndex: $0) }
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}