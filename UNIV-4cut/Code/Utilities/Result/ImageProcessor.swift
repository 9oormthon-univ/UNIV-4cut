import UIKit

class ImageProcessor {
    // 이미지 두 개 합치기
    func mergeImage(image: UIImage, frameImage:UIImage) -> UIImage? {

        let size = frameImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height-350))
        frameImage.draw(in: CGRect(x: 0, y: 0, width: size.width + 5, height: size.height))

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return mergedImage
    }
}
