//
//  EFLProfileDetailCell.swift
//  Efl
//
//  Created by vishnu vijayan on 28/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

public let profileDetailCellIdentifier = "ProfileDetailCellIdentifier"
class EFLProfileDetailCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: EFLTextField!
    @IBOutlet weak var lastNameTextField: EFLTextField!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        EFLUtility.saveUserImage(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize))
                    }
                }
            }
            else {
                profileImageView.image = placeholderImage
            }
        }
        firstNameTextField.text = EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY)
        lastNameTextField.text = EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
