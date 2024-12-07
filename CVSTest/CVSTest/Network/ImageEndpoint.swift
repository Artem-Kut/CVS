//
//  ImageEndpoint.swift
//  Interview
//
//  Created by Artem Kutasevych on 12/6/24.
//

import Foundation

enum ItemsEndpoint: APIEndpoint {
    case getItems(search: String)

    var baseURL: URL {
        return URL(string: "https://api.flickr.com/services/feeds")!
    }
    var path: String {
        switch self {
        case .getItems:
            return "/photos_public.gne"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getItems:
            return .get
        }
    }
    var headers: [String: String]? {
        return nil
    }
    var parameters: [String: Any]? {
        var parametersIn = [String: Any]()
        switch self {
        case .getItems(let search):
             parametersIn["tags"] = search
            parametersIn["format"] = "json"
            parametersIn["nojsoncallback"] = "1"
        }
        return parametersIn
    }
}
