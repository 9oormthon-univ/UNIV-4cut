import UIKit

class ImageProcessor {
    // 이미지 두 개 합치기
    func mergeImage(image: UIImage) -> UIImage? {
        guard let frameImage = UIImage(named: "4cut_frame") else {
            print("프레임 이미지를 불러올 수 없습니다.")
            return nil
        }

        let size = frameImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height-130))
        frameImage.draw(in: CGRect(x: 0, y: 0, width: size.width + 5, height: size.height))

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return mergedImage
    }
}
