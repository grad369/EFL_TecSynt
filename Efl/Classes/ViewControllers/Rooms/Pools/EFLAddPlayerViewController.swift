//
//  EFLAddPlayerViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import FBSDKShareKit
import CoreData

protocol AddPlayerDelegate{
    func reloadPoolRequestWithSelectedPlayers(players: [EFLAddPlayerModel])
}

class EFLAddPlayerViewController: EFLBaseViewController, EFLSegmentedControlDelegate, FBSDKGameRequestDialogDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var pointerImageView: UIImageView!
    @IBOutlet weak var emptyFriendsImageView: UIImageView!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textConstraint: NSLayoutConstraint!

    var headerView: UIView = UIView (frame: CGRectMake(0,0,0,50))
    var searchFriendBar: UISearchBar = UISearchBar ()
    var seperationView: UIView = UIView (frame: CGRectZero)
    
    var delegate:AddPlayerDelegate?

    let segmentedControl =  EFLSegmentedControl()
    
    var completefriendListArray = [EFLFriendListModel]() // Prior to any Search
    var friendListArray = [EFLFriendListModel]()
    var selectedPlayers = [EFLAddPlayerModel]()
    
    var spinner = EFLActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

//        let recognizer = UITapGestureRecognizer(target: self, action:#selector(EFLAddPlayerViewController.handleTap))
//        friendsTableView.addGestureRecognizer(recognizer)
//        self.view.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
        if (!friendsTableView.hidden) {
            let heightOffset = CGPointMake(0, 39);
            friendsTableView.contentOffset = heightOffset;
        }
    }

    override func initialiseView() {
        
        if IS_IPHONE4 {
            textConstraint.constant = -25.0
            imageConstraint.constant = 15.0
        }
        let length = (CGRectGetWidth(self.view.frame) - 32 ) / 2
        let half = (length / 2) + 16
        let constraint = half - 20.5
        imageTrailingConstraint.constant = constraint


        searchFriendBar.text = ""

        self.addNavigationCancelButton()
        self.addRightBarButtonItem()        
        self.navigationItem.title = "ADD_PLAYERS_TITLE".localized
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        
        segmentedControl.setUpControl(UIColor.eflGreenColor(), buttonTitles: ["POOL_FRIENDS_TEXT".localized, "POOL_INVITE_TEXT".localized])
        self.view.addSubview(segmentedControl)
        segmentedControl.delegate = self
        segmentedControl.setSelectedIndex(1)
        
        friendsTableView.registerNib(UINib(nibName: "EFLFriendListCell", bundle: nil), forCellReuseIdentifier: friendListCellIdentifier)
        friendsTableView.tableFooterView = UIView()
        self.loadUIComponents()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navController: EFLBaseNavigationController = self.navigationController as! EFLBaseNavigationController
        navController.removeNavigationBarSperarationView()
        segmentedControl.addShadowLayer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let navController: EFLBaseNavigationController = self.navigationController as! EFLBaseNavigationController
        
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.clearColor()
        }

        navController.setShadow()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Methods
    
    func addRightBarButtonItem() {
        
        let okButton = UIButton.init(type: UIButtonType.System)
        okButton.frame = CGRectMake(0, 0, 70, 44)
        okButton.backgroundColor = UIColor.clearColor()
        okButton.setTitle("ALERT_OK_BUTTON_TITLE".localized, forState: UIControlState.Normal)
        okButton.titleLabel?.font = FONT_REGULAR_19
        okButton.addTarget(self, action: #selector(okButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
        okButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        okButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0)

        let backButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: okButton)
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = 0
        self.navigationItem.setRightBarButtonItems([negativeSpace,backButtonItem], animated: true)
        self.activateOkButton()
    }
    
    func activateOkButton() {
        let barButtonItem = self.navigationItem.rightBarButtonItems![1]
        let okButton = barButtonItem.customView as! UIButton
        
        if selectedPlayers.count > 0 {
            okButton.setTitleColor(UIColor.eflWhiteColor(), forState: UIControlState.Normal)
            okButton.userInteractionEnabled = true
        }
        else {
            okButton.setTitleColor(UIColor.efllighterGreyColor(), forState: UIControlState.Normal)
            okButton.userInteractionEnabled = false
        }
    }
    
    func loadUIComponents() {
        topContainerView.hidden = false
        emptyFriendsImageView.hidden = false
        pointerImageView.hidden = false
        friendsTableView.hidden = true
        searchFriendBar.hidden = true
        seperationView.hidden = true

        if let array = EFLPlayerDataManager.sharedDataManager.getFriendsFromCache() {
            topContainerView.hidden = true
            emptyFriendsImageView.hidden = true
            pointerImageView.hidden = true
            friendsTableView.hidden = false
            self.addSearchBar()
            
            for value in array {
                let response  = EFLFriendListModel().initWithData(value)
                if !friendListArray.contains( { $0.playerId == response.playerId }) {
                    if selectedPlayers.contains( { $0.player_id == Int (response.playerId) }) {
                        response.isSelected = true
                    }
                    friendListArray.append(response)
                    completefriendListArray.append(response)
                }
            }
            friendsTableView.reloadData()
        }
        else {
            topContainerView.hidden = false
            emptyFriendsImageView.hidden = false
            pointerImageView.hidden = false
            friendsTableView.hidden = true
            searchFriendBar.hidden = true
            seperationView.hidden = true
        }
    }
    
    
    func okButtonDidPress() {
        self.delegate?.reloadPoolRequestWithSelectedPlayers(selectedPlayers)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addSearchBar(){
        
        headerView.hidden = false
        headerView.backgroundColor = UIColor.eflWhiteColor()        
        
        searchFriendBar.hidden = false
        seperationView.hidden = false
        //Search Bar set up
        searchFriendBar.frame = CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 40)
        searchFriendBar.placeholder = "Search";
        searchFriendBar.backgroundColor = UIColor.eflWhiteColor()
        searchFriendBar.barTintColor = UIColor.eflRedColor()
        searchFriendBar.searchBarStyle = UISearchBarStyle.Minimal;
        searchFriendBar.delegate = self;
        
        //View seperating Searchbar + TableView
        seperationView.frame = (CGRectMake(0, headerView.frame.size.height - 0.5, self.view!.frame.size.width, 0.5))
        seperationView.backgroundColor = friendsTableView.separatorColor;
        
        headerView.addSubview(searchFriendBar)
        
        //Adding Header
        friendsTableView.tableHeaderView = headerView;
        friendsTableView.tableHeaderView!.addSubview(seperationView)
    }
    
    func handleTap(){
        UIView .animateWithDuration(0.5, animations: {
            self.searchFriendBar.resignFirstResponder()
        })
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
        let userFriend: EFLFriendListModel? = friendListArray[indexPath.row]
        cell.nameTrailingConstraint.constant = 43

        if let user = userFriend {
            cell.setUSerFriendImage(user.playerId, imageURL: user.profile_image_url)
            let firstName = user.first_name
            let lastName = user.last_name
            cell.nameLabel.text = firstName + " " + lastName
            cell.selectButton.selected = user.isSelected

            if user.signedup_on {
                cell.statusLabel.hidden = true
                cell.nameTopContraint.constant = 12
            }
            else {
                cell.statusLabel.hidden = false
                cell.nameTopContraint.constant = 3
            }
        }
        if indexPath.row == friendListArray.count - 1 {
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        else {
            cell.separatorInset.left = 72
        }
        cell.selectButton.addTarget(self, action: #selector(selectButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
        cell.selectButton.tag = indexPath.row
        return cell
    }
    
    //MARK: UI Tableview Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let userFriend: EFLFriendListModel? = friendListArray[indexPath.row]
        if let user = userFriend {
            self.updateSelectedPlayers(user)
        }
    }

    func selectButtonDidPress(sender : AnyObject?) {
        let button = sender as! UIButton
        let userFriend: EFLFriendListModel? = friendListArray[button.tag]

        if let user = userFriend {
            self.updateSelectedPlayers(user)
        }
    }
    
    func updateSelectedPlayers(player: EFLFriendListModel) {
        player.isSelected = !player.isSelected
        friendsTableView.reloadData()

        selectedPlayers.removeAll()
        for model in friendListArray {
            if model.isSelected {
                
                let addPlayerModel : EFLAddPlayerModel = EFLAddPlayerModel()
                addPlayerModel.player_id = Int(model.playerId)!
                
                if model.playerId == EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY) {
                    addPlayerModel.invite_status = "Manager"
                }
                else{
                    addPlayerModel.invite_status = "Pending"
                }
                selectedPlayers.append(addPlayerModel)
            }
        }
        self.activateOkButton()
    }
    
    //MARK: UI SearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.handleTap()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count == 0) {
            friendListArray.removeAll()
            completefriendListArray.removeAll()
            loadUIComponents()
        }
        else {
            let textArraySeperartedBySpace = searchBar.text!.componentsSeparatedByString(" ");
            var firstName = searchBar.text;
            var lastName = searchBar.text;
            var predicate: NSPredicate?
            
            if(textArraySeperartedBySpace.count > 1){
                firstName = textArraySeperartedBySpace[0];
                lastName = textArraySeperartedBySpace[1];
                
                predicate = NSPredicate (format:"(self.first_name CONTAINS[cd] %@ AND self.last_name CONTAINS[cd] %@) OR (self.first_name CONTAINS[cd] %@ AND self.last_name CONTAINS[cd] %@)", firstName!, lastName!, lastName!, firstName!);
                
                if textArraySeperartedBySpace[1] == "" {
                    predicate = NSPredicate (format:"self.first_name CONTAINS[cd] %@ OR self.last_name CONTAINS[cd] %@", String(firstName!.characters.dropLast()), String(lastName!.characters.dropLast()));
                }
            } else {
                predicate = NSPredicate (format:"self.first_name CONTAINS[cd] %@ OR self.last_name CONTAINS[cd] %@", firstName!, lastName!);
            }
            
            let searchDataSource = completefriendListArray.filter{ predicate!.evaluateWithObject($0) }
            
            friendListArray = searchDataSource;
            friendsTableView .reloadData()
            }
    }

    // MARK: EFLSegmentedControlDelegate Methods
    func segmentedControlDidSelectIndex(segmentedControl: EFLSegmentedControl, selectedIndex: Int) {
        if selectedIndex == 1 {
            self.loadUIComponents()
        }
        else {
            self.handleTap()
            self.showGameRequestDialogue()
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
                self.inviteFriends(recipients!)
            }
        }
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        EFLFacebookManager.sharedFacebookManager.setFacebookPermissionsWith { (loginResult, error) in
            if (error != nil) {
                EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
            } else if loginResult.isCancelled {
                //                EFLUtility.showOKAlertWithMessage("USER_CANCEL_LOGIN".localized, andTitle: EmptyString)
            }
            else {
//                EFLActivityIndicator.sharedSpinner.showIndicator()
                self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width,self.view.frame.height), centerPoint: self.view.center)
                self.spinner.showIndicator()
                
                self.updateAccesToken(FBSDKAccessToken.currentAccessToken().tokenString)
            }
        }
    }
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        self.segmentedControl.setSelectedIndex(1)
    }

    // MARK: API Methods
    
    //MARK: Update Access_Token To Server
    func updateAccesToken(accessToken :String) {
        let requestModel = EFLPlayerUpdateRequestModel()
        requestModel.facebook_token = EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY)
        
//        EFLActivityIndicator.sharedSpinner.showIndicator()
        self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height), centerPoint: self.view.center)
        self.spinner.showIndicator()
        
        EFLPlayerAPI().updatePlayer(requestModel) { (error, data) -> Void in
//            EFLActivityIndicator.sharedSpinner.hideIndicator()
            self.spinner.hideIndicator()
            
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

    // MARK: API Methods
    func inviteFriends(recipients:[String]) {
//        EFLActivityIndicator.sharedSpinner.showIndicator()
        self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height), centerPoint: self.view.center)
        
        let requestModel = EFLFriendsUpdateRequestModel()
        requestModel.facebook_ids = recipients
        
        EFLFriendsAPI().updateFriends(requestModel) { (error, data) -> Void in
//            EFLActivityIndicator.sharedSpinner.hideIndicator()
            self.spinner.hideIndicator()
            
            
            if !error.isKindOfClass(APIErrorTypeNone){
                print(error.code)
                EFLUtility.showOKAlertWithMessage("ALERT_FAILURE_MESSAGE".localized.localized, andTitle: "ALERT_FAILURE_TITLE".localized)
                return
            }
            else
            {
                let response = (data as! EFLFriendsResponse)
                if response.status == ResponseStatusSuccess {
                    EFLPlayerDataManager.sharedDataManager.syncFriends(response.data!)
                    self.segmentedControl.setSelectedIndex(1)
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
    
    // MARK: Navigation Bar Seperation Hide
   /*
    func removeNavigationBarSperarationView(){
        
        let navController: EFLBaseNavigationController = self.navigationController as! EFLBaseNavigationController
        
        self.tabBarController?.tabBar.hidden = true
        
        navController.navigationBar.clipsToBounds = true
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.eflGreenColor()
        }
        
        if shadowImageView == nil {
            shadowImageView = findShadowImageUnderView(navController.navigationBar)
        }
        shadowImageView?.hidden = true
    }
    
    private func findShadowImageUnderView(view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height == 0.5 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            if let imageView = findShadowImageUnderView(subview) {
                return imageView
            }
        }
        return nil
    }
 */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
