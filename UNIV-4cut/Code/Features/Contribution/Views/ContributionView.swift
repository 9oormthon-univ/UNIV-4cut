//
//  ContributionView.swift
//  UNIV-4cut
//
//  Created by 서희찬 on 6/22/24.
//

import SwiftUI
import WebKit

struct ContributionView: View {
    @State private var showingTakePhotoView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showWebView = false

    // 기여자 데이터
    let contributions = [
        Contribution(instagramID: "@jae._._.ha", date: "2024-06-17", idea: "사진 저장하기 아이디어 제공"),
        Contribution(instagramID: "realdouble_s, seongyeon_hong_,jcl003,dodyaaa__,jaemai._.man,pjun_421", date: "2024-06-23", idea: "즉시 촬영버튼 아이디어 제공"),
        Contribution(instagramID: "pjun_421", date: "2024-06-23", idea: "촬영중 시간 지연 아이디어 제공"),
        Contribution(instagramID: "taegyeong0225, lj.cuddlyn_p", date: "2024-06-23", idea: "아이패드 가로 모드 제한 수정"),
        Contribution(instagramID: "1997_rec", date: "2024-06-23", idea: "온보딩-촬영하기 버튼 버그 수정"),
        Contribution(instagramID: "2000_02_10_", date: "2024-06-24", idea: "온보딩-맞춤법 수정"),
        Contribution(instagramID: "dodyaaa__, jaemai._.man, oeyoeoey", date: "2024-06-24", idea: "촬영시 이펙트 아이디어 제공"),
    ]
    
    // 뒤로가기 버튼 뷰
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left") // 화살표 이미지
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
                Text("뒤로")
                    .foregroundColor(Color.black)
            }
        }
    }
    
    
    var body: some View {
        
        ScrollView {
            VStack {
        
                Text("아래 구글폼으로 아이디어를 보내주세요!")
                Button(action: {
                                   showWebView = true
                               }) {
                                   Text("구글폼 링크 열기")
                               }
                Text("반영이 된다면 해당 페이지에 업데이트 됩니다:)")
                Text("Last updated : 6.23 13:00")
                
                ForEach(contributions) { contribution in
                    ContributionListView(contribution: contribution)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationTitle("기여해주신 분")
               
        }
        .sheet(isPresented: $showWebView) {
                  WebView(url: URL(string: "https://forms.gle/WoX7wYaGPenoyUMu7")!)
              }
    }
}

struct ContributionListView: View {
    let contribution: Contribution
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Instagram ID: \(contribution.instagramID)")
                    .font(.headline)
                Text("Date: \(contribution.date)")
                    .font(.subheadline)
                Text("Idea: \(contribution.idea)")
                    .font(.body)
            }
            .padding()
            Spacer()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.vertical, 5)
    }
}

// * 웹뷰
//
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


#Preview {
    ContributionView()
}

