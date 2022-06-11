//
//  ContentView.swift
//  MusicAPITest
//
//  Created by 이지원 on 2022/06/11.
//

import SwiftUI

struct ContentView: View {
    
    @State var searchTitle: String = ""
    @State private var words = (1...50).map{ String($0) }
    var body: some View {
        
//        GeometryReader { geometry in
//            List {
//                ForEach(self.words, id: \.self) { word in
//                                            Text(word)
//                                                .padding()
//                                        }
//            }.listStyle(.sidebar)
//                }
        
        HStack {
            TextField("검색어를 입력하세요", text: $searchTitle)
            Button("Button") {
                searchTitle = ""
                callAPI()
                print("CLICKED")
            }
            .background(.blue)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
