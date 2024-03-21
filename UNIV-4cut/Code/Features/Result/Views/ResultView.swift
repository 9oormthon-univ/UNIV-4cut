import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel = ResultViewModel()
    let mergedImage: UIImage
    
    
    @State private var showingTakePhotoView = false
    @State private var showingQRView = false
    @State private var showingHomeView = false
    @State private var selectedFrameIndex = 0
    
    let processor = ImageProcessor()
    var body: some View {
        VStack{
            Spacer(minLength: 30)
            GeometryReader { geometry in
                
                ZStack {
                    Image(uiImage: mergedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 180.0)
                        .frame(width: geometry.size.width, height: geometry.size.height-255    )
                        .navigationBarHidden(true)
                    
                    // 프레임 이미지 로딩을 개선합니다.
                    if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
                        Image(uiImage: frameImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height-200)
                            .navigationBarHidden(true)
                        
                    } else {
                        Text("프레임 이미지를 불러올 수 없습니다.")
                            .foregroundColor(.red)
                            .navigationBarHidden(true)
                    }
                }
                
                VStack(alignment: .center){
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 30){
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.skyBlueUniv)
                            .overlay(
                                    Circle()
                                        .stroke(selectedFrameIndex == 0 ? .grayUniv : Color.clear, lineWidth: 3)
                                )
                            .onTapGesture {
                                selectedFrameIndex = 0
                            }
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.mintUniv)
                            .overlay(
                                    Circle()
                                        .stroke(selectedFrameIndex == 1 ? .grayUniv : Color.clear, lineWidth: 3)
                                )
                            .onTapGesture {
                                selectedFrameIndex = 1
                            }
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.black)
                            .overlay(
                                    Circle()
                                        .stroke(selectedFrameIndex == 2 ? .grayUniv : Color.clear, lineWidth: 3)
                                )
                            .onTapGesture {
                                selectedFrameIndex = 2
                            }
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .overlay(
                                    Circle()
                                        .stroke(.lightGrayUniv, lineWidth: 3)
                                )
                            .overlay(
                                    Circle()
                                        .stroke(selectedFrameIndex == 3 ? .grayUniv : Color.clear, lineWidth: 3)
                                )
                            .onTapGesture {
                                selectedFrameIndex = 3
                            }
                    }
                    .padding(.bottom, 30.0)
                    
                    
                    HStack(alignment: .center){
                        Spacer()
                        if viewModel.isFirst {
//                            Button("다시 찍기") {
//                                showingTakePhotoView=true
//                                //                                                       viewModel.retakeProcess() // isFirst 상태 업데이트
//                            }
//                            .foregroundColor(.white)
//                            .frame(width: 140, height: 50)
//                            .background(Color.black)
//                            .cornerRadius(10)
//                            .fullScreenCover(isPresented: $showingTakePhotoView) {
//                                TakePhotoView()
//                            }
                        }
                        Button("홈으로") {
                            showingHomeView = true
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 140, height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                        .fullScreenCover(isPresented: $showingHomeView) {
                            HomeView()
                        }
                        
                        Button("QR코드 생성") {
                            showingQRView = true
                            
                            // 이미지 합치기
                            
                            
                            // 프레임 이미지 로딩을 개선합니다.
                            if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
                                if  let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
                                    // 프레임 이미지도 넘기기
                                    viewModel.uploadImageAndGenerateQRCode(image: frameMergedImage)
                                } else {
                                    print("이미지 합치기에 실패했습니다.")
                                }
                                
                            } else {
                                Text("프레임 이미지를 불러올 수 없습니다.")
                                    .foregroundColor(.red)
                            }
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 140, height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                        .sheet(isPresented: $showingQRView) {
                            if let qrImage = viewModel.qrCodeImage {
                                VStack{
                                    Spacer()
                                    // 이미지
                                    Text("사진은 3시간뒤에 만료됩니다! 꼭 바로 다운받아주세요")
                                        .font(.custom("Pretendard-SemiBold", size: 20))
                                    Spacer()
                                    Image(uiImage: qrImage)
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .scaleEffect(0.6) // 이미지 크기를 80%로 줄임
                                    Spacer()
                                    Button("홈으로") {
                                        showingQRView = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            // 약간의 지연 후 홈 뷰로 이동 상태를 활성화
                                            showingHomeView = true
                                        }
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 140, height: 50)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .padding(.bottom,30)
                                    .fullScreenCover(isPresented: $showingHomeView) {
                                        HomeView()
                                    }
                                }
                            } else {
                                Text("QR 코드 생성 중...")
                                    .font(.custom("Pretendard-SemiBold", size: 20))
                            }
                        }
                        //.padding(.horizontal)
                        Spacer()
                    }
                    .padding(.bottom, 20.0)
                }
                
                
            }
            .padding(.all)
            .edgesIgnoringSafeArea(.all)
            
            
        }
        
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        if let exampleImage = UIImage(named: "4cut_example") {
            ResultView(mergedImage: exampleImage)
        } else {
            ResultView(mergedImage: UIImage())
        }
    }
}
