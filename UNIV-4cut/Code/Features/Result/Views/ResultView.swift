import SwiftUI

struct ResultView: View {
    let mergedImage: UIImage
    
    var body: some View {
        ZStack{
            VStack{
                Image(uiImage: mergedImage)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                  .navigationBarHidden(true)

            }
            Image(uiImage: UIImage(named:"4cut_frame")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .navigationBarHidden(true)
            
        }
   
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(mergedImage: UIImage(named: "4cut_example")!) // 적절한 이미지로 교체
    }
}
