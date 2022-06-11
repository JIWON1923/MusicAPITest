//
//  ManiaDBAPI.swift
//  MusicAPITest
//
//  Created by 이지원 on 2022/06/11.
//

import SwiftyXMLParser
import Alamofire

func callAPI() {
    
//    let name = "악동뮤지션"
//    let url = "http://www.maniadb.com/api/search/\(name)/?sr=album&display=10&key=example&v=0.5"
//    guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
//    xmlParser.parse()
//
    //
    //    Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topgrossingapplications/limit=10/xml")
    //             .responseData { response in
    //                if let data = response.data {
    //                    let xml = XML.parse(data)
    //                    print(xml.feed.entry[0].title.text) // outputs the top title of iTunes app raning.
    //                }
    //            }
    
    //
//    let name = "악동뮤지션"
//    let url = "http://www.maniadb.com/api/search/악동뮤지션/?sr=album&display=10&key=example&v=0.5"
//    Alamofire.request(url)
//        .responseData { response in
//            if let data = response.data {
//                let xml = XML.parse(data)
//                //let cnt = xml.rss.channel.total.int!
//                    //for index in 0..<10 {
//                        if let cdata = xml.rss.channel.item.title.element?.CDATA,
//                           let cdataStr = String(data: cdata, encoding: .utf8) {
//                            print(cdataStr)
//                        }
//                    //}
//            }
//        }
    
    let str = "hello"
    let xml = try! XML.parse(str)
    if let cnt = xml.rss.channel.total.int {
        for index in 0..<cnt {
            if let cdata = xml.rss.channel.item[index].title.element?.CDATA,
               let cdataStr = String(data: cdata, encoding: .utf8) {
               print(cdataStr)
            }
        }
    }
}
