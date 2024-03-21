import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var capturedImages: [UIImage] = []
    @Published var remainingTime = 0
    @Published var mergedImage: UIImage? = nil
    @Published var count = 0

    var captureAction: (() -> Void)?
    var timer: Timer?
    var captureCount = 0 // 개선된 부분: 초기 캡처 카운트를 0으로 설정

    func startCapturing() {
        // 이미 실행 중인 타이머가 있다면 종료합니다.
        timer?.invalidate()
        
        captureCount = 0
        capturedImages.removeAll()
        remainingTime = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    func fontView(){
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print(fontName)
            }
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
                // 타이머 종료 및 이미지 병합 로직
                timer?.invalidate()
                timer = nil
                // 한번찍었으니 올리기
                count+=1
                print("Capture complete, merging images.")
                self.mergedImage = self.mergeImages()
                // 상태 초기화 로직
                              resetCameraState()
            }
        }
    }

    
    // 상태를 초기화하는 함수
      private func resetCameraState() {
          capturedImages = [] // 캡처된 이미지 목록 초기화
          remainingTime = 0 // 남은 시간을 0으로 설정
          captureCount = 0 // 캡처 카운트를 0으로 초기화
      }
    
    
    func mergeImages() -> UIImage? {
        guard capturedImages.count == 4 else {
            print("Captured images count does not match expected. Found: \(capturedImages.count)")
            return nil
        }
        
        
        let flippedImages = capturedImages.map { $0.withHorizontallyFlippedOrientation() ?? $0 }

        // 이미지 크기를 1/2로 줄입니다.
        let resizeWidth = capturedImages[0].size.width / 2
        let resizeHeight = capturedImages[0].size.height / 2
        let size = CGSize(width: resizeWidth * 2, height: resizeHeight * 2)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        for (index, image) in capturedImages.enumerated() {
            guard let resizedImage = image.resized(toWidth: resizeWidth) else {
                print("Failed to resize image at index \(index).")
                UIGraphicsEndImageContext() // 현재 이미지 컨텍스트를 종료합니다.
                return nil
            }
            let x = CGFloat(index % 2) * resizeWidth
            let y = CGFloat(index / 2) * resizeHeight
            resizedImage.draw(in: CGRect(x: x, y: y, width: resizeWidth, height: resizeHeight))
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let merged = mergedImage {
            print("Image merging successful.")
            return merged
        } else {
            print("Failed to merge images.")
            return nil
        }
    }

}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
