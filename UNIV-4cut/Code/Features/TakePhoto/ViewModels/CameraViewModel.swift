import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var capturedImages: [UIImage] = [] // 캡처된 이미지를 저장하는 배열
    @Published var remainingTime = 0 // 남은 시간을 나타내는 변수
    @Published var mergedImage: UIImage? = nil // 병합된 이미지를 저장하는 변수
    @Published var count = 0 // 캡처 시도 횟수를 저장하는 변수

    var captureAction: (() -> Void)? // 캡처를 실행하는 클로저
    var timer: Timer? // 타이머 객체
    var captureCount = 0 // 캡처된 이미지 수를 저장하는 변수

    // 캡처 시작 함수
    func startCapturing() {
        resetTimer() // 기존 타이머를 초기화
        captureCount = 0 // 캡처 횟수 초기화
        capturedImages.removeAll() // 캡처된 이미지 배열 초기화
        remainingTime = 4 // 초기 남은 시간 설정
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer() // 타이머 업데이트 함수 호출
        }
    }

    // 폰트 뷰 (디버깅용 함수)
    func fontView() {
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print(fontName) // 폰트 이름 출력
            }
        }
    }

    // 타이머 업데이트 함수
    func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1 // 남은 시간을 1씩 감소
        } else {
            handleCapture() // 캡처 처리 함수 호출
        }
    }

    // 캡처 처리 함수
    private func handleCapture() {
        if captureCount < 4 {
            captureAction?() // 캡처 실행
            remainingTime = 4 // 남은 시간 초기화
        } else {
            finishCapturing() // 캡처 완료 처리 함수 호출
        }
    }

    // 캡처 완료 처리 함수
    private func finishCapturing() {
        resetTimer() // 타이머 초기화
        count += 1 // 캡처 시도 횟수 증가
        print("Capture complete, merging images.")
        mergedImage = mergeImages() // 이미지 병합 함수 호출
        resetCameraState() // 카메라 상태 초기화 함수 호출
    }

    // 타이머 초기화 함수
    private func resetTimer() {
        timer?.invalidate() // 기존 타이머 무효화
        timer = nil // 타이머 객체 초기화
    }

    // 카메라 상태 초기화 함수
    private func resetCameraState() {
        capturedImages.removeAll() // 캡처된 이미지 배열 초기화
        remainingTime = 0 // 남은 시간 초기화
        captureCount = 0 // 캡처 횟수 초기화
    }

    // 이미지 병합 함수
    func mergeImages() -> UIImage? {
        // 캡처된 이미지가 4개인지 확인
        guard capturedImages.count == 4 else {
            print("Captured images count does not match expected. Found: \(capturedImages.count)")
            return nil
        }

        // 이미지 크기 조정
        let resizedImages = capturedImages.map { $0.resized(toWidth: $0.size.width / 2) ?? $0 }
        let size = CGSize(width: resizedImages[0].size.width * 2, height: resizedImages[0].size.height * 2)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0) // 그래픽 컨텍스트 시작

        // 이미지를 합치는 반복문
        for (index, image) in resizedImages.enumerated() {
            let x = CGFloat(index % 2) * resizedImages[0].size.width
            let y = CGFloat(index / 2) * resizedImages[0].size.height
            image.draw(in: CGRect(x: x, y: y, width: resizedImages[0].size.width, height: resizedImages[0].size.height))
        }

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext() // 병합된 이미지 가져오기
        UIGraphicsEndImageContext() // 그래픽 컨텍스트 종료

        if let merged = mergedImage {
            print("Image merging successful.")
            return merged // 병합된 이미지 반환
        } else {
            print("Failed to merge images.")
            return nil // 병합 실패 시 nil 반환
        }
    }
}

extension UIImage {
    // 이미지 크기 조정 함수
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale) // 그래픽 컨텍스트 시작
        defer { UIGraphicsEndImageContext() } // 그래픽 컨텍스트 종료
        draw(in: CGRect(origin: .zero, size: canvasSize)) // 이미지를 그리는 코드
        return UIGraphicsGetImageFromCurrentImageContext() // 조정된 이미지 반환
    }
}
