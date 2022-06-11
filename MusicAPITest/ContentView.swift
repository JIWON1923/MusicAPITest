//
//  ContentView.swift
//  MusicAPITest
//
//  Created by 이지원 on 2022/06/11.
//

import SwiftUI

struct Music: Hashable, Codable {
    var artistName: String
    var trackName: String
    var albumName: String
    var releaseDate: String
    var previewUrl: String
}

class ViewModel: ObservableObject {
    @Published var musicList: [Music] = []
    
    func getSearchResults() {
            guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else { return }
            urlComponents.query = "media=music&entity=song&term=bts"
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
                                let searchResult = Music(artistName: result["artistName"] as! String, trackName: result["trackName"] as! String, albumName: result["collectionName"] as! String, releaseDate: result["releaseDate"] as! String, previewUrl: result["previewUrl"] as! String)
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
    @StateObject var viewModel = ViewModel()
    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.musicList, id: \.self) { music in
                    HStack {
                        Image("")
                            .frame(width: 130, height: 70)
                            .background(.gray)
                        VStack {
                            Text(music.trackName)
                            Text(music.artistName)
                        }
                    }
                    .padding(3)
                }
            }
            .navigationTitle("Search")
            .onAppear() {
                viewModel.getSearchResults()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
