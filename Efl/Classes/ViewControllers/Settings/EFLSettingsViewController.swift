//
//  EFLSettingsViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 27/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit


class EFLSettingsViewController: EFLBaseViewController, ProfileUpdateDelegate {
    @IBOutlet weak var settingsTableView: UITableView!

    private var tableArray: [String] = [
                                    "SETTINGS_NOTIFICATION_TEXT".localized,
                                    "SETTINGS_RULES_TEXT".localized,
                                    "SETTINGS_TELL_A_FRIEND_TEXT".localized,
                                    "SETTINGS_GIVE_US_FEEDBACK_TEXT".localized,
                                    "SETTINGS_TERMS_PRIVACY_TEXT".localized,
                                    "SETTINGS_LICENSES_TEXT".localized
                                ]

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        if EFLManager.sharedManager.isPlayerRefreshed {
            settingsTableView.reloadData()
            EFLManager.sharedManager.isPlayerRefreshed = false
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: REFRESH_DATA_NOTIFICATION, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: REFRESH_DATA_NOTIFICATION, object: nil)
    }
}


// MARK: - EFLBaseViewController's functions
extension EFLSettingsViewController {
    
    override func configurationNavigationAndStatusBars() {
        self.setConfigurationStatusBar(.Green)
        self.setConfigurationNavigationBar("SETTINGS_TITLE".localized, titleView: nil, backgroundColor: .Green)
    }
    
    override func configurationView() {
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        settingsTableView.registerNib(UINib(nibName: "EFLProfileCell", bundle: nil), forCellReuseIdentifier: profileCellIdentifier)
        settingsTableView.registerNib(UINib(nibName: "EFLSettingsCell", bundle: nil), forCellReuseIdentifier: settingsCellIdentifier)
        settingsTableView.registerNib(UINib(nibName: "EFLSettingsLogoCell", bundle: nil), forCellReuseIdentifier: settingsLogoCellIdentifier)
    }
}


// MARK: Actions
extension EFLSettingsViewController {
    
    func reloadData() {
        EFLManager.sharedManager.isPlayerRefreshed = false
        settingsTableView.reloadData()
    }
}


// MARK: - UITableView DataSource Methods
extension EFLSettingsViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return tableArray.count + 1
        }
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell:EFLProfileCell = tableView.dequeueReusableCellWithIdentifier(profileCellIdentifier) as! EFLProfileCell
            cell.setData()
            return cell
        }
        else {
            if indexPath.row == tableArray.count {
                let cell:EFLSettingsLogoCell = tableView.dequeueReusableCellWithIdentifier(settingsLogoCellIdentifier) as! EFLSettingsLogoCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.eflLightGreycolor().CGColor
                return cell
            }
            else {
                let cell:EFLSettingsCell = tableView.dequeueReusableCellWithIdentifier(settingsCellIdentifier) as! EFLSettingsCell
                cell.settingsLabel.text = tableArray[indexPath.row]
                if indexPath.row == tableArray.count - 1 {
                    cell.separatorInset = UIEdgeInsetsZero
                    cell.layoutMargins = UIEdgeInsetsZero
                }
                else {
                    cell.separatorInset.left = 16
                }
                return cell
            }
            
        }
    }
}


// MARK: - UI Tableview Delegate
extension EFLSettingsViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 85
        }
        else
        {
            if indexPath.row == tableArray.count {
                return 60
            }
            else {
                return 50
            }
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.section == 0 {
            
            let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier(PROFILE_VIEW_CONTROLLER_ID) as? EFLProfileViewController
            profileVC?.delegate = self
            self.pushViewController(profileVC!, animation: .Default)
        } else {
            var url: String = ""
            var title: String = ""
            
            switch indexPath.row {
            case 0:
                
                return
            case 1:
                url = URL_RULES
                title = "RULES"
            case 2:
                return
            case 3:
                url = URL_CONTACT
                title = "CONTACT"
            case 4:
                url = URL_TERMS
                title = "TERMS"
            case 5:
                url = URL_LICENSES
                title = "LICENSES"
                
            default: break
            }
            
            if url != "" && title != "" {
                let webVC = self.storyboard?.instantiateViewControllerWithIdentifier(WEB_VC_ID) as! EFLWebViewController
                print(webVC)
                self.pushViewController(webVC, animation: .Default)
                _ = webVC.view
                webVC.load(url: url, title: title.localized)
            }
        }
    }
}


// MARK: - ProfileUpdateDelegate
extension EFLSettingsViewController {
    
    func reloadSettingsData(reverted: Bool) {
        if reverted {
            self.settingsTableView.reloadData()
        }
    }
}
