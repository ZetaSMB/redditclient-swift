//
//  LinkState.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

struct LinkState : Codable{
    var link: Link
    var read: Bool = false    
}
