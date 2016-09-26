//
//  EFLProfileViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 28/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AssetsLibrary

protocol ProfileUpdateDelegate{
    func reloadSettingsData(reverted: Bool)
}

class EFLProfileViewController: EFLBaseViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var profileTableView: UITableView!
    var delegate:ProfileUpdateDelegate?
    var updateRequired = false // To check whether update required in back button action
    var refreshRequired = false // To check whether refresh required in settings page

    var activeTextField:UITextField?
    
    var spinner:EFLActivityIndicator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationBackButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: REFRESH_DATA_NOTIFICATION, object: nil)
        if EFLManager.sharedManager.isPlayerRefreshed {
            profileTableView.reloadData()
            EFLManager.sharedManager.isPlayerRefreshed = false
            refreshRequired = true
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: REFRESH_DATA_NOTIFICATION, object: nil)
    }

    override func initialiseView() {
        self.navigationItem.title = "PROFILE_TITLE".localized
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = true
        profileTableView.registerNib(UINib(nibName: "EFLProfileDetailCell", bundle: nil), forCellReuseIdentifier: profileDetailCellIdentifier)
        profileTableView.registerNib(UINib(nibName: "EFLFacebookInfoCell", bundle: nil), forCellReuseIdentifier: profileFacebookInfoCellIdentifier)
        
        profileTableView.registerNib(UINib(nibName: "EFLLogoutCell", bundle: nil), forCellReuseIdentifier: logoutCellIdentifier)
    }
    
    override func backButtonAction() {
        self.resignTextFields()
        if self.checkForProfileEdit() {
            if self.validateFields() {
                if ReachabilityManager.isReachable() {
                    self.updateProfileData(nil)
                }
                else {
                    self.showOfflineAlert()
                }
            }
        }
        else {
            self.delegate?.reloadSettingsData(refreshRequired)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK :Helper Methods
    
    //MARK: Refresh user details
    func reloadData() {
        EFLManager.sharedManager.isPlayerRefreshed = false
        refreshRequired = true
        profileTableView.reloadData()
    }

    //MARK: Resign all textfields
    func resignTextFields() {
        activeTextField?.resignFirstResponder()
    }
    
    // MARK: UITableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else {
            return 1
        }
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell:EFLProfileDetailCell = tableView.dequeueReusableCellWithIdentifier(profileDetailCellIdentifier) as! EFLProfileDetailCell
                cell.firstNameTextField.delegate = self
                cell.lastNameTextField.delegate = self
                cell.setData()
                cell.separatorInset = UIEdgeInsetsZero
                cell.layoutMargins = UIEdgeInsetsZero
                cell.editButton.addTarget(self, action: #selector(EFLProfileViewController.editButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            }
            else {
                let cell:EFLFacebookInfoCell = tableView.dequeueReusableCellWithIdentifier(profileFacebookInfoCellIdentifier) as! EFLFacebookInfoCell
                return cell
            }
        }
        else {
            let cell:EFLLogoutCell = tableView.dequeueReusableCellWithIdentifier(logoutCellIdentifier) as! EFLLogoutCell
            cell.labelText.text = "LOG_OUT_BUTTON_TITLE".localized
            return cell
        }
    }
    
    //MARK: UI Tableview Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return 100
        }
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        else {
            return 29.5
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0 && indexPath.row == 1 {
            if ReachabilityManager.isReachable() {
                self.checkAccessToken()
            }
            else {
                EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
            }
        }
        else if indexPath.section == 1
        {
            self.showConrimationAlert()
        }
    }
    
    //MARK: Edit Profile
    func editButtonDidPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = profileTableView.cellForRowAtIndexPath(indexPath) as! EFLProfileDetailCell

        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            updateRequired = true
            cell.profileImageView.image = EFLUtility.scaleDownImage(pickedImage, ToSize: imageScaleSize)
            //EFLUtility.saveUserImage(cell.profileImageView.image!)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Check Access Token
    func checkAccessToken() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            EFLActivityIndicator.sharedSpinner.showIndicator()
            self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(45, 45), centerPoint: self.view.center)
            self.spinner?.showIndicator()
            
            
            FBSDKAccessToken.refreshCurrentAccessToken({ (connection :FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) in
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    self.getFacebookData()
                }
                else {
//                    EFLActivityIndicator.sharedSpinner.hideIndicator()
                    self.spinner?.hideIndicator()
                    
                    EFLFacebookManager.sharedFacebookManager.setFacebookPermissionsWith { (loginResult, error) in
                        if (error != nil) {
                            EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                        } else if loginResult.isCancelled {
                            print("User cancelled authentication")
                        }
                        else {
                            if (FBSDKAccessToken.currentAccessToken() != nil) {
//                                EFLActivityIndicator.sharedSpinner.showIndicator()
                                self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(45, 45), centerPoint: self.view.center)
                                self.spinner?.showIndicator()
                                
                                self.updateProfileData(FBSDKAccessToken.currentAccessToken().tokenString)
                            }
                            else {
                                EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                            }
                        }
                    }
                }
            })
        }
        else {
            EFLFacebookManager.sharedFacebookManager.setFacebookPermissionsWith { (loginResult, error) in
                if (error != nil) {
                    EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                } else if loginResult.isCancelled {
                }
                else {
                    if (FBSDKAccessToken.currentAccessToken() != nil) {
//                        EFLActivityIndicator.sharedSpinner.showIndicator()
                        self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height), centerPoint: self.view.center)
                        self.spinner?.showIndicator()
                        
                        self.updateProfileData(FBSDKAccessToken.currentAccessToken().tokenString)
                    }
                    else {
                        EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                    }
                }
            }
        }
    }
    
    
    // MARK: Get Facebook data
    func getFacebookData() {
        EFLFacebookManager.sharedFacebookManager.getFacebookDataWith({ (connection, result, error) in
            if error == nil {
                self.updateRequired = true
                self.saveAndReloadData(result)
            } else {
//                EFLActivityIndicator.sharedSpinner.hideIndicator()
                self.spinner?.hideIndicator()
                
                EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
            }
        })
    }
    
    //MARK: Reload data
    func saveAndReloadData(result : AnyObject!) {
        let picture = result.valueForKey("picture")
        let data = picture!.valueForKey("data")
        let is_silhouette = data?.valueForKey("is_silhouette") as! Bool

//        EFLActivityIndicator.sharedSpinner.hideIndicator()
        self.spinner?.hideIndicator()
        
        EFLUtility.saveValuesToUserDefaults((result.valueForKey("first_name") as? String)!, key: FIRST_NAME_KEY)
        EFLUtility.saveValuesToUserDefaults((result.valueForKey("last_name") as? String)!, key: LAST_NAME_KEY)
        if is_silhouette { // If Facebook avatar, no image required
            EFLUtility.removeValueFromUserDefaults(PROFILE_IMAGE_URL_KEY)
        }
        else {
            EFLUtility.saveValuesToUserDefaults(self.getProfPic(((result.valueForKey("id")) as? String)!)!, key: PROFILE_IMAGE_URL_KEY)
        }
        EFLUtility.removeUserImage()
        self.profileTableView.reloadData()
    }
    
    //MARK: Get Facebook Profile Picture URL
    func getProfPic(fid: String) -> String? {
        if (fid != "") {
            let imgURLString = "http://graph.facebook.com/" + fid + "/picture?height=240" //type=normal
            return imgURLString
        }
        return nil
    }

    
    // MARK: Logout Action
    func logoutFromApp() {
        
        if ReachabilityManager.isReachable() {
            let logoutAlert = UIAlertController (title: "LOG_OUT_ALERT_TITLE".localized, message: "LOG_OUT_ALERT_MESSAGE_TEXT".localized, preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:nil)
            
            let logOut : UIAlertAction = UIAlertAction (title: "LOG_OUT_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
                (alert: UIAlertAction!) in
                self.logout()
            })
            
            logoutAlert.addAction(cancel)
            logoutAlert.addAction(logOut)
            
            self.presentViewController(logoutAlert, animated: true, completion: {
                logoutAlert.view.tintColor = UIColor.eflGreenColor()
            })
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
        }
    }
    
    
    func logout() {
        
//        EFLLogoutAPI().logout { (error, data) -> Void in
//            if !error.isKindOfClass(APIErrorTypeNone){
//                print(error.code)
//                
//                
//            }
            //else
            //{
                //let response = (data as! EFLLogoutResponse)
                //if response.status == ResponseStatusSuccess {
                    EFLManager.sharedManager.logOut()
//                  EFLActivityIndicator.sharedSpinner.showIndicator()
            self.spinner = EFLActivityIndicator(supView: self.view, size: CGSizeMake(45, 45), centerPoint: self.view.center)
            self.spinner!.showIndicator()
        
                    NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(EFLProfileViewController.popToLoginScreen), userInfo: nil, repeats: false)
                //}
//                else {
//                    EFLUtility.showOKAlertWithMessage("ALERT_FAILURE_MESSAGE".localized.localized, andTitle: "ALERT_FAILURE_TITLE".localized)
//                }
            //}
        //}
    }
    
    func popToLoginScreen() {
        // Something after a delay
//        EFLActivityIndicator.sharedSpinner.hideIndicator()
//        let spinner = EFLActivityIndicator(supView: self.view, size: CGSizeMake(45, 45), centerPoint: self.view.center)
         self.spinner!.hideIndicator()

        self.tabBarController?.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let characterSet = NSCharacterSet(charactersInString: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.").invertedSet
        let filteredString = string.componentsSeparatedByCharactersInSet(characterSet).joinWithSeparator(EmptyString)
        
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return (newLength <= 100) && (string == filteredString)
    }

    //MARK: Validation Methods
    func validateFields() -> Bool {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = profileTableView.cellForRowAtIndexPath(indexPath) as! EFLProfileDetailCell
        let trimmedFirstName = cell.firstNameTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let trimmedLastName = cell.lastNameTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )

        if (trimmedFirstName.isEmpty) || (trimmedLastName.isEmpty) {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "PROFILE_FIELD_VALIDATION_BANNER_MESSAGE".localized, yOffset: 0)
            return false
        }
        return true
    }
    
    //MARK: API Methods
    
    func checkForProfileEdit() -> Bool {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = profileTableView.cellForRowAtIndexPath(indexPath) as! EFLProfileDetailCell
        
        let trimmedFirstName = cell.firstNameTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let trimmedLastName = cell.lastNameTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )

        if trimmedFirstName != EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY) ||
        trimmedLastName != EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY) ||
        updateRequired {
            return true
        }
        return false
    }
    
    //MARK: SetUp Request
    func profileUpdateRequest(facebookAccessToken:String?) -> EFLPlayerUpdateRequestModel {
        
        let requestModel = EFLPlayerUpdateRequestModel()

        if facebookAccessToken == nil { //Facebook access token not changed
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = profileTableView.cellForRowAtIndexPath(indexPath) as! EFLProfileDetailCell
            
            let trimmedFirstName = cell.firstNameTextField.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            if trimmedFirstName != EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY) {
                requestModel.first_name = trimmedFirstName
            }
            
            let trimmedLastName = cell.lastNameTextField.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            if trimmedLastName != EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY) {
                requestModel.last_name = trimmedLastName
            }
//            if (updateRequired && (NSUserDefaults.standardUserDefaults().objectForKey(PROFILE_IMAGE_URL_KEY) == nil) ){
//                requestModel.image = NSData()
//            }
            if updateRequired{
                requestModel.image = UIImageJPEGRepresentation(cell.profileImageView.image!, 0.6)
            }
            
            
            requestModel.notification_received_invite = EFLUtility.readBooleanFromUserDefaults(NOTIFICATION_RECEIVED_INVITE_KEY)
            requestModel.notification_received_response = EFLUtility.readBooleanFromUserDefaults(NOTIFICATION_RECEIVED_RESPONSE_KEY)
            requestModel.notification_picks_reminder = EFLUtility.readBooleanFromUserDefaults(NOTIFICATION_PICKS_REMINDER_KEY)
            requestModel.notification_received_result = EFLUtility.readBooleanFromUserDefaults(NOTIFICATION_RECEIVED_RESULT_KEY)
        }
        else { // Facebook access token expired and regenerated
            requestModel.facebook_token = facebookAccessToken
        }
        
        return requestModel
    }
    
    //MARK: Profile Update API
    func updateProfileData(accessToken:String?) {
        
        let requestModel = self.profileUpdateRequest(accessToken)
//        EFLActivityIndicator.sharedSpinner.showIndicator()
        self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height), centerPoint: self.view.center)
        self.spinner?.showIndicator()
        
        EFLPlayerAPI().updatePlayer(requestModel) { (error, data) -> Void in
//            EFLActivityIndicator.sharedSpinner.hideIndicator()
            self.spinner?.hideIndicator()
            
            if !error.isKindOfClass(APIErrorTypeNone){
                if accessToken == nil {
                    self.showProfileUpdateFailureAlert()
                }
                return
            }
            else {
                let response = (data as! EFLPlayerResponse)
                if response.status == ResponseStatusSuccess {
                    if accessToken == nil {
                        self.updateRequired = false
                        self.refreshRequired = true
                        EFLManager.sharedManager.refreshPlayerData(response.data!)
                        self.backButtonAction()
                    }
                    else {
                        if let authorizationToken = response.data!.jwt_token {
                            EFLUtility.saveValuesToUserDefaults(authorizationToken, key: AUTHORIZATION_TOKEN_KEY)
                        }
                        EFLUtility.saveValuesToUserDefaults(accessToken!, key: FB_ACCESS_TOKEN_KEY)
                        self.getFacebookData() // Update facebook access token and get facebook data
                    }
                }
                else {
                    print(response.message)
                }
            }
        }
    }
    
    // MARK: PopUp Methods

    // MARK: Logout Confirmation Alert
    func showConrimationAlert() {
    
        if ReachabilityManager.isReachable() {
            let alert: UIAlertController = UIAlertController(title: "LOG_OUT_ALERT_TITLE".localized, message: "LOG_OUT_ALERT_MESSAGE_TEXT".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.view.tintColor = UIColor.eflGreenColor()
            let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler: nil)
            let logout: UIAlertAction = UIAlertAction(title: "LOG_OUT_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in self.logout()})
            
            alert.addAction(cancel)
            alert.addAction(logout)
            
            self.presentViewController(alert, animated: true, completion: {
                alert.view.tintColor = UIColor.eflGreenColor()
            })
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
        }
    }

    // MARK: Profile Update Failure Alert
    func showProfileUpdateFailureAlert() {
        let alert: UIAlertController = UIAlertController(title: "ALERT_FAILURE_TITLE".localized, message: "ALERT_FAILURE_MESSAGE".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.eflGreenColor()
                
        let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
            self.updateRequired = false
            self.refreshRequired = false
            self.profileTableView.reloadData()
            self.backButtonAction()
        })
        
        let logout: UIAlertAction = UIAlertAction(title: "TRY_AGAIN_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
            self.updateProfileData(nil)
        })
        
        alert.addAction(cancel)
        alert.addAction(logout)
        
        self.presentViewController(alert, animated: true, completion: {
            alert.view.tintColor = UIColor.eflGreenColor()
        })
    }

    // MARK: Profile Update Failure Alert
    func showOfflineAlert() {
        let alert: UIAlertController = UIAlertController(title: "NO_CONNECTION_ALERT_TITLE".localized, message: "NO_CONNECTION_ALERT_MESSAGE".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.eflGreenColor()
        
        let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
        })
        
        let dontSave: UIAlertAction = UIAlertAction(title: "ALERT_DONT_SAVE_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in

            self.profileTableView.reloadData()
            self.updateRequired = false
            self.refreshRequired = false
            self.backButtonAction()
        })
        
        alert.addAction(cancel)
        alert.addAction(dontSave)
        
        self.presentViewController(alert, animated: true, completion: {
            alert.view.tintColor = UIColor.eflGreenColor()
        })
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
