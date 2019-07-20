//
//  ListingRspDTO.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

struct ListingRspDTO: Codable {
    var kind: String
    var data: ChildrenListing
}

struct ChildrenListing: Codable {
    var modhash: String
    var after : String?
    var before : String?
    var children: [ChildrenItem]
}

struct ChildrenItem: Codable {
    var kind: String
    let data: Link
}
