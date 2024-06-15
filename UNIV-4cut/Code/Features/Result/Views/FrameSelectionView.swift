import SwiftUI

struct FrameSelectionView: View {
    @Binding var selectedFrameIndex: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            ForEach(0..<4) { index in
                Circle()
                    .frame(width: 60, height: 60)
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
            return .skyBlueUniv
        case 1:
            return .mintUniv
        case 2:
            return .black
        case 3:
            return .white
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
