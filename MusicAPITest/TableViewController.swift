//
//  TableViewController.swift
//  MusicAPITest
//
//  Created by 이지원 on 2022/06/11.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {

    var xmlParser = XMLParser()
    
    var currentElement = ""                // 현재 Element
    var movieItems = [[String : String]]() // 영화 item Dictional Array
    var movieItem = [String: String]()     // 영화 item Dictionary
    
    var pubTitle = "" // 영화 제목
    var contents = "" // 영화 내용
    
    let name = "악동뮤지션"
    
    func requestMovieInfo() {
        // OPEN API 주소
        let url = "http://www.maniadb.com/api/search/\(name)/?sr=album&display=10&key=example&v=0.5"
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }

    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "item") {
            movieItem = [String : String]()
            pubTitle = ""
            contents = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            movieItem["title"] = pubTitle;
            movieItem["contents"] = contents;
            
            movieItems.append(movieItem)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == "contents") {
            contents = string
        } else if (currentElement == "pubtitle") {
            pubTitle = string
        }
    }
}
