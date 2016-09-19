//
//  EFLRoomListCell.swift
//  Efl
//
//  Created by vishnu vijayan on 24/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

public let roomListCellIdentifier = "RoomListCellIdentifier"
class EFLRoomListCell: UITableViewCell {

    @IBOutlet weak var roomAvatar: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var roomSubtitle: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var notificationRedAlert: UIImageView!

    /** when red Notification Alert to be shown set the constant to 47 else set to 32 */
    @IBOutlet weak var labelTrailingtoEnd: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPoolRoomImage(id : String, imageURL: String?) {
        
        self.performSelector(#selector(self.loadImageInCell), withObject: id, withObject: imageURL)
    }
    
    func loadImageInCell(id : String, imageURL: String?) {
        if let poolRoomImage = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomImageFromCache(id) {
            roomAvatar.image = poolRoomImage
        }
        else {
            let placeholderImage = UIImage(named: AvatarPool50x50)
            if !EFLUtility.isEmptyString(imageURL) {
                EFLUtility.clearImageFromCache(imageURL!)
                roomAvatar.af_setImageWithURL(NSURL(string: imageURL!)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        let imageData = UIImageJPEGRepresentation(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize), 0.6)
                        EFLPoolRoomDataManager.sharedDataManager.savePoolRoomImageToCache(id, imageData: imageData!)
                    }
                }
            }
            else {
                roomAvatar.image = placeholderImage
            }
        }
    }
    
    //MARK: Localmethods: cell View
    func cellViewforUnreadNotification() {
        timeStamp.textColor = UIColor.eflRedColor()
        notificationRedAlert.hidden = false
        labelTrailingtoEnd.constant = 47
    }
    
    func cellViewforNotificationRead() {
        timeStamp.textColor = UIColor.eflDarkGreyColor()
        roomTitle.textColor = UIColor.eflBlackColor()
        notificationRedAlert.hidden = true
        labelTrailingtoEnd.constant = 32
    }
 
}
