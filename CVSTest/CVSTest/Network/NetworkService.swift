//
//  NetworkService.swift
//  Interview
//
//  Created by Artem Kutasevych on 12/6/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func getItems(for searchWord: String) -> AnyPublisher<Items, Error>
}

class NetworkService: NetworkServiceProtocol {
    let apiClient = URLSessionAPIClient<ItemsEndpoint>()
    func getItems(for searchWord: String) -> AnyPublisher<Items, Error> {
        return apiClient.request(.getItems(search: searchWord))
    }
}



struct Items: Codable {
    let items: [Item]
}

struct Item: Codable, Hashable {
    let title: String
    let link: String
    let media: LinkPhoto
    let date_taken: Date
    let description: String
    let published: String
    let author: String
    let tags: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decode(String.self, forKey: .link)
        
        let dateIn = try container.decode(String.self, forKey: .date_taken)
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: dateIn)
        self.date_taken = date ?? Date()
        
        self.description = try container.decode(String.self, forKey: .description).trimHTMLTags() ?? ""
        self.published = try container.decode(String.self, forKey: .published)
        self.media = try container.decode(LinkPhoto.self, forKey: .media)
        let parsedAuthor = try container.decode(String.self, forKey: .author)
        
        let cleanAuthor = parsedAuthor.replacingOccurrences(of: "nobody@flickr.com (\"", with: "")
        self.author = cleanAuthor.replacingOccurrences(of: "\")", with: "")
        self.tags = try container.decode(String.self, forKey: .tags)
    }
    
    init (title: String, link: String, media: LinkPhoto, dateTaken: Date, description: String, published: String, author: String, tags: String) {
        self.title = title
        self.link = link
        self.media = media
        self.date_taken = dateTaken
        self.description = description
        self.published = published
        self.author = author
        self.tags = tags
    }
}

struct LinkPhoto: Codable, Hashable {
    let m: String
}

extension String {
    public func trimHTMLTags() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
    
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
    
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string
    }
}
