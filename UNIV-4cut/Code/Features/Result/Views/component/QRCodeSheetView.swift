import SwiftUI

struct QRCodeSheetView: View {
    @ObservedObject var viewModel: ResultViewModel
    @Binding var showingHomeView: Bool
    @Binding var showingQRView: Bool
    
    var body: some View {
        if let qrImage = viewModel.qrCodeImage {
            VStack {
                Spacer()
                Text("사진은 3시간 뒤에 만료됩니다! 꼭 바로 다운받아주세요")
                    .font(.custom("Pretendard-SemiBold", size: 20))
                Spacer()
                Image(uiImage: qrImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .scaleEffect(0.6)
                Spacer()
                HStack{
                    ReusableButton(title: "홈으로") {
                        showingQRView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showingHomeView = true
                        }
                    }
                    .fullScreenCover(isPresented: $showingHomeView) {
                        HomeView()
                    }
//                    ReusableButton(title: "앨범 저장",boxWidth:90)                         save
//                    }
                }
                
//                Button("홈으로") {
//                    showingQRView = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        showingHomeView = true
//                    }
//                }
//                .foregroundColor(.white)
//                .frame(width: 140, height: 50)
//                .background(Color.black)
//                .cornerRadius(10)
//                .padding(.bottom, 30)
//                .fullScreenCover(isPresented: $showingHomeView) {
//                    HomeView()
//                    
//                    
//                }
            }
        } else {
            Text("QR 코드 생성 중...")
                .font(.custom("Pretendard-SemiBold", size: 20))
        }
    }
}

// QRCode Preview
struct QRCodeSheetView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) { showingHomeView in
            StatefulPreviewWrapper(false) { showingQRView in
                QRCodeSheetView(
                    viewModel: ResultViewModel(),
                    showingHomeView: showingHomeView,
                    showingQRView: showingQRView
                )
            }
        }
    }
}
