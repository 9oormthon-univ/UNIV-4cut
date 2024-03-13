import SwiftUI
import AVFoundation

struct CustomCameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let coordinator = context.coordinator
        viewModel.captureAction = coordinator.takePicture
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
        context.coordinator.setupCameraSession()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var viewModel: CameraViewModel
        let captureSession = AVCaptureSession()
        let photoOutput = AVCapturePhotoOutput()

        init(viewModel: CameraViewModel) {
            self.viewModel = viewModel
            super.init()
            setupCameraSession()
        }

        func setupCameraSession() {
            captureSession.sessionPreset = .photo

            guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                  captureSession.canAddInput(videoInput) else {
                      return
                  }

            captureSession.addInput(videoInput)

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }

            DispatchQueue.main.async {
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    previewLayer.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height * (2/3))
                    previewLayer.videoGravity = .resizeAspectFill
                    window.layer.addSublayer(previewLayer)
                }
            }
            captureSession.startRunning()
        }

        func takePicture() {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }


        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            // 캡처된 사진의 데이터를 UIImage로 변환합니다.
            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                // 캡처 카운트를 체크하여 4미만인 경우에만 이미지를 추가합니다.
                guard self.viewModel.captureCount < 4 else {
                    // 이미 4장의 사진을 캡처했다면, 타이머를 종료하고 이미지 합치기 작업을 진행합니다.
                    self.viewModel.timer?.invalidate()
                    self.viewModel.timer = nil
                    self.viewModel.mergedImage = self.viewModel.mergeImages()
                    return
                }
                
                // 캡처된 이미지를 배열에 추가하고, 캡처 카운트를 증가시킵니다.
                self.viewModel.capturedImages.append(image)
                self.viewModel.captureCount += 1
                
                // 4장의 이미지가 모두 캡처되었는지 다시 확인하고, 모두 캡처되었다면 이미지를 합치는 작업을 진행합니다.
                if self.viewModel.capturedImages.count == 4 {
                    self.viewModel.mergedImage = self.viewModel.mergeImages()
                }
            }
        }

    }
}
