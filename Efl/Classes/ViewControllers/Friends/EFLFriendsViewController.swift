//
//  EFLFriendsViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 29/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Social
import CoreData
import MessageUI

class EFLFriendsViewController: EFLBaseViewController, EFLFriendsShareActionSheetDelegate, FBSDKGameRequestDialogDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var pointerImageView: UIImageView!
    @IBOutlet weak var emptyFriendsImageView: UIImageView!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var textConstraint: NSLayoutConstraint!
    
    var overLayView: UIView?
    var actionSheetView:EFLFriendsShareActionSheet?
    var friendListArray = [NSManagedObject]()
    
    var searchFriendBar: UISearchBar = UISearchBar (frame: CGRectMake(0,0,0,40))
    var seperationView: UIView = UIView (frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUIComponents()
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(EFLFriendsViewController.handleTap))
        friendsTableView.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view.
    }
    
    override func initialiseView() {
        self.addRightBarButtonItem()
        self.navigationItem.title = "FRIENDS_TITLE".localized
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        friendsTableView.registerNib(UINib(nibName: "EFLFriendListCell", bundle: nil), forCellReuseIdentifier: friendListCellIdentifier)
        friendsTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: REFRESH_DATA_NOTIFICATION, object: nil)
        if EFLManager.sharedManager.isFriendsRefreshed {
            self.loadUIComponents()
        }
        resetSearchBarPosition()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: REFRESH_DATA_NOTIFICATION, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UI Methods
    
    func addRightBarButtonItem() {
        let rightButtonitem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"NavigationPlusButtonWhiteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EFLFriendsViewController.rightBarButtonItemDidPress))
        rightButtonitem.tintColor = UIColor.eflWhiteColor()
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = 0
        self.navigationItem.setRightBarButtonItems([negativeSpace,rightButtonitem], animated: true)
    }
    
    func addSearchBar(){
        //Search Bar set up
        searchFriendBar.placeholder = "Search";
        searchFriendBar.backgroundColor = UIColor.eflWhiteColor()
        searchFriendBar.barTintColor = UIColor.eflRedColor()
        searchFriendBar.searchBarStyle = UISearchBarStyle.Minimal;
        searchFriendBar.delegate = self;
        
        //View seperating Searchbar + TableView
        seperationView.frame = (CGRectMake(0, searchFriendBar.frame.size.height - 0.5, self.view!.frame.size.width, 0.5))
        seperationView.backgroundColor = friendsTableView.separatorColor;
        
        //Adding Header
        friendsTableView.tableHeaderView = searchFriendBar;
        friendsTableView.tableHeaderView!.addSubview(seperationView)
    }
    
    func reloadData() {
        EFLManager.sharedManager.isFriendsRefreshed = false
        dispatch_async(dispatch_get_main_queue(),{
            self.loadUIComponents()
        })
    }
    
    func reloadTableData() {
        friendsTableView.reloadData()
    }
    
    func loadUIComponents() {
        if let array = EFLPlayerDataManager.sharedDataManager.getFriendsFromCache() {
            friendListArray = array as! [NSManagedObject]
            self.handleUIEmptyState(true)
            addSearchBar()
            self.reloadTableData()
            //To do
            //Update friend list cache parallely
        }
        else {
            if IS_IPHONE4 {
                imageConstraint.constant = -20.0
                textConstraint.constant = -40.0
            }
            self.handleUIEmptyState(false)
            
            EFLAPIManager.sharedAPIManager.getFriends({ (status) in
                print("getFriends \(status)")

                if status == CompletionStatusSuccess {
                    if let array = EFLPlayerDataManager.sharedDataManager.getFriendsFromCache() {
                        self.friendListArray = array as! [NSManagedObject]
                        self.handleUIEmptyState(true)
                        self.reloadTableData()
                    }
                }
            })
        }
    }
    
    func handleUIEmptyState(isDataToLoad: Bool) {
        friendsTableView.hidden = !isDataToLoad
        pointerImageView.hidden = isDataToLoad
        emptyFriendsImageView.hidden = isDataToLoad
        topContainerView.hidden = isDataToLoad
    }
    
    func handleTap(){
        UIView .animateWithDuration(0.5, animations: {
            self.searchFriendBar.resignFirstResponder()
        });
    }
    
    func resetSearchBarPosition(){
        if (!friendsTableView.hidden) {
            searchFriendBar.text = EmptyString
            loadUIComponents()
            let heightOffset = CGPointMake(0, friendsTableView.tableHeaderView!.frame.size.height);
            friendsTableView.contentOffset = heightOffset;
        }
    }
    
    //MARK: Selector Methods
    
    func rightBarButtonItemDidPress() {
        
        self.searchFriendBar.resignFirstResponder()
        if ReachabilityManager.isReachable() {
            overLayView = UIView.init(frame: APP_DELEGATE.window!.frame)
            overLayView!.backgroundColor = UIColor.eflBlackColor()
            overLayView!.alpha = 0.5
            
            actionSheetView = EFLFriendsShareActionSheet.init(frame: CGRectMake(7, CGRectGetHeight(APP_DELEGATE.window!.frame), CGRectGetWidth(self.view.bounds) - 14, 407))
            actionSheetView!.delegate = self
            UIView.animateWithDuration(Double(0.4), animations: {
                APP_DELEGATE.window?.addSubview(self.overLayView!)
                APP_DELEGATE.window?.addSubview(self.actionSheetView!)
                
                self.actionSheetView!.frame = CGRectMake(7, CGRectGetHeight(APP_DELEGATE.window!.frame) - 414, CGRectGetWidth(self.view.bounds) - 14, 407)
            })
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
        }
    }
    
    // MARK: API Methods
    func upateFriends(recipients:[String]) { // Invite friends from Facebook
        
        EFLActivityIndicator.sharedSpinner.showIndicator()
        let requestModel = EFLFriendsUpdateRequestModel()
        requestModel.facebook_ids = recipients
        
        EFLFriendsAPI().updateFriends(requestModel) { (error, data) -> Void in
            EFLActivityIndicator.sharedSpinner.hideIndicator()
            if !error.isKindOfClass(APIErrorTypeNone){
                print(error.code)
                EFLUtility.showOKAlertWithMessage("ALERT_FAILURE_MESSAGE".localized.localized, andTitle: "ALERT_FAILURE_TITLE".localized)
                return
            }
            else
            {
                let response = (data as! EFLFriendsResponse)
                self.viewWillAppear(true)
                
                if response.status == ResponseStatusSuccess {
                    EFLPlayerDataManager.sharedDataManager.syncFriends(response.data!)
                    self.loadUIComponents()
                }
                else {
                    self.handleResponseFailure(response)
                }
            }
        }
    }
    
    // MARK: Hanlde login response
    func handleResponseFailure(response: EFLFriendsResponse) {
        print(response.message)
    }
    
    
    // MARK: UITableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendListArray.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:EFLFriendListCell = tableView.dequeueReusableCellWithIdentifier(friendListCellIdentifier) as! EFLFriendListCell
        let userFriend: NSManagedObject? = friendListArray[indexPath.row]
        cell.selectButton.hidden = true
        if let user = userFriend {
            cell.setUSerFriendImage(user.valueForKey("playerId") as! String, imageURL: user.valueForKey("imageURL") as? String)
            let firstName = user.valueForKey("firstName") as? String
            let lastName = user.valueForKey("lastName") as? String
            cell.nameLabel.text = firstName! + " " + lastName!
            if let boolValue = user.valueForKey("isSignedUp") as? Bool {
                if !boolValue {
                    cell.statusLabel.hidden = false
                    cell.nameTopContraint.constant = 3
                }
                else {
                    cell.statusLabel.hidden = true
                    cell.nameTopContraint.constant = 12
                }
            }
        }
        if indexPath.row == friendListArray.count - 1 {
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
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: UI SearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.handleTap()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count == 0) {
            let searchDataSource = EFLPlayerDataManager.sharedDataManager.getFriendsFromCache()
            friendListArray = searchDataSource as! [NSManagedObject]
            friendsTableView .reloadData()
        }
        else {
            let textArraySeperartedBySpace = searchBar.text!.componentsSeparatedByString(" ");
            var firstName = searchBar.text;
            var lastName = searchBar.text;
            var predicate: NSPredicate?
            
            if(textArraySeperartedBySpace.count > 1){
                firstName = textArraySeperartedBySpace[0];
                lastName = textArraySeperartedBySpace[1];
                
                predicate = NSPredicate (format:"(firstName CONTAINS[cd] %@ AND lastName CONTAINS[cd] %@) OR (firstName CONTAINS[cd] %@ AND lastName CONTAINS[cd] %@)", firstName!, lastName!, lastName!, firstName!);
                
                if textArraySeperartedBySpace[1] == "" {
                    predicate = NSPredicate (format:"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", String(firstName!.characters.dropLast()), String(lastName!.characters.dropLast()));
                }
            } else {
                predicate = NSPredicate (format:"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", firstName!, lastName!);
            }
            let searchDataSource = (EFLPlayerDataManager.sharedDataManager.getFriendsFromCache()as! [NSManagedObject]).filter{ predicate!.evaluateWithObject($0) }
            
            friendListArray = searchDataSource;
            friendsTableView .reloadData()
        }
    }
    
    //MARK:  ActionSheetDelegate Method
    
    func actionSheetSelected(tag: Int) {
        
        UIView.animateWithDuration(0.4, animations: {
            self.actionSheetView!.frame = CGRectMake(7, CGRectGetHeight(APP_DELEGATE.window!.frame), CGRectGetWidth(self.view.bounds) - 14, 355)
        }) { (Void) in
            self.overLayView?.removeFromSuperview()
            self.actionSheetView?.removeFromSuperview()
        }
        
        if tag == 0 {
            self.showGameRequestDialogue()
        }
        else if tag == 4 {
            self.tweet()
        }
        else if tag == 5 {
            self.email()
        }
        else if tag == 6 {
            self.showShareDialogue()
        }
        
    }
    
    // MARK: Show FBSDKGameRequestDialog
    func showGameRequestDialogue() {
        let inviteDialog:FBSDKGameRequestContent = FBSDKGameRequestContent()
        inviteDialog.filters = FBSDKGameRequestFilter.AppNonUsers
        inviteDialog.message = "SHARE_MESSAGE".localized
        inviteDialog.title = "INVITE_FRIENDS_GAME_REQUEST_TITLE".localized
        FBSDKGameRequestDialog.showWithContent(inviteDialog, delegate: self)
    }
    
    // MARK: FBSDKGameRequestDialogDelegate Methods
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]?) {
        if results != nil {
            let recipients = results!["to"] as? [String]
            if recipients?.count > 0 {
                print(recipients!)
                self.upateFriends(recipients!)
            }
        }
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        EFLFacebookManager.sharedFacebookManager.setFacebookPermissionsWith { (loginResult, error) in
            if (error != nil) {
                EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
            } else if loginResult.isCancelled {
                print("User cancelled authentication")
            }
            else {
                EFLActivityIndicator.sharedSpinner.showIndicator()
                self.updateAccesToken(FBSDKAccessToken.currentAccessToken().tokenString)
            }
        }
    }
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
    }
    
    //MARK: Update Access_Token To Server
    func updateAccesToken(accessToken :String) {
        let requestModel = EFLPlayerUpdateRequestModel()
        requestModel.facebook_token = EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY)
        
        EFLActivityIndicator.sharedSpinner.showIndicator()
        EFLPlayerAPI().updatePlayer(requestModel) { (error, data) -> Void in
            EFLActivityIndicator.sharedSpinner.hideIndicator()
            if !error.isKindOfClass(APIErrorTypeNone){
                return
            }
            else {
                let response = (data as! EFLPlayerResponse)
                if let authorizationToken = response.data!.jwt_token {
                    EFLUtility.saveValuesToUserDefaults(authorizationToken, key: AUTHORIZATION_TOKEN_KEY)
                }
                EFLUtility.saveValuesToUserDefaults(accessToken, key: FB_ACCESS_TOKEN_KEY)
                self.showGameRequestDialogue()
            }
        }
    }
    
    //MARK: Tweet action
    func tweet() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("SHARE_MESSAGE".localized)
            vc.addURL(NSURL(string: "http://example.com"))
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: Email action
    func email() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            
            mailComposerVC.setSubject("Friendlies")
            mailComposerVC.setMessageBody("SHARE_MESSAGE".localized + " " + "http://example.com", isHTML: true)
            
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            EFLUtility.showOKAlertWithMessage("NO_EMAIL_ACCOUNT_MESSAGE".localized, andTitle: "NO_EMAIL_ACCOUNT_TITLE".localized)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:  More action
    func showShareDialogue() {
        let string: String = "SHARE_MESSAGE".localized
        let URL: NSURL = NSURL(string: "http://example.com")!
        
        let activityViewController = UIActivityViewController(activityItems: [string, URL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop]
        self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
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
