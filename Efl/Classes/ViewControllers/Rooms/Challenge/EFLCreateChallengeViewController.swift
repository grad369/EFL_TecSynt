//
//  EFLCreateChallengeViewController.swift
//  Efl
//
//  Created by vaskov on 30.10.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit


class EFLCreateChallengeViewController: EFLBaseViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AddPlayerDelegate, EFLSelectCompetitionDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var challengeTableView: UITableView!
    
    var messageCellHeight: CGFloat = 60
    var placeHolderSelectedOnce: Bool = false
    var placeHolderOnceSet: Bool = false
    var placeHolderText: String = EmptyString
    
    var activeTextView: UITextView?
    var poolImage: UIImage?
    
    var createChallengeRequest = EFLCreateChallengeRequestModel()
    
    
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
extension EFLCreateChallengeViewController {
    
    override func configurationNavigationAndStatusBars() {
        self.setConfigurationStatusBar(.Black)
        self.setConfigurationNavigationBar("NEW_CHALLENGE_TITLE".localized, titleView: nil, backgroundColor: .White, topRoundCorner: 8)
        self.setBarButtonItem(.Send, placeType: .Right, tintColorType: .Green)
        self.setBarButtonItem(.Cancel, placeType: .Left, tintColorType: .Green)
        self.eflNavigationController!.setShadow()
    }
    
    override func configurationView() {
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        createChallengeRequest.message = "POOL_DEFAULT_MESSAGE".localized
        
        challengeTableView.registerNib(UINib(nibName: "EFLPoolDetailsCell", bundle: nil), forCellReuseIdentifier: poolDetailsCellIdentifier)
        challengeTableView.registerNib(UINib(nibName: "EFLPoolMessageCell", bundle: nil), forCellReuseIdentifier: poolMessageCellIdentifier)
        challengeTableView.registerNib(UINib(nibName: "EFLLogoutCell", bundle: nil), forCellReuseIdentifier: logoutCellIdentifier)
        challengeTableView.registerNib(UINib(nibName: "EFLPoolPlayerCell", bundle: nil), forCellReuseIdentifier: poolPlayerCellIdentifier)
        challengeTableView.registerNib(UINib(nibName: "EFLChallengeMatchCell", bundle: nil), forCellReuseIdentifier: "EFLChallengeMatchCellID")
        
        self.activateSendButton()
        //self.addRecognizer()
    }
}


// MARK: - Actions
extension EFLCreateChallengeViewController {
    
    func rightBarButtonItemDidPress() {
        self.resignTexts()
        if isValidChallenge() {
        }
    }
    
    func leftBarButtonItemDidPress() {
        self.setConfigurationStatusBar(.Green)
        self.dismissViewController(.Default) {}
    }
    
    func handleTap(){
        UIView.animateWithDuration(0.5, animations: {
            self.view.endEditing(true)
        })
    }
}


// MARK: - API Methods
extension EFLCreateChallengeViewController {
    
}


// MARK: - UITableView DataSource Methods
extension EFLCreateChallengeViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return createChallengeRequest.players.count + 2
        }
        else {
            return createChallengeRequest.matches.count + 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }
        return 24
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
            let cell:EFLPoolMessageCell = tableView.dequeueReusableCellWithIdentifier(poolMessageCellIdentifier) as! EFLPoolMessageCell
            if activeTextView == nil {
                activeTextView = cell.messageTextView
            }
            cell.messageTextView.textContainer.lineFragmentPadding = 0;
            cell.messageTextView.textContainerInset = UIEdgeInsetsZero;
            cell.messageTextView.delegate = self
            if let poolMessage = createChallengeRequest.message {
                cell.messageTextView.text = poolMessage
            }
            return cell
        } else {
            if indexPath.row == 0 {
                let cell: EFLLogoutCell = tableView.dequeueReusableCellWithIdentifier(logoutCellIdentifier) as! EFLLogoutCell
                cell.separatorInset = UIEdgeInsetsZero
                cell.layoutMargins = UIEdgeInsetsZero
                cell.labelText.text = "ADD_PLAYER_BUTTON_TITLE".localized
                return cell
            }
            else {
                if indexPath.section == 1 {
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
                        let addPlayer = createChallengeRequest.players[indexPath.row - 2] as EFLAddPlayerModel
                        cell.setCreatePoolPlayerData(String(addPlayer.player_id))
                        cell.deleteButton.tag = indexPath.row - 2
                        //cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
                        
                    }
                    return cell
                } else {
                    let cell:EFLChallengeMatchCell = tableView.dequeueReusableCellWithIdentifier("EFLChallengeMatchCellID") as! EFLChallengeMatchCell
                    cell.separatorInset = UIEdgeInsetsZero
                    cell.layoutMargins = UIEdgeInsetsZero
                    cell.selectionStyle = .None
                    
                    return cell
                }
                
            }
        }
    }
}


// MARK: - UI Tableview Delegate Methods
extension EFLCreateChallengeViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if messageCellHeight <= 60 {
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
        
        if indexPath.section == 2 && indexPath.row == 0 {
            return
            let addPlayerVC = self.storyboard?.instantiateViewControllerWithIdentifier(ADD_PLAYER_VIEW_CONTROLLER_ID) as? EFLAddPlayerViewController
            addPlayerVC?.delegate = self
            addPlayerVC?.selectedPlayers = createChallengeRequest.players
            self.navigationController?.pushViewController(addPlayerVC!, animated: true)
        }
    }
}


// MARK: - EFLSelectCompetitionDelegate
extension EFLCreateChallengeViewController {
    
    func didSelectCompetition(competitionId: Int) {
        createChallengeRequest.competition_id = competitionId
        self.reloadPoolData()
    }
}


// MARK: - AddPlayerDelegate Method
extension EFLCreateChallengeViewController {
    
    func reloadPoolRequestWithSelectedPlayers(players: [EFLAddPlayerModel]) {
        createChallengeRequest.players = players
        self.reloadPoolData()
    }
}


// MARK: - UITextFieldDelegate Methods
extension EFLCreateChallengeViewController {
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        let characterSet = NSCharacterSet(charactersInString: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.").invertedSet
//        let filteredString = string.componentsSeparatedByCharactersInSet(characterSet).joinWithSeparator(EmptyString)
//        guard let text = textField.text else { return true }
//        let newLength = text.characters.count + string.characters.count - range.length
//        
//        let nsString = textField.text! as NSString
//        let newString = nsString.stringByReplacingCharactersInRange(range, withString: string)
//        
//        let trimmedName = newString.stringByTrimmingCharactersInSet(
//            NSCharacterSet.whitespaceAndNewlineCharacterSet()
//        )
//        self.activateSendButton()
//        return (newLength <= 100) && (string == filteredString)
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//    }
}


// MARK: - UITextViewDelegate
extension EFLCreateChallengeViewController {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let heightOfText = textView.text.size(textView.font!, width: textView.width).height
        
        if messageCellHeight != heightOfText + 35 {
            challengeTableView.beginUpdates()
            messageCellHeight = heightOfText + 35
            challengeTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            challengeTableView.endUpdates()
        }
        
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
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        let trimmedMessage = textView.text.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if !(trimmedMessage.isEmpty) {
            createChallengeRequest.message = trimmedMessage
        }
        else {
            createChallengeRequest.message = "POOL_DEFAULT_MESSAGE".localized
            self.reloadPoolData()
        }
        
        if textView.tag == 1 && placeHolderText != textView.text{
            placeHolderSelectedOnce = true
            placeHolderOnceSet = true
        }else if !placeHolderOnceSet{
            placeHolderSelectedOnce = false
        }
    }
}


// MARK: - GestureRecognizer Delegate
extension EFLCreateChallengeViewController {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        self.view .resignFirstResponder()
        if touch.view != challengeTableView {
            return false
        }
        return true
    }
}


// MARK: - Profile Update Failure Alert
private extension EFLCreateChallengeViewController {
    
    func showFailureAlert() {
        let alert: UIAlertController = UIAlertController(title: "ALERT_FAILURE_TITLE".localized, message: "ALERT_FAILURE_MESSAGE".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.eflGreenColor()
        
        let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
        })
        
        let tryAgain: UIAlertAction = UIAlertAction(title: "TRY_AGAIN_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
        })
        
        alert.addAction(cancel)
        alert.addAction(tryAgain)
        
        self.presentViewController(alert, animated: true, completion: {
            alert.view.tintColor = UIColor.eflGreenColor()
        })
    }
}


// MARK: - Private Functions
private extension EFLCreateChallengeViewController {
    
    func activateSendButton() {return
        let barButtonItem = self.navigationItem.rightBarButtonItems![0]
        let sendButton = barButtonItem.customView as! UIButton
        
        if self.isValidChallenge() {
            sendButton.setTitleColor(UIColor.eflWhiteColor(), forState: UIControlState.Normal)
            sendButton.userInteractionEnabled = true
        }
        else {
            sendButton.setTitleColor(UIColor.efllighterGreyColor(), forState: UIControlState.Normal)
            sendButton.userInteractionEnabled = false
        }
    }
    
    func resignTexts() {
        challengeTableView.contentOffset = CGPointMake(0, 0)
        activeTextView?.resignFirstResponder()
    }
    
    func isValidChallenge() -> Bool {
        
        if EFLUtility.isEmptyString(createChallengeRequest.message){
            return false
        }
        if createChallengeRequest.players.count == 0 {
            return false
        }
        
        return true
    }
    
    func reloadPoolData() {
        self.activateSendButton()
        challengeTableView.reloadData()
    }
    
    func getTableHeader(section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 24))
        view.backgroundColor = UIColor.clearColor()
        
        let label = UILabel(frame: CGRectMake(16, section == 0 ? 40 : 0, 70, 24))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.eflBlackColor()
        label.font = FONT_MEDIUM_16
        
        view.addSubview(label)
        
        switch section {
        case 0:
            label.text = "CHALLENGE_MESSAGE_HEADER_TEXT".localized
        case 1:
            label.text = "CHALLENGE_PLAYERS_HEADER_TEXT".localized
        case 2:
            label.text = "CHALLENGE_MATCHES_HEADER_TEXT".localized
            
        default: break
        }
        
        if section != 0 {
            let labelRight = UILabel(frame: CGRectMake(CGRectGetWidth(view.frame) - 216, 0, 200, 24))
            let count = section == 1 ? createChallengeRequest.players.count : createChallengeRequest.matches.count
            labelRight.backgroundColor = UIColor.clearColor()
            labelRight.textColor = UIColor.eflMidGreyColor()
            labelRight.font = FONT_REGULAR_16
            labelRight.textAlignment = NSTextAlignment.Right
            labelRight.text = String(count + (section == 1 ? 1 : 0)) + " of 10 added"
            
            view.addSubview(labelRight)
        }
        
        return view
    }
    
    func addRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(EFLCreatePoolViewController.handleTap))
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
    }
}

