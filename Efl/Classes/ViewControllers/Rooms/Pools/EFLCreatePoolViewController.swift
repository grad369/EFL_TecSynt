//
//  EFLCreatePoolViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 24/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCreatePoolViewController: EFLBaseViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AddPlayerDelegate, EFLSelectCompetitionDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var poolTableView: UITableView!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    
    var messageCellHeight:CGFloat = 66
    var placeHolderSelectedOnce:Bool = false
    var placeHolderOnceSet:Bool = false
    var placeHolderText: String = EmptyString
    
    var activeTextField: UITextField?
    var activeTextView: UITextView?
    var poolImage: UIImage?
    
    var createPoolRequest = EFLCreatePoolRequestModel()
    
    lazy var spinner: EFLActivityIndicator = {
        return EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height))
    }()
    
    deinit{
        placeHolderSelectedOnce = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
}


// MARK: - EFLBaseViewController's functions
extension EFLCreatePoolViewController {
    
    override func configurationNavigationAndStatusBars() {
        self.setConfigurationStatusBar(.Green)
        self.setConfigurationNavigationBar("NEW_POOL_TITLE".localized, titleView: nil, backgroundColor: .Green)
        self.setBarButtonItem(.Send, placeType: .Right, tintColorType: .White)
        self.setBarButtonItem(.Cancel, placeType: .Left, tintColorType: .White)
    }
    
    override func configurationView() {
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        createPoolRequest.message = "POOL_DEFAULT_MESSAGE".localized
        
        poolTableView.registerNib(UINib(nibName: "EFLPoolDetailsCell", bundle: nil), forCellReuseIdentifier: poolDetailsCellIdentifier)
        poolTableView.registerNib(UINib(nibName: "EFLPoolMessageCell", bundle: nil), forCellReuseIdentifier: poolMessageCellIdentifier)
        poolTableView.registerNib(UINib(nibName: "EFLLogoutCell", bundle: nil), forCellReuseIdentifier: logoutCellIdentifier)
        poolTableView.registerNib(UINib(nibName: "EFLPoolPlayerCell", bundle: nil), forCellReuseIdentifier: poolPlayerCellIdentifier)
        
        self.activateSendButton()
    }
}


// MARK: - Actions
extension EFLCreatePoolViewController {
    
    func rightBarButtonItemDidPress() {
        self.resignTexts()
        if isValidPool() {
            self.createPoolRoom()
        }
    }
    
    func leftBarButtonItemDidPress() {
        self.dismissViewController(.Default) {}
    }
    
    func handleTap(){
        UIView .animateWithDuration(0.5, animations: {
            self.view.endEditing(true)
        })
    }
    
    func imageButtonDidPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func deleteButtonDidPress(sender: AnyObject) {
        let button = sender as! UIButton
        createPoolRequest.players.removeAtIndex(button.tag)
        self.reloadPoolData()
    }
}


// MARK: - API Methods
extension EFLCreatePoolViewController {
    
    func createPoolRoom() {
        if ReachabilityManager.isReachable() {
            
            let addManagerModel : EFLAddPlayerModel = EFLAddPlayerModel()
            addManagerModel.player_id = Int(EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY)!)!
            addManagerModel.invite_status = "Manager"
            
            createPoolRequest.players.append(addManagerModel)
            
            self.spinner.showIndicator()
            
            EFLCreatePoolAPI().createPoolWith(createPoolRequest){ (error, data) -> Void in
                self.spinner.hideIndicator()
                
                if !error.isKindOfClass(APIErrorTypeNone){
                    if error.code == HTTP_STATUS_REQUEST_TIME_OUT || error.code == HTTP_STATUS_CONFLICT {
                        self.showFailureAlert()
                    }
                    else {
                        EFLManager.sharedManager.handleHTTPErrorCasesInView(self.view, bannerOffset: 0.0)
                    }
                    return
                }
                else {
                    let response = (data as! EFLCreatePoolResponse)
                    if response.status == ResponseStatusSuccess {
                        
                        EFLPoolRoomDataManager.sharedDataManager.syncCreatedPoolRoomToCache(response.data.poolroom!) { (status, error) in
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                EFLManager.sharedManager.isRoomsRefreshed = true
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKindOfClass(EFLRoomsViewController) {
                                        self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                                        break
                                    }
                                }
                            })
                        }
                    }
                    else {
                        //print(response.message)
                    }
                }
            }
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 44)
        }
    }
}


// MARK: - UITableView DataSource Methods
extension EFLCreatePoolViewController {
    
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
            return createPoolRequest.players.count + 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
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
            if indexPath.row == 0 && activeTextField == nil {
                activeTextField = cell.poolTextField
            }
            if indexPath.row == 2 {
                if poolImage != nil {
                    cell.poolImageView.image = poolImage
                }
            }
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.setCreatePoolDataInRow(indexPath.row, requestModel: createPoolRequest)
            cell.poolTextField.delegate = self
            cell.poolImageButton.addTarget(self, action: #selector(imageButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell:EFLPoolMessageCell = tableView.dequeueReusableCellWithIdentifier(poolMessageCellIdentifier) as! EFLPoolMessageCell
            if activeTextView == nil {
                activeTextView = cell.messageTextView
            }
            cell.messageTextView.textContainer.lineFragmentPadding = 0;
            cell.messageTextView.textContainerInset = UIEdgeInsetsZero;
            cell.messageTextView.delegate = self
            if let poolMessage = createPoolRequest.message {
                cell.messageTextView.text = poolMessage
            }
            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell:EFLLogoutCell = tableView.dequeueReusableCellWithIdentifier(logoutCellIdentifier) as! EFLLogoutCell
                cell.separatorInset = UIEdgeInsetsZero
                cell.layoutMargins = UIEdgeInsetsZero
                cell.labelText.text = "ADD_PLAYER_BUTTON_TITLE".localized
                return cell
            }
            else {
                let cell:EFLPoolPlayerCell = tableView.dequeueReusableCellWithIdentifier(poolPlayerCellIdentifier) as! EFLPoolPlayerCell
                cell.separatorInset = UIEdgeInsetsZero
                cell.layoutMargins = UIEdgeInsetsZero
                cell.selectionStyle = .None
                if indexPath.row == 1 {
                    cell.deleteButton.hidden = true
                    cell.managerLabel.hidden = false
                    cell.setManagerData()
                }
                else {
                    cell.deleteButton.hidden = false
                    cell.managerLabel.hidden = true
                    let addPlayer = createPoolRequest.players[indexPath.row - 2] as EFLAddPlayerModel
                    cell.setCreatePoolPlayerData(String(addPlayer.player_id))
                    cell.deleteButton.tag = indexPath.row - 2
                    cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
                    
                }
                return cell
            }
        }
    }
}


// MARK: - UI Tableview Delegate Methods
extension EFLCreatePoolViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 50
        }
        else if indexPath.section == 1 {
            if messageCellHeight < 60 {
                return 60
            }else{
                return messageCellHeight
            }
        }
        else {
            if indexPath.row == 0 {
                return 30
            }
            else {
                return 50
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0 && indexPath.row == 1 {
            self.imageButtonDidPress()
        }
        else if indexPath.section == 0 && indexPath.row == 2 {
            return
            let selectCompetitionVC = self.storyboard?.instantiateViewControllerWithIdentifier(SELECT_COMPETITION_VIEW_CONTROLLER_ID) as? EFLSelectCompetitionViewController
            selectCompetitionVC?.delegate = self
            let navigationController = EFLBaseNavigationController(rootViewController: selectCompetitionVC!)
            self.presentViewController(navigationController, animated: true, completion: nil)
            
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            return
            let addPlayerVC = self.storyboard?.instantiateViewControllerWithIdentifier(ADD_PLAYER_VIEW_CONTROLLER_ID) as? EFLAddPlayerViewController
            addPlayerVC?.delegate = self
            addPlayerVC?.selectedPlayers = createPoolRequest.players
            self.navigationController?.pushViewController(addPlayerVC!, animated: true)
        }
    }
}


// MARK: - EFLSelectCompetitionDelegate
extension EFLCreatePoolViewController {
    
    func didSelectCompetition(competitionId: Int) {
        createPoolRequest.competition_id = competitionId
        self.reloadPoolData()
    }
}
    

// MARK: - UIImagePickerControllerDelegate Methods
extension EFLCreatePoolViewController {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let image = EFLUtility.scaleDownImage(pickedImage, ToSize: imageScaleSize)
            
            let indexPath = NSIndexPath(forRow: 1, inSection: 0)
            let cell = poolTableView.cellForRowAtIndexPath(indexPath) as! EFLPoolDetailsCell
            cell.poolImageView.image = image
            poolImage = image
            
            createPoolRequest.pool_image = UIImageJPEGRepresentation(image, 0.6)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            poolTableView.reloadData()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

    
// MARK: - AddPlayerDelegate Method
extension EFLCreatePoolViewController {
    
    func reloadPoolRequestWithSelectedPlayers(players: [EFLAddPlayerModel]) {
        createPoolRequest.players = players
        self.reloadPoolData()
    }
}


// MARK: - UITextFieldDelegate Methods
extension EFLCreatePoolViewController {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let characterSet = NSCharacterSet(charactersInString: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.").invertedSet
        let filteredString = string.componentsSeparatedByCharactersInSet(characterSet).joinWithSeparator(EmptyString)
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        let nsString = textField.text! as NSString
        let newString = nsString.stringByReplacingCharactersInRange(range, withString: string)

        let trimmedName = newString.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )        
        createPoolRequest.pool_name = trimmedName
        self.activateSendButton()
        return (newLength <= 100) && (string == filteredString)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
}


// MARK: - UITextViewDelegate
extension EFLCreatePoolViewController {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let heightOfText = textView.text.size(textView.font!, width: textView.width).height
        
        if messageCellHeight != heightOfText + 35 {
            poolTableView.beginUpdates()
            messageCellHeight = heightOfText + 35
            poolTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            poolTableView.endUpdates()
        }
        
//        poolTableView.beginUpdates()
//        if messageCellHeight != textView.contentSize.height + 60 {
//            messageCellHeight = textView.contentSize.height + 60
//            poolTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
//        }
//        poolTableView.endUpdates()
        
        let text = textView.text
        let newLength = text.characters.count - range.length
        return (newLength <= 500)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.tag == 1 && !placeHolderSelectedOnce {
            placeHolderText = textView.text
            placeHolderSelectedOnce = true
            dispatch_async(dispatch_get_main_queue(), {
                textView.selectAll(nil)
            })
        }
        
        topTableViewConstraint.constant = -150
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        let trimmedMessage = textView.text.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )

        if !(trimmedMessage.isEmpty) {
            createPoolRequest.message = trimmedMessage
        }
        else {
            createPoolRequest.message = "POOL_DEFAULT_MESSAGE".localized
            self.reloadPoolData()
        }
        
        if textView.tag == 1 && placeHolderText != textView.text{
            placeHolderSelectedOnce = true
            placeHolderOnceSet = true
        }else if !placeHolderOnceSet{
            placeHolderSelectedOnce = false
        }
        
        topTableViewConstraint.constant = 0
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}


// MARK: - GestureRecognizer Delegate
extension EFLCreatePoolViewController {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        self.view .resignFirstResponder()
        if touch.view != poolTableView {
            return false
        }
        return true
    }
    
}


// MARK: - Profile Update Failure Alert
private extension EFLCreatePoolViewController {
    
    func showFailureAlert() {
        let alert: UIAlertController = UIAlertController(title: "ALERT_FAILURE_TITLE".localized, message: "ALERT_FAILURE_MESSAGE".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.eflGreenColor()
        
        let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
        })
        
        let tryAgain: UIAlertAction = UIAlertAction(title: "TRY_AGAIN_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
            self.createPoolRoom()
        })
        
        alert.addAction(cancel)
        alert.addAction(tryAgain)
        
        self.presentViewController(alert, animated: true, completion: {
            alert.view.tintColor = UIColor.eflGreenColor()
        })
    }
}


// MARK: - Private Functions
private extension EFLCreatePoolViewController {
    
    func activateSendButton() {
        let barButtonItem = self.navigationItem.rightBarButtonItems![0]
        let sendButton = barButtonItem.customView as! UIButton
        
        if self.isValidPool() {
            sendButton.setTitleColor(UIColor.eflWhiteColor(), forState: UIControlState.Normal)
            sendButton.userInteractionEnabled = true
        }
        else {
            sendButton.setTitleColor(UIColor.efllighterGreyColor(), forState: UIControlState.Normal)
            sendButton.userInteractionEnabled = false
        }
    }
    
    func resignTexts() {
        poolTableView.contentOffset = CGPointMake(0, 0)
        activeTextField?.resignFirstResponder()
        activeTextView?.resignFirstResponder()
    }
    
    func isValidPool() -> Bool {
        
        if EFLUtility.isEmptyString(createPoolRequest.pool_name) {
            return false
        }
        if EFLUtility.isEmptyString(createPoolRequest.message){
            return false
        }
        if createPoolRequest.players.count == 0 {
            return false
        }
        
        return true
    }
    
    func reloadPoolData() {
        self.activateSendButton()
        poolTableView.reloadData()
    }
    
    func getTableHeader(section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let view = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 24))
        view.backgroundColor = UIColor.clearColor()
        
        let label = UILabel.init(frame: CGRectMake(16, 0, 70, 24))
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
            labelPlayers.text = String(createPoolRequest.players.count + 1) + "/100 players added"
            
            view.addSubview(labelPlayers)
            
        }
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(EFLCreatePoolViewController.handleTap))
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
        
        view.addSubview(label)
        return view
    }
}

