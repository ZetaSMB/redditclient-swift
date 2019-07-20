//
//  Link.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

struct Link : Codable {
    
    var id: String?
    var title: String?
    var author: String?
    var createdDate: Date?
    var thumbnail: String?
    var numberOfComments: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "name"
        case title
        case author
        case createdDate = "created_utc"
        case thumbnail
        case numberOfComments = "num_comments"
    }
}
