import SwiftUI

struct ButtonActionView: View {
    @ObservedObject var viewModel: ResultViewModel
    @Binding var showingHomeView: Bool
    @Binding var showingQRView: Bool
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let mergedImage: UIImage
    let selectedFrameIndex: Int
    let processor: ImageProcessor
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ReusableButton(title: "홈",boxWidth:90) {
                showingHomeView = true
            }
            .fullScreenCover(isPresented: $showingHomeView) {
                HomeView()
            }
            
            ReusableButton(title: "QR 코드",boxWidth:90) {
                showingQRView = true
                generateQRCode()
            }
            .sheet(isPresented: $showingQRView) {
                QRCodeSheetView(viewModel: viewModel, showingHomeView: $showingHomeView, showingQRView: $showingQRView)
            }
            
            ReusableButton(title: "앨범 저장",boxWidth:90) {
                saveImgInGallery()
            }
            Spacer()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
    
    // 큐알코드 생성
    private func generateQRCode() {
        if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
            if let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
                viewModel.uploadImageAndGenerateQRCode(image: frameMergedImage)
            } else {
                print("이미지 합치기에 실패했습니다.")
            }
        }
    }
    
    // 이미지 저장
    private func saveImgInGallery() {
        if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
            if let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
                viewModel.saveImageToAlbum(image: frameMergedImage) { success, error in
                    if success {
                        alertTitle = "저장 완료"
                        alertMessage = "이미지가 성공적으로 저장되었습니다."
                    } else if let error = error {
                        alertTitle = "저장 실패"
                        alertMessage = "앨범에 저장 실패: \(error.localizedDescription)"
                    }
                    showingAlert =  true
                }
            } else {
                alertTitle = "저장 실패"
                alertMessage = "이미지 합치기에 실패했습니다."
                showingAlert = true
            }
        } else {
            alertTitle = "저장 실패"
            alertMessage = "프레임 이미지를 불러올 수 없습니다."
            showingAlert = true
        }
    }
}

struct ButtonActionView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) { showingHomeView in
            StatefulPreviewWrapper(false) { showingQRView in
                ButtonActionView(
                    viewModel: ResultViewModel(),
                    showingHomeView: showingHomeView,
                    showingQRView: showingQRView,
                    mergedImage: UIImage(),
                    selectedFrameIndex: 0,
                    processor: ImageProcessor()
                )
            }
        }
    }
}
