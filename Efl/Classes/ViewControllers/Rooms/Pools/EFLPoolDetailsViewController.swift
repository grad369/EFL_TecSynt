//
//  EFLPoolDetailsViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 26/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class EFLPoolDetailsViewController: EFLBaseViewController, EFLSegmentedControlDelegate{
    @IBOutlet weak var poolInfoTableView: UITableView!

    let segmentedControl =  EFLSegmentedControl()
    var poolRoomDetails: NSManagedObject?
    var playerArray = [NSManagedObject]()
    var messageCellHeight:CGFloat = 66
    
    let messageTextView =  UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populatePlayerArray()
        // Do any additional setup after loading the view.
    }
    
    override func configurationView() {
        
        segmentedControl.setUpControl(UIColor.eflGreenColor(), buttonTitles: ["Matchdays", "Ranking", "Pool info"])
        self.view.addSubview(segmentedControl)
        segmentedControl.delegate = self
        segmentedControl.setSelectedIndex(3)
        segmentedControl.userInteractionEnabled =  false
        
        //self.addNavigationBackButton()
//        self.navigationItem.title = poolRoomDetails!.valueForKey("pool_name") as? String
        self.showNavigationTitle()
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        poolInfoTableView.registerNib(UINib(nibName: "EFLPoolDetailsCell", bundle: nil), forCellReuseIdentifier: poolDetailsCellIdentifier)
        poolInfoTableView.registerNib(UINib(nibName: "EFLPoolMessageCell", bundle: nil), forCellReuseIdentifier: poolMessageCellIdentifier)
        poolInfoTableView.registerNib(UINib(nibName: "EFLLogoutCell", bundle: nil), forCellReuseIdentifier: logoutCellIdentifier)
        poolInfoTableView.registerNib(UINib(nibName: "EFLPoolPlayerCell", bundle: nil), forCellReuseIdentifier: poolPlayerCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        
        let navController: EFLBaseNavigationController = self.navigationController as! EFLBaseNavigationController
        navController.removeShadow()
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.eflGreenColor()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let navController: EFLBaseNavigationController = self.navigationController as! EFLBaseNavigationController
        navController.navigationBar.clipsToBounds = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let navController: EFLBaseNavigationController = self.navigationController as! EFLBaseNavigationController
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.clearColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populatePlayerArray() {
        if let playerList = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomPlayersFromCache(poolRoomDetails!.valueForKey("poolroom_id") as! String)
        {
            for player in playerList {
                if player.valueForKey("invite_status") as? String == "Manager" {
                    playerArray.insert(player as! NSManagedObject, atIndex: 0)
                }
                else {
                    playerArray.append(player as! NSManagedObject)
                }
            }
        }
    }
    
    // MARK: UI Methods
    
    // MARK: Show navigation title view
    func showNavigationTitle() {
        
        let titleView = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 75, 44)) //75 TO DO
        titleView.backgroundColor = UIColor.clearColor()
        
        let titleLabel = UILabel.init(frame: CGRectMake(0, 0, 0, 44))
        titleLabel.font = FONT_MEDIUM_19
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.eflWhiteColor()
        titleLabel.text = poolRoomDetails!.valueForKey("pool_name") as? String
        titleView.addSubview(titleLabel)
        
        let labelSize = titleLabel.intrinsicContentSize()
        if labelSize.width > (CGRectGetWidth(titleView.frame) - 24) {
            titleLabel.frame = CGRectMake(0, 0, (CGRectGetWidth(titleView.frame)) - 25, 44)
        }
        else {
            titleLabel.frame = CGRectMake(0, 0, labelSize.width, 44)
        }
        titleLabel.center = titleView.center
        
        let titleImageView = UIImageView(frame: CGRectMake(titleLabel.frame.origin.x - 24, (CGRectGetHeight(titleView.frame) - 20) / 2, 20, 20))
        let placeHoldermage: UIImage = UIImage(named: AvatarPool40x40)!
        titleImageView.image = placeHoldermage
        titleImageView.layer.cornerRadius = 10
        titleImageView.layer.masksToBounds = true
        if let poolRoomImage = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomImageFromCache(poolRoomDetails!.valueForKey("poolroom_id") as! String) {
            titleImageView.image = poolRoomImage
        }
        else {
            if !EFLUtility.isEmptyString(poolRoomDetails!.valueForKey("poolroom_id") as? String) {
                let imageURL = poolRoomDetails!.valueForKey("poolroom_id") as? String
                EFLUtility.clearImageFromCache(imageURL!)
                titleImageView.af_setImageWithURL(NSURL(string: imageURL!)!, placeholderImage: placeHoldermage, filter: nil, imageTransition: .CrossDissolve(0.0), runImageTransitionIfCached: false) { (result: Response) in Void()
                    if result.data == nil { return }
                    if let image = UIImage(data:result.data!,scale:1.0) {
                        let imageData = UIImageJPEGRepresentation(EFLUtility.scaleDownImage(image, ToSize: imageScaleSize), 0.6)
                        EFLPoolRoomDataManager.sharedDataManager.savePoolRoomImageToCache(self.poolRoomDetails!.valueForKey("poolroom_id") as! String, imageData: imageData!)
                    }
                }
            }
            else {
                titleImageView.image = placeHoldermage
            }
        }


        titleView.addSubview(titleImageView)

        self.navigationItem.titleView = titleView
    }

    // MARK: UITableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        }
        else if section == 1{
            return 1
        }
        else {
            if self.isManager() {
                return playerArray.count + 1
            }
            else {
                return playerArray.count
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        else {
            return 24
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.getTableHeader(section)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0.001
        }
        else {
            return 30
        }
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:EFLPoolDetailsCell = tableView.dequeueReusableCellWithIdentifier(poolDetailsCellIdentifier) as! EFLPoolDetailsCell
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.setPoolRoomInfoInRow(indexPath.row, infoData: poolRoomDetails!)
            cell.poolTextField.userInteractionEnabled = false
            cell.poolImageButton.userInteractionEnabled = false
            cell.selectionStyle = .None
            return cell
        }
        else if indexPath.section == 1 {
            let cell:EFLPoolMessageCell = tableView.dequeueReusableCellWithIdentifier(poolMessageCellIdentifier) as! EFLPoolMessageCell
            cell.messageTextView.textContainer.lineFragmentPadding = 0;
            cell.messageTextView.textContainerInset = UIEdgeInsetsZero;
            cell.messageTextView.text = poolRoomDetails!.valueForKey("message") as? String
            cell.messageTextView.userInteractionEnabled = false
            cell.selectionStyle = .None
            
            return cell
        }
        else {
            if self.isManager() {
                
                if indexPath.row == 0 {
                    let cell:EFLLogoutCell = tableView.dequeueReusableCellWithIdentifier(logoutCellIdentifier) as! EFLLogoutCell
                    cell.separatorInset = UIEdgeInsetsZero
                    cell.layoutMargins = UIEdgeInsetsZero
                    cell.labelText.text = "ADD_PLAYER_BUTTON_TITLE".localized
                    cell.selectionStyle = .None
                    
                    return cell
                }
                else {
                    let cell:EFLPoolPlayerCell = tableView.dequeueReusableCellWithIdentifier(poolPlayerCellIdentifier) as! EFLPoolPlayerCell
                    let player = playerArray[indexPath.row - 1] as NSManagedObject
                    cell.setPlayerData(player)
                    cell.separatorInset = UIEdgeInsetsZero
                    cell.layoutMargins = UIEdgeInsetsZero
                    cell.selectionStyle = .None
                    
                    if indexPath.row == 1 {
                        cell.deleteButton.hidden = true
                        cell.managerLabel.hidden = false
                    }
                    else {
                        cell.deleteButton.hidden = false
                        cell.managerLabel.hidden = true
                        cell.deleteButton.tag = indexPath.row - 1
                        cell.deleteButton.userInteractionEnabled = false
                    }
                    return cell
                }
            }
            else {
                let cell:EFLPoolPlayerCell = tableView.dequeueReusableCellWithIdentifier(poolPlayerCellIdentifier) as! EFLPoolPlayerCell
                let player = playerArray[indexPath.row] as NSManagedObject
                cell.setPlayerData(player)
                cell.separatorInset = UIEdgeInsetsZero
                cell.layoutMargins = UIEdgeInsetsZero
                cell.selectionStyle = .None
                
                cell.deleteButton.hidden = true
                if indexPath.row == 0 {
                    cell.managerLabel.hidden = false
                }
                else {
                    cell.managerLabel.hidden = true
                }
                return cell
            }
        }
    }
    
    
    // MARK: UI Tableview Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 50
        }
        else if indexPath.section == 1 {
            if poolRoomDetails!.valueForKey("message") != nil {
                messageTextView.text = poolRoomDetails!.valueForKey("message") as? String
                messageTextView.font = FONT_REGULAR_16
                let size: CGSize = messageTextView.sizeThatFits(CGSizeMake(tableView.frame.size.width - 32, CGFloat.max));
                //let insets: UIEdgeInsets = messageTextView.textContainerInset;
                if size.height < 66.0 {
                    return size.height + 30
                }
                else {
                    return size.height + 20
                }

                //return size.height + insets.top + insets.bottom ;
            }else{
                return 66
            }
        }
        else {
            
            if self.isManager() {
                if indexPath.row == 0 {
                    return 30
                }
                else {
                    return 50
                }
            }
            else {
                return 50
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: - Helper Methods
    func getTableHeader(section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let view = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 24))
        view.backgroundColor = UIColor.clearColor()
        
        let label = UILabel.init(frame: CGRectMake(16, 0, CGRectGetWidth(view.frame), 24))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.eflBlackColor()
        label.font = FONT_MEDIUM_16
        if section == 1 {
            label.text = "POOL_MESSAGE_HEADER_TEXT".localized
        }
        else if section == 2 {
            label.text = "POOL_PLAYERS_HEADER_TEXT".localized
            let labelPlayers = UILabel.init(frame: CGRectMake(CGRectGetWidth(view.frame) - 216, 0, 200, 24))
            
            labelPlayers.backgroundColor = UIColor.clearColor()
            labelPlayers.textColor = UIColor.eflMidGreyColor()
            labelPlayers.font = FONT_REGULAR_16
            labelPlayers.textAlignment = NSTextAlignment.Right
            
            labelPlayers.text = String(playerArray.count) + "/100 players added"
            
            view.addSubview(labelPlayers)
            
        }
        view.addSubview(label)
        return view
    }
    
    // MARK: Helper Methods
    
    func isManager() -> Bool {
        
        if let playerList = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomPlayersFromCache(poolRoomDetails!.valueForKey("poolroom_id") as! String)
        {
            for player in playerList {
                if player.valueForKey("invite_status") as? String == "Manager" {
                    if (player.valueForKey("player_id") as? String) == EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY) {
                        return true
                    }
                }
            }
        }
        return false
    }

    // MARK: EFLSegmentedControlDelegate Methods
    func segmentedControlDidSelectIndex(segmentedControl: EFLSegmentedControl, selectedIndex: Int) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
