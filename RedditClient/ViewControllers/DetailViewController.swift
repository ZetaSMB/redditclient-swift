//
//  DetailViewController.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    
    var detailItem: LinkState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        if let linkState = detailItem {
            authorLbl.text = linkState.link.author ?? ""
            titleLbl.text = linkState.link.title ?? ""
            if let thumbnailUrl = linkState.link.thumbnail {
                mainImgView.setImage(from: thumbnailUrl)
            } else {
                mainImgView.image = nil
            }
        }
    }

}

