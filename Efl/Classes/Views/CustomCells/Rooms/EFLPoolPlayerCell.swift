//
//  EFLPoolPlayerCell.swift
//  Efl
//
//  Created by vishnu vijayan on 24/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

public let poolPlayerCellIdentifier = "PoolPlayerCellIdentifier"
class EFLPoolPlayerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setManagerData() {
        nameLabel.text = EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY)! + " " + EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY)!
        if let userImage = EFLUtility.getUserImage() {
            playerImageView.image = userImage
        }
        else {
            
            let placeholderImage = UIImage(named: Avatar40x40)
            if let URLString = EFLUtility.readValueFromUserDefaults(PROFILE_IMAGE_URL_KEY) {
                EFLUtility.clearImageFromCache(URLString)
                playerImageView.af_setImageWithURL(NSURL(string: URLString)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        EFLUtility.saveUserImage(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize))
                    }
                }
            }
            else {
                playerImageView.image = placeholderImage
            }
        }
    }
    
    
    func setPlayerData(player : NSManagedObject) {
        self.performSelector(#selector(self.loadImageInCell), withObject: player)
        
        nameLabel.text = EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY)! + " " + EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY)!
        let firstName = player.valueForKey("first_name") as? String
        let lastName = player.valueForKey("last_name") as? String
        nameLabel.text = firstName! + " " + lastName!
    }
    
    func loadImageInCell(playerInfo: NSManagedObject) {
        
        if let imageData = playerInfo.valueForKey("imageData") {
            playerImageView.image = UIImage(data:imageData as! NSData,scale:1.0)
        }
        else {
            let placeholderImage = UIImage(named: Avatar40x40)
            if !EFLUtility.isEmptyString(playerInfo.valueForKey("image") as? String) {
                let imageURL = playerInfo.valueForKey("image") as? String
                EFLUtility.clearImageFromCache(imageURL!)
                playerImageView.af_setImageWithURL(NSURL(string: imageURL!)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        let imageData = UIImageJPEGRepresentation(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize), 0.6)
                        EFLPoolRoomDataManager.sharedDataManager.savePoolRoomPlayerImageToCache(playerInfo.valueForKey("player_id") as! String, imageData: imageData!)
                    }
                }
            }
            else {
                playerImageView.image = placeholderImage
            }
        }
    }

    
    
    func setCreatePoolPlayerData(id : String) {
        
        if let userFriend = EFLPlayerDataManager.sharedDataManager.getUserFriendDetails(id) {
            if let imageData = userFriend.valueForKey("image") {
                playerImageView.image = UIImage(data:imageData as! NSData,scale:1.0)
            }
            else {
                
                let placeholderImage = UIImage(named: Avatar70x70)
                let imageURL = userFriend.valueForKey("imageURL") as! String
                if !imageURL.isEmpty {
                    EFLUtility.clearImageFromCache(imageURL)
                    playerImageView.af_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                        if let image = UIImage(data:result.data!,scale:1.0) {
                            let imageData = UIImageJPEGRepresentation(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize), 0.6)
                            EFLPlayerDataManager.sharedDataManager.saveUserFriendProfilePicture(id, imageData: imageData!)
                        }
                    }
                }
                else {
                    playerImageView.image = placeholderImage
                }
            }
            nameLabel.text = EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY)! + " " + EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY)!
            let firstName = userFriend.valueForKey("firstName") as? String
            let lastName = userFriend.valueForKey("lastName") as? String
            nameLabel.text = firstName! + " " + lastName!
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
