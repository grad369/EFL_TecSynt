//
//  EFLFriendListCell.swift
//  Efl
//
//  Created by vishnu vijayan on 11/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

public let friendListCellIdentifier = "FriendListCellIdentifier"

class EFLFriendListCell: UITableViewCell {
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameTopContraint: NSLayoutConstraint!
    @IBOutlet weak var nameTrailingConstraint: NSLayoutConstraint!
    
    func setUSerFriendImage(id : String, imageURL: String?) {
        
        if let userFriendImage = EFLPlayerDataManager.sharedDataManager.getUserFriendProfilePicture(id) {
            friendImageView.image = userFriendImage
        }
        else {
            let placeholderImage = UIImage(named: Avatar70x70)
            if !imageURL!.isEmpty {
                EFLUtility.clearImageFromCache(imageURL!)
                friendImageView.af_setImageWithURL(NSURL(string: imageURL!)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        let imageData = UIImageJPEGRepresentation(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize), 0.6)
                        EFLPlayerDataManager.sharedDataManager.saveUserFriendProfilePicture(id, imageData: imageData!)
                    }
                }
            }
            else {
                friendImageView.image = placeholderImage
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
