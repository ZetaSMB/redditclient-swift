//
//  DetailViewController.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import UIKit
import SafariServices
import AssetsLibrary
import Photos

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
    
    @IBAction private func onImageTapped(_ sender: Any) {
        guard let imageStrURL = detailItem?.link.fullSizedPictureUrl, let imageURL = URL(string : imageStrURL) else { return }
        let safariVC = SFSafariViewController(url: imageURL)
        self.navigationController?.present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction private func onSaveImageTapped() {
        guard let thundbnailImage = mainImgView.image else { return }
        PHPhotoLibrary.requestAuthorization({(status) in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    _ = PHAssetChangeRequest.creationRequestForAsset(from: thundbnailImage)
                }, completionHandler: { (success, error) in
                    if success {
                        self.showMessage("Done!", message:"The photo was successfully saved in your media gallery")
                    }
                    else {
                        self.showMessage("Oops, couldn't save image", message:"You need to authorize media gallery access to the app from settings")
                    }
                })
            } else {
                self.showMessage("Oops, couldn't save the image", message:"You need to authorize media gallery access to the app from settings")
            }
        })
    }
    
    private func showMessage(_ title:String, message: String? = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

