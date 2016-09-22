//
//  EFLRoomsViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 29/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

class EFLRoomsViewController: EFLBaseViewController, EFLAlertViewDelegate {
    @IBOutlet weak var roomsTableView: UITableView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var pointerImageView: UIImageView!
    @IBOutlet weak var emptyFriendsImageView: UIImageView!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var textConstraint: NSLayoutConstraint!
    
    var indicatorView: UIView? = nil
    var roomsArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: REFRESH_DATA_NOTIFICATION, object: nil)
        if EFLManager.sharedManager.isRoomsRefreshed {
            self.populateView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: REFRESH_DATA_NOTIFICATION, object: nil)
    }
    
    override func initialiseView() {
        self.addRightBarButtonItem()
        //        self.navigationItem.title = "ROOMS_TITLE".localized
        self.showUpdateIndicator()
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        
        roomsTableView.registerNib(UINib(nibName: "EFLRoomListCell", bundle: nil), forCellReuseIdentifier: roomListCellIdentifier)
        roomsTableView.tableFooterView = UIView()
        
        if IS_IPHONE4 {
            imageConstraint.constant = -20.0
            textConstraint.constant = -40.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Methods
    
    //MARK: Update indicator
    func showUpdateIndicator() {
        
        if indicatorView == nil {
            indicatorView = UIView.init(frame: CGRectMake(0, 0, 150, 44))
            indicatorView?.backgroundColor = UIColor.clearColor()
            
            let spinnerImageView = UIImageView(frame: CGRectMake(30, (CGRectGetHeight(indicatorView!.frame) - 19) / 2, 19, 19))
            let image: UIImage = UIImage(named: SpinnerWhiteSmallIcon)!
            spinnerImageView.image = image
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = 2*M_PI
            rotationAnimation.duration = 1.5
            rotationAnimation.repeatCount = Float.infinity
            spinnerImageView.layer.addAnimation(rotationAnimation, forKey: nil)
            indicatorView?.addSubview(spinnerImageView)
            
            let label = UILabel.init(frame: CGRectMake(54, 0, 95, 44))
            label.font = FONT_REGULAR_19
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.eflWhiteColor()
            label.text = "Updating..."
            indicatorView?.addSubview(label)
            
            self.navigationItem.titleView = indicatorView
            
        }
        self.performSelector(#selector(self.hideUpdateIndicator), withObject: nil, afterDelay: 5)
    }
    
    func hideUpdateIndicator() {
        if indicatorView != nil {
            indicatorView?.removeFromSuperview()
            self.navigationItem.titleView = nil
        }
        self.navigationItem.title = "ROOMS_TITLE".localized
    }
    
    
    func addRightBarButtonItem() {
        let rightButtonitem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"NavigationPlusButtonWhiteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EFLRoomsViewController.rightBarButtonItemDidPress))
        rightButtonitem.tintColor = UIColor.eflWhiteColor()
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = 0
        self.navigationItem.setRightBarButtonItems([negativeSpace,rightButtonitem], animated: true)
    }
    
    func populateView() {
        print("Populating rooms from cache")
        if let array = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomsFromCache() {
            roomsArray.removeAll()
            print("Fetched \(array.count) rooms from cache")
            
            roomsArray = array as! [NSManagedObject]
            self.handleUIEmptyState(true)
            self.reloadTableData()
            //To do
            //Update friend list cache parallely
        }
        else {
            self.handleUIEmptyState(false)
        }
    }
    
    func handleUIEmptyState(isDataToLoad: Bool) {
        roomsTableView.hidden = !isDataToLoad
        pointerImageView.hidden = isDataToLoad
        emptyFriendsImageView.hidden = isDataToLoad
        topContainerView.hidden = isDataToLoad
    }
    
    func reloadData() {
        print("Notification received")
        
        EFLManager.sharedManager.isRoomsRefreshed = false
        dispatch_async(dispatch_get_main_queue(),{
            self.populateView()
        })
    }
    
    func reloadTableData() {
        roomsTableView.reloadData()
    }
    
    func parseDate(dateString: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(dateString)
        let calendar = NSCalendar.currentCalendar()
        if date != nil {
            let components = calendar.components([.Day , .Month , .Year], fromDate: date!)
            let month = components.month
            let day : String = String (components.day)
            let monthString : String = NSDateFormatter().monthSymbols[month - 1]
            let index = monthString.startIndex.advancedBy(3)
            return "\(day) \(monthString.substringToIndex(index))"
        }else {
            var dateReceivedInString : NSString = dateString .stringByReplacingOccurrencesOfString("T", withString: " ")
            dateReceivedInString = dateReceivedInString .stringByReplacingOccurrencesOfString("Z", withString: "")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(dateReceivedInString as String)
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date!)
            let month = components.month
            let day : String = String (components.day)
            let monthString : String = NSDateFormatter().monthSymbols[month - 1]
            let index = monthString.startIndex.advancedBy(3)
            return "\(day) \(monthString.substringToIndex(index))"
        }
    }
    //MARK: Selector Methods
    
    func rightBarButtonItemDidPress() {
        
        if ReachabilityManager.isReachable() {            
            let alert = EFLAlertView.alertView()
            alert.show()
            alert.delegate = self
        }
        else {
              EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
        }
    }
    
    // MARK: UITableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsArray.count
    }
    
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:EFLRoomListCell = tableView.dequeueReusableCellWithIdentifier(roomListCellIdentifier) as! EFLRoomListCell
        
        let roomDetails: NSManagedObject? = roomsArray[indexPath.row]
        if let room = roomDetails {
            cell.roomTitle.text = room.valueForKey("pool_name") as? String
            if let date = room.valueForKey("last_updated_on") {
                cell.timeStamp.text = self.parseDate((date as? String)!)
            }
            if room.valueForKey("pool_image") != nil {
                cell.setPoolRoomImage(room.valueForKey("poolroom_id") as! String, imageURL: room.valueForKey("pool_image") as? String)
            }
            else {
                cell.roomAvatar.image = UIImage(named: AvatarPool50x50)
            }
            if self.isAcceptedStatus(room) {
                cell.cellViewforNotificationRead()
            }else {
                cell.cellViewforUnreadNotification()
            }
        }
        
        if indexPath.row == roomsArray.count - 1 {
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        else {
            cell.separatorInset.left = 72
        }
        return cell
    }
    
    //MARK: UI Tableview Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let roomDetails: NSManagedObject? = roomsArray[indexPath.row]
        if self.isAcceptedStatus(roomDetails) {
            let poolDetailsVC = self.storyboard?.instantiateViewControllerWithIdentifier(POOL_DETAILS_VIEW_CONTROLLER_ID) as? EFLPoolDetailsViewController
            poolDetailsVC?.poolRoomDetails = roomDetails!
            self.navigationController?.pushViewController(poolDetailsVC!, animated: true)
        }
        else {
            let actionPoolVC = self.storyboard?.instantiateViewControllerWithIdentifier(POOL_ACTION_VIEW_CONTROLLER_ID) as? EFLPoolActionViewController
            actionPoolVC?.poolRoomDetails = roomDetails!
            self.navigationController?.pushViewController(actionPoolVC!, animated: true)
        }
    }
    
    //MARK: Helper Methods
    
    func isManager(roomDetails: NSManagedObject?) -> Bool {
        
        if let playerList = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomPlayersFromCache(roomDetails!.valueForKey("poolroom_id") as! String)
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
    
    //Check invite status
    func isAcceptedStatus(roomDetails: NSManagedObject?) -> Bool {
        
        if let playerList = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomPlayersFromCache(roomDetails!.valueForKey("poolroom_id") as! String)
        {

            for player in playerList {
                if (player.valueForKey("player_id") as? String) == EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY) {
                    if player.valueForKey("invite_status") as? String == "Manager" || player.valueForKey("invite_status") as? String == "Accepted" {
                        return true
                    }
                }
            }
        }
        return false
    }
    
}

extension EFLRoomsViewController { // EFLAlertViewDelegate
    
    func challengeButtonClickWithAlertView(view: EFLAlertView) {
        
    }
    
    func poolButtonClickWithAlertView(view: EFLAlertView){
        
    }
}
