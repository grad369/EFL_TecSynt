//
//  EFLFriendsShareActionSheet.swift
//  Efl
//
//  Created by vishnu vijayan on 11/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

protocol EFLFriendsShareActionSheetDelegate{
    func actionSheetSelected(tag: Int)
}

class EFLFriendsShareActionSheet: UIView, UITableViewDataSource, UITableViewDelegate {
    private var shareTableView : UITableView!
    private var cancelButton : EFLHighLightButton!
    var delegate:EFLFriendsShareActionSheetDelegate?

    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.setUpButton()
        self.setUpTable()
    }

    func setUpButton() {
        cancelButton = EFLHighLightButton.init(type: UIButtonType.Custom)
        cancelButton.frame = CGRectMake(0, 357, CGRectGetWidth(self.frame), 50)
        cancelButton.backgroundColor = UIColor.eflWhiteColor()
        cancelButton.bgColor = UIColor.eflWhiteColor()
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.setTitle("ALERT_CANCEL_BUTTON_TITLE".localized, forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.eflGreenColor(), forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = FONT_REGULAR_16
        cancelButton.addTarget(self, action: #selector(cancelButtonDidPress), forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(cancelButton)
    }
    
    func cancelButtonDidPress() {
        self.delegate?.actionSheetSelected(8)
    }

    func setUpTable() {
        
        shareTableView = UITableView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), 350), style: UITableViewStyle.Plain)
        shareTableView.backgroundColor = UIColor.eflLightGreycolor()
        shareTableView.dataSource = self
        shareTableView.delegate = self
        shareTableView.layer.cornerRadius = 4.0
        shareTableView.scrollEnabled = false
        shareTableView.registerNib(UINib(nibName: "EFLFriendsShareCell", bundle: nil), forCellReuseIdentifier: friendsShareCellIdentifier)
        shareTableView.reloadData()
        self.addSubview(shareTableView)
    }
    
    // MARK: UITableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:EFLFriendsShareCell = tableView.dequeueReusableCellWithIdentifier(friendsShareCellIdentifier) as! EFLFriendsShareCell
        self.setCellData(indexPath, cell: cell)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    // MARK: UI Tableview Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.delegate?.actionSheetSelected(indexPath.row)
    }
    
    // MARK: - Set Cell component
    func setCellData(indexPath: NSIndexPath, cell: EFLFriendsShareCell) {
        switch indexPath.row {
        case 0:
            cell.shareLabel.text = "INVITE_FACEBOOK_FRIENDS_TEXT".localized
            cell.shareImageView.image = UIImage(named: "FacebookMildGreyIcon")
            break
        case 1:
            cell.shareLabel.text = "MESSAGE_WHATSAPP_TEXT".localized
            cell.shareImageView.image = UIImage(named: "WhatsappMildGreyIcon")
            break
        case 2:
            cell.shareLabel.text = "MESSAGE_LINE_TEXT".localized
            cell.shareImageView.image = UIImage(named: "LINEMildGreyIcon")
            break
        case 3:
            cell.shareLabel.text = "MESSAGE_WECHAT_TEXT".localized
            cell.shareImageView.image = UIImage(named: "WeChatMildGreyIcon")
            break
        case 4:
            cell.shareLabel.text = "TWEET_INVITE_TEXT".localized
            cell.shareImageView.image = UIImage(named: "TwitterMildGreyIcon")
            break
        case 5:
            cell.shareLabel.text = "EMAIL_FRIENDS_TEXT".localized
            cell.shareImageView.image = UIImage(named: "EmailMildGreyIcon")
            break
        case 6:
            cell.shareLabel.text = "MORE_TEXT".localized
            cell.shareImageView.image = UIImage(named: "MoreMildGreyIcon")
            break
            
        default:
            break
        }
    }
}
