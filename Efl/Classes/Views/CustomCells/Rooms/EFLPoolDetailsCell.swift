//
//  EFLPoolDetailsCell.swift
//  Efl
//
//  Created by vishnu vijayan on 24/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

public let poolDetailsCellIdentifier = "PoolDetailsCellIdentifier"
class EFLPoolDetailsCell: UITableViewCell {
    @IBOutlet weak var poolLabel: UITextField!
    @IBOutlet weak var poolTextField: UITextField!
    @IBOutlet weak var poolImageView: UIImageView!
    @IBOutlet weak var poolImageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCreatePoolDataInRow(row: Int, requestModel :EFLCreatePoolRequestModel) {
        if row == 0 {
            poolLabel.text = "POOL_NAME_TEXT".localized
            if let poolName = requestModel.pool_name {
                poolTextField.text = poolName
            }
            else {
                poolTextField.text = EmptyString
            }
            poolTextField.placeholder = "POOL_NAME_PLACEHOLDER_TEXT".localized
            poolTextField.userInteractionEnabled = true
            poolImageView.hidden = true
            poolImageButton.userInteractionEnabled = false
            poolTextField.hidden = false
            accessoryType = .None
            selectionStyle = .None
        }
        else if row == 1 {
            poolLabel.text = "POOL_PICTURE_TEXT".localized
            poolImageView.hidden = false
            poolImageButton.userInteractionEnabled = true
            poolTextField.hidden = true
            accessoryType = .DisclosureIndicator
            selectionStyle = .Gray
        }
        else if row == 2 {
            poolLabel.text = "POOL_COMPETITION_TEXT".localized
            poolTextField.placeholder = "POOL_COMPETITION_PLACEHOLDER_TEXT".localized
//            if let poolCompetition = EFLCompetitionDataManager.sharedDataManager.getCompetitionName(String(requestModel.competition_id)) {
//                poolTextField.text = poolCompetition
//            }
            poolTextField.text = "Competition " + String(requestModel.competition_id)
            poolTextField.userInteractionEnabled = false
            poolImageView.hidden = true
            poolImageButton.userInteractionEnabled = false
            poolTextField.hidden = false
            accessoryType = .DisclosureIndicator
            selectionStyle = .Gray
        }
    }
    
    func setPoolRoomInfoInRow(row: Int, infoData: NSManagedObject) {
        if row == 0 {
            poolLabel.text = "POOL_NAME_TEXT".localized
            if let poolName = infoData.valueForKey("pool_name") as? String {
                poolTextField.text = poolName
            }
            poolTextField.placeholder = "POOL_NAME_PLACEHOLDER_TEXT".localized
            poolTextField.userInteractionEnabled = false
            poolImageView.hidden = true
            poolImageButton.userInteractionEnabled = false
            poolTextField.hidden = false
            accessoryType = .None
        }
        else if row == 1 {
            poolLabel.text = "POOL_PICTURE_TEXT".localized
            self.performSelector(#selector(self.loadImageInCell), withObject: infoData)
            poolImageView.hidden = false
            poolImageButton.userInteractionEnabled = false
            poolTextField.hidden = true
            accessoryType = .DisclosureIndicator
        }
        else if row == 2 {
            poolLabel.text = "POOL_COMPETITION_TEXT".localized
            poolTextField.placeholder = "POOL_COMPETITION_PLACEHOLDER_TEXT".localized
            if let poolCompetitionId = infoData.valueForKey("competition_id") as? String {
                if let poolCompetition = EFLCompetitionDataManager.sharedDataManager.getCompetitionName(poolCompetitionId) {
                poolTextField.text = poolCompetition
                }
                poolTextField.text = "Competition " + poolCompetitionId

            }
            poolTextField.userInteractionEnabled = false
            poolImageView.hidden = true
            poolImageButton.userInteractionEnabled = false
            poolTextField.hidden = false
            accessoryType = .DisclosureIndicator
        }
    }
    
    func loadImageInCell(infoData: NSManagedObject) {
        if let poolRoomImage = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomImageFromCache(infoData.valueForKey("poolroom_id") as! String) {
            poolImageView.image = poolRoomImage
        }
        else {
            let placeholderImage = UIImage(named: AvatarPool50x50)
            if !EFLUtility.isEmptyString(infoData.valueForKey("poolroom_id") as? String) {
                let imageURL = infoData.valueForKey("poolroom_id") as? String
                EFLUtility.clearImageFromCache(imageURL!)
                poolImageView.af_setImageWithURL(NSURL(string: imageURL!)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        let imageData = UIImageJPEGRepresentation(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize), 0.6)
                        EFLPoolRoomDataManager.sharedDataManager.savePoolRoomImageToCache(infoData.valueForKey("poolroom_id") as! String, imageData: imageData!)
                    }
                }
            }
            else {
                poolImageView.image = placeholderImage
            }
        }
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
