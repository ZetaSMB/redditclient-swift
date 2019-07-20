//
//  LinkCell.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation
import UIKit

class LinkCell: UITableViewCell {
    
    @IBOutlet weak var readStatusView: UIView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var createdLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var dismissLbl: UIButton!
    @IBOutlet weak var numOfCommentsLbl: UILabel!
    
    var onPressBtnHandler: (() -> ())?
    
    public func configure(with linkState: LinkState, onPressBtnAction: @escaping (() -> ())) {
        onPressBtnHandler = onPressBtnAction
        readStatusView.isHidden = linkState.read
        authorLbl.text = linkState.link.author ?? ""
        createdLbl.text = linkState.link.createdDate?.timeAgoDescription() ?? ""
        titleLbl.text = linkState.link.title ?? ""
        
        if let nbr = linkState.link.numberOfComments {
            numOfCommentsLbl.text = "\(nbr) " + (nbr == 1 ?  "comment" : "comments")
        } else {
            numOfCommentsLbl.text = ""
        }
        
        if let thumbnailUrl = linkState.link.thumbnail {
            thumbnail.setImage(from: thumbnailUrl)
        } else {
            thumbnail.image = nil
        }
    }
    
    @IBAction func onDismissPressed(_ sender: Any) {
        guard let onPressBtnHandler = onPressBtnHandler else { return }
        onPressBtnHandler()
    }
}
