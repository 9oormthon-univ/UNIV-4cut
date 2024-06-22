import SwiftUI

struct CustomizableFrameView: View {
    @State private var frames: [Frame] = []
    @State private var texts: [TextFrame] = []
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingTextField = false
    @State private var inputText = ""
    @State private var showingSaveAlert = false

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // 기본 흰색 배경

            // 기본 배경 이미지
            Image("4cut")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
                .clipped()
                .overlay(
                    ZStack {
                        ForEach(frames) { frame in
                            ImageFrame(frame: frame)
                        }
                        ForEach(texts) { textFrame in
                            TextFrameView(textFrame: textFrame)
                        }
                    }
                )
                .shadow(radius: 2)

            VStack {
                Spacer()

                HStack {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("사진 추가")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding()

                    Button(action: {
                        showingTextField = true
                    }) {
                        Text("텍스트 추가")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding()

                    Button(action: saveFrame) {
                        Text("저장하기")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if let selectedImage = selectedImage {
                        let newFrame = Frame(id: UUID(), image: selectedImage, position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.375), size: CGSize(width: 150, height: 150))
                        frames.append(newFrame)
                        self.selectedImage = nil
                    }
                }
        }
        .alert(isPresented: $showingSaveAlert) {
            Alert(title: Text("저장 완료"), message: Text("프레임이 저장되었습니다."), dismissButton: .default(Text("확인")))
        }
        .textFieldAlert(isPresented: $showingTextField, text: $inputText, title: "텍스트 추가") {
            let newTextFrame = TextFrame(id: UUID(), text: inputText, position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.375), size: CGSize(width: 200, height: 50))
            texts.append(newTextFrame)
            inputText = ""
        }
    }

    private func saveFrame() {
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75))
        let image = renderer.image { context in
            let uiView = UIApplication.shared.windows.first!.rootViewController!.view!
            uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showingSaveAlert = true
    }
}

struct ImageFrame: View {
    @State var frame: Frame

    var body: some View {
        Image(uiImage: frame.image)
            .resizable()
            .frame(width: frame.size.width, height: frame.size.height)
            .position(x: frame.position.x, y: frame.position.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newPosition = CGPoint(x: min(max(value.location.x, frame.size.width / 2), UIScreen.main.bounds.width - frame.size.width / 2),
                                                  y: min(max(value.location.y, frame.size.height / 2), UIScreen.main.bounds.height * 0.75 - frame.size.height / 2))
                        frame.position = newPosition
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        frame.size = CGSize(width: frame.size.width * value, height: frame.size.height * value)
                    }
            )
    }
}

struct TextFrameView: View {
    @State var textFrame: TextFrame

    var body: some View {
        Text(textFrame.text)
            .frame(width: textFrame.size.width, height: textFrame.size.height)
            .background(Color.white.opacity(0.5))
            .position(x: textFrame.position.x, y: textFrame.position.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newPosition = CGPoint(x: min(max(value.location.x, textFrame.size.width / 2), UIScreen.main.bounds.width - textFrame.size.width / 2),
                                                  y: min(max(value.location.y, textFrame.size.height / 2), UIScreen.main.bounds.height * 0.75 - textFrame.size.height / 2))
                        textFrame.position = newPosition
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        textFrame.size = CGSize(width: textFrame.size.width * value, height: textFrame.size.height * value)
                    }
            )
    }
}

struct Frame: Identifiable {
    let id: UUID
    var image: UIImage
    var position: CGPoint
    var size: CGSize
}

struct TextFrame: Identifiable {
    let id: UUID
    var text: String
    var position: CGPoint
    var size: CGSize
}

struct CustomizableFrameView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizableFrameView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

extension View {
    func textFieldAlert(isPresented: Binding<Bool>, text: Binding<String>, title: String, onDone: @escaping () -> Void) -> some View {
        TextFieldAlert(isPresented: isPresented, text: text, title: title, onDone: onDone).background(self)
    }
}

struct TextFieldAlert: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var text: String
    let title: String
    let onDone: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TextFieldAlert>) {
        if isPresented && uiViewController.presentedViewController == nil {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = text
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                isPresented = false
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                if let textField = alert.textFields?.first {
                    text = textField.text ?? ""
                    onDone()
                }
                isPresented = false
            })
            uiViewController.present(alert, animated: true, completion: nil)
        }
    }
}
