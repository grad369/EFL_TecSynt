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


class EFLFriendsViewController: EFLBaseViewController, FBSDKGameRequestDialogDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var pointerImageView: UIImageView!
    @IBOutlet weak var emptyFriendsImageView: UIImageView!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var textConstraint: NSLayoutConstraint!
    
    var alphabeticalFriends: [String : [Friends]]?
    
    var searchFriendBar: UISearchBar = UISearchBar (frame: CGRectMake(0,0,0,40))
    var seperationView: UIView = UIView (frame: CGRectZero)
    
    lazy var spinner: EFLActivityIndicator = {
        return EFLActivityIndicator (supView: APP_DELEGATE.window!, size: CGSizeMake(40, 40))
    }()
    
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
}


// MARK: - EFLBaseViewController functions
extension EFLFriendsViewController {
    
    override func configurationNavigationAndStatusBars() {
        self.setConfigurationStatusBar(.Green)
        self.setConfigurationNavigationBar("FRIENDS_TITLE".localized, titleView: nil, backgroundColor: .Green)
        self.setBarButtonItem(.AddFriends, placeType: .Right, tintColorType: .White)
        self.setBarButtonItem(.Share, placeType: .Left, tintColorType: .White)
    }
    
    override func configurationView() {
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        friendsTableView.registerNib(UINib(nibName: "EFLFriendListCell", bundle: nil), forCellReuseIdentifier: friendListCellIdentifier)
        friendsTableView.tableFooterView = UIView()
        
        self.addSearchBar()
        self.loadUIComponents()
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(EFLFriendsViewController.handleTap))
        friendsTableView.addGestureRecognizer(recognizer)
    }
}


// MARK: - Actions
extension EFLFriendsViewController {
    
    func rightBarButtonItemDidPress() {
        self.searchFriendBar.resignFirstResponder()
        if ReachabilityManager.isReachable() {
            self.showGameRequestDialogue()
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
        }
    }
    
    func leftBarButtonItemDidPress() {
        self.showActivityController()
    }
    
    func handleTap(){
        UIView.animateWithDuration(0.5, animations: {
            self.searchFriendBar.resignFirstResponder()
        })
    }
    
    func reloadData() {
        EFLManager.sharedManager.isFriendsRefreshed = false
        dispatch_async(dispatch_get_main_queue(),{
            self.loadUIComponents()
        })
    }
}


// MARK: UITableView DataSource Methods
extension EFLFriendsViewController {
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if alphabeticalFriends == nil {
            return 0
        } else {
            return alphabeticalFriends!.keys.count
        }
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if alphabeticalFriends != nil {
            let symbols = sortedSymbols()!
            let friends = alphabeticalFriends![symbols[section]]! as [Friends]
            return friends.count
        } else {
            return 0
        }
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: EFLFriendListCell = tableView.dequeueReusableCellWithIdentifier(friendListCellIdentifier) as! EFLFriendListCell
        
        let symbols = sortedSymbols()!
        let friends = alphabeticalFriends![symbols[indexPath.section]]! as [Friends]
        
        let userFriend: NSManagedObject? = friends[indexPath.row]
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
    
        if indexPath.row == friends.count - 1 {
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        else {
            cell.separatorInset.left = 72
        }
        return cell
    }
}


// MARK: UI Tableview Delegate
extension EFLFriendsViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRectMake(16, 8, 40, 15))
        label.textColor = UIColor.eflMidGreyColor()
        label.font = FONT_REGULAR_16
        
        if alphabeticalFriends != nil {
            label.text = sortedSymbols()![section]
        } else {
            label.text = EmptyString
        }
        
        let view = UIView(frame: CGRectMake(0, 0, 50, 26))
        view.addSubview(label)
        return view
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if alphabeticalFriends == nil {
            return [""]
        } else {
            return self.sortedSymbols()
        }
    }
}


// MARK: UI SearchBar Delegate
extension EFLFriendsViewController {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.handleTap()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count == 0) {
            alphabeticalFriends = EFLPlayerDataManager.sharedDataManager.getAlphabeticalFriends()
            friendsTableView.reloadData()
        }
        else {
            let textArraySeperartedBySpace = searchBar.text!.componentsSeparatedByString(" ");
            var firstName = searchBar.text
            var lastName = searchBar.text
            var predicate: NSPredicate?
            
            if(textArraySeperartedBySpace.count > 1) {
                firstName = textArraySeperartedBySpace[0]
                lastName = textArraySeperartedBySpace[1]
                
                predicate = NSPredicate (format:"(firstName CONTAINS[cd] %@ AND lastName CONTAINS[cd] %@) OR (firstName CONTAINS[cd] %@ AND lastName CONTAINS[cd] %@)", firstName!, lastName!, lastName!, firstName!);
                
                if textArraySeperartedBySpace[1] == "" {
                    predicate = NSPredicate (format:"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", String(firstName!.characters.dropLast()), String(lastName!.characters.dropLast()));
                }
            } else {
                predicate = NSPredicate (format:"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", firstName!, lastName!);
            }
            
            let searchDataSource = EFLPlayerDataManager.sharedDataManager.getAlphabeticalFriends({ (friends: [Friends]) -> [Friends] in
                return friends.filter{ predicate!.evaluateWithObject($0)
            }})
            
            alphabeticalFriends = searchDataSource;
            friendsTableView.reloadData()
        }
    }
}


// MARK: - API Methods
extension EFLFriendsViewController {
    
    func updateFriends(recipients:[String]) { // Invite friends from Facebook
        
        self.spinner.showIndicator()
        
        let requestModel = EFLFriendsUpdateRequestModel()
        requestModel.facebook_ids = recipients.joinWithSeparator(",")
        
        EFLFriendsAPI().updateFriends(requestModel) { (error, data) -> Void in
            self.spinner.hideIndicator()
            
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
}


// MARK: - FBSDKGameRequestDialog
extension EFLFriendsViewController {
    
    func showGameRequestDialogue() {
        if FBSDKAccessToken.currentAccessToken() == nil {
            let i=0
        } else {
            let i=0
        }
        //EFLFacebookManager.sharedFacebookManager.getFacebookFriendIds { (facebookIds) in
        //}
        let inviteDialog: FBSDKGameRequestContent = FBSDKGameRequestContent()
        //inviteDialog.filters = FBSDKGameRequestFilter.AppNonUsers
        inviteDialog.recipientSuggestions = ["AaL45G939mHiIHc_TTuNKAy7TwlXR4tC8KwNsMLpxCecY3MKVHMIlR1oZUMwKUmOAT_vl5mcMbGs8cWrcYREN2959IQHUHLBY9STNbiRW1VvbA"]
        inviteDialog.message = "SHARE_MESSAGE".localized
        inviteDialog.title = "INVITE_FRIENDS_GAME_REQUEST_TITLE".localized
        FBSDKGameRequestDialog.showWithContent(inviteDialog, delegate: self)
    }
    
    // FBSDKGameRequestDialogDelegate Methods
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]?) {
        if results != nil {
            let recipients = results!["to"] as? [String]
            if recipients?.count > 0 {
                print(recipients!)
                self.updateFriends(recipients!)
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
                self.spinner.showIndicator()
                
                self.updateAccesToken(FBSDKAccessToken.currentAccessToken().tokenString)
            }
        }
    }
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        
    }
}


// MARK: Update Access_Token To Server
extension EFLFriendsViewController {
    
    func updateAccesToken(accessToken :String) {
        let requestModel = EFLPlayerUpdateRequestModel()
        requestModel.facebook_token = EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY)
    
        self.spinner.showIndicator()
        
        EFLPlayerAPI().updatePlayer(requestModel) { (error, data) -> Void in
            self.spinner.hideIndicator()
            
            if !error.isKindOfClass(APIErrorTypeNone){
                return
            }
            else {
                let response = (data as! EFLPlayerResponse)
                if let authorizationToken = response.data!.player!.jwt_token {
                    EFLUtility.saveValuesToUserDefaults(authorizationToken, key: AUTHORIZATION_TOKEN_KEY)
                }
                EFLUtility.saveValuesToUserDefaults(accessToken, key: FB_ACCESS_TOKEN_KEY)
                self.showGameRequestDialogue()
            }
        }
    }
}


// MARK: - Private functions
private extension EFLFriendsViewController {
    
    func addSearchBar() {
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
    
    func reloadTableData() {
        friendsTableView.reloadData()
    }
    
    func loadUIComponents() {
        if let array = EFLPlayerDataManager.sharedDataManager.getAlphabeticalFriends() {
            alphabeticalFriends = array
            self.handleUIEmptyState(true)
            self.reloadTableData()
            //To do
            //Update friend list cache parallely
        } else {
            self.handleUIEmptyState(false)
            
            EFLAPIManager.sharedAPIManager.getFriends({ (status) in
                print("getFriends \(status)")
                
                if status == CompletionStatusSuccess {
                    if let array = EFLPlayerDataManager.sharedDataManager.getAlphabeticalFriends() {
                        self.alphabeticalFriends = array
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
    
    func resetSearchBarPosition() {
        if (!friendsTableView.hidden) {
            searchFriendBar.text = EmptyString
            loadUIComponents()
            let heightOffset = CGPointMake(0, friendsTableView.tableHeaderView!.frame.size.height);
            friendsTableView.contentOffset = heightOffset;
        }
    }
    
    // MARK: Hanlde login response
    func handleResponseFailure(response: EFLFriendsResponse) {
        //print(response.message)
    }
    
    func sortedSymbols() -> [String]? {
        guard alphabeticalFriends != nil else {
            return nil
        }
        
        return alphabeticalFriends?.keys.sort({ (char1, char2) -> Bool in
            char1 < char2
        })
    }

    func showActivityController() {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            guard let data = NSData(contentsOfURL: NSURL(string: URL_SHARE_IMAGE)!) else {
                return
            }
            
            let string: String = "SHARE_MESSAGE".localized
            let URL: NSURL = NSURL(string: URL_SHARE_LINK)!
            let image = UIImage(data: data)
            
            dispatch_async(dispatch_get_main_queue(), { 
                let activityViewController = UIActivityViewController(activityItems: [string, URL, image!], applicationActivities: nil)
                activityViewController.setValue("SHARE_SUBJECT".localized, forKey: "subject")
                
                activityViewController.excludedActivityTypes = [
                    UIActivityTypePrint,
                    UIActivityTypeAssignToContact,
                    UIActivityTypeSaveToCameraRoll,
                    UIActivityTypeAddToReadingList,
                    UIActivityTypeAirDrop,
                    UIActivityTypePostToFlickr,
                    UIActivityTypePostToVimeo]
                
                self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
            })
        })
    }
    
    func recipientSuggests() -> [String]? {
        let facebookIds = self.facebookIds()
        return facebookIds
    }
    
    func facebookIds() -> [String]? {
        guard alphabeticalFriends != nil else {
            return nil
        }
        
        var facebookIds = [String]()
        for symbol in alphabeticalFriends!.keys {
            for friend: Friends in alphabeticalFriends![symbol]! {
                facebookIds.append(friend.facebookId!)
            }
        }
        
        return facebookIds
    }
}
