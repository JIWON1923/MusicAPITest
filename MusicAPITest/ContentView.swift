//
//  ContentView.swift
//  MusicAPITest
//
//  Created by 이지원 on 2022/06/11.
//

import SwiftUI

struct URLImage: View {
    
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .background(.gray)
        } else {
            Image(systemName: "video")
                .resizable()
            
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(.gray)
                .onAppear {
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}

struct Music: Hashable, Codable {
    var artistName: String
    var trackName: String
    var albumName: String
    var releaseDate: String
    var previewUrl: String
    var artworkUrl100: String
}

class ViewModel: ObservableObject {
    @Published var musicList: [Music] = []
    
    func getSearchResults(search: String) {
        self.musicList = []
        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else { return }
        urlComponents.query = "media=music&entity=song&term=\(search)"
        guard let url = urlComponents.url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let e = error {
                NSLog("error: \(e.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    guard let jsonObject = object else {return}
                    
                    let searchResults = jsonObject["results"] as! [NSDictionary]
                    searchResults.forEach { result in
                        let searchResult = Music(artistName: result["artistName"] as! String, trackName: result["trackName"] as! String, albumName: result["collectionName"] as! String, releaseDate: result["releaseDate"] as! String, previewUrl: result["previewUrl"] as! String, artworkUrl100: result["artworkUrl100"] as! String)
                        self.musicList.append(searchResult)
                    }
                } catch let e as NSError {
                    print("error: \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}

struct ContentView: View {
    @State var search: String = ""
    @StateObject var viewModel = ViewModel()
    var body: some View {
        
        VStack {
            HStack {
                TextField("검색어 입력", text: $search)
                Button("search") {
                    viewModel.getSearchResults(search: search)
                }
            }
            NavigationView {
                List {
                    ForEach(viewModel.musicList, id: \.self) { music in
                        HStack {
                            URLImage(urlString: music.artworkUrl100)
                            
                            VStack {
                                Text(music.trackName)
                                Text(music.artistName)
                            }
                        }
                        .padding(3)
                    }
                }
                .navigationTitle("Search")
                .onAppear {
                    self.viewModel.getSearchResults(search: search)
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
