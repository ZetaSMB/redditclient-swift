//
//  ReeditAPIRequest.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest(withParams params: [String: String]?) -> URLRequest
}


enum ReeditAPIRequest : URLRequestConvertible {
    enum Constants {
        static let baseURLPath = "https://www.reddit.com/"
    }
    
    case listing(RDTAPIListingType)
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .listing(let type):
            switch type {
            case .top:
                return "top.json"
            }
        }
    }
    
    func asURLRequest(withParams params:[String: String]?) -> URLRequest {
        var url : URL! = URL(string:Constants.baseURLPath)
        url.appendPathComponent(path)
        var urlComponents = URLComponents(url:url, resolvingAgainstBaseURL: false)
        if let parameters = params {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.httpMethod = method
        return urlRequest
    }
}
