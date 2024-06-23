//
//  ContributionView.swift
//  UNIV-4cut
//
//  Created by 서희찬 on 6/22/24.
//

import SwiftUI


struct ContributionView: View {
    @State private var showingTakePhotoView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 기여자 데이터
    let contributions = [
        Contribution(instagramID: "@jae._._.ha", date: "2024-06-17", idea: "사진 저장하기 아이디어 제공"),
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
                ForEach(contributions) { contribution in
                    ContributionListView(contribution: contribution)
                }
                Text("DM으로 아이디어를 보내주세요!").padding(
                )
                Text("반영이 된다면 해당 페이지에 업데이트 됩니다:)")
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationTitle("기여해주신 분")
               
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


#Preview {
    ContributionView()
}

