//
//  ContentView.swift
//  ddd
//
//  Created by 서희찬 on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > 600 {
                // iPad 11인치 레이아웃
                HomeView()
            } else {
                // iPhone 레이아웃
                MobileHomeView()
            }
        }
    }
}


#Preview {
    ContentView()
}
