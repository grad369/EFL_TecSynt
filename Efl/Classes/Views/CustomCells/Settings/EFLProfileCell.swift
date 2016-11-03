//
//  EFLProfileCell.swift
//  Efl
//
//  Created by vishnu vijayan on 28/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

public let profileCellIdentifier = "ProfileCellIdentifier"
class EFLProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func setData() {
        if let userImage = EFLUtility.getUserImage() {
            profileImageView.image = userImage
        }
        else {
            let placeholderImage = UIImage(named: Avatar50x50)
            if let URLString = EFLUtility.readValueFromUserDefaults(PROFILE_IMAGE_URL_KEY) {
                EFLUtility.clearImageFromCache(URLString)
                profileImageView.af_setImageWithURL(NSURL(string: URLString)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:0.5) {
                        EFLUtility.saveUserImage(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize))
                    }
                }
            }
            else {
                profileImageView.image = placeholderImage
            }
        }
        nameLabel.text = EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY)! + " " + EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY)!
    }
}
