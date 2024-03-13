import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var capturedImages: [UIImage] = []
    @Published var remainingTime = 0
    @Published var mergedImage: UIImage? = nil

    var captureAction: (() -> Void)?
    var timer: Timer?
    var captureCount = 1

    func startCapturing() {
        captureCount = 0
        capturedImages.removeAll()
        remainingTime = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    
    func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            if captureCount < 4 {
                captureAction?()
                remainingTime = 3
            } else {
                timer?.invalidate()
                timer = nil
                print("Capture complete, merging images.")

                self.mergedImage = self.mergeImages()

            }
        }
    }

    
    func mergeImages() -> UIImage? {
        guard capturedImages.count == 4 else { return nil }
        timer?.invalidate()
        timer = nil
        let width = capturedImages[0].size.width
        let height = capturedImages[0].size.height
        let size = CGSize(width: width * 2, height: height * 2)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        for (index, image) in capturedImages.enumerated() {
            let x = CGFloat(index % 2) * width
            let y = CGFloat(index / 2) * height
            image.draw(in: CGRect(x: x, y: y, width: width, height: height))
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
