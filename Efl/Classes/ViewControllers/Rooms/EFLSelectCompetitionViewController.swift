//
//  EFLSelectCompetitionViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 24/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

protocol EFLSelectCompetitionDelegate{
    func didSelectCompetition(competitionId: Int)
}

class EFLSelectCompetitionViewController: EFLBaseViewController {
    @IBOutlet weak var competitionTableView: UITableView!
    
    var delegate:EFLSelectCompetitionDelegate?
    var competitionArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateView()
    }
    
    override func configurationView() {
        self.setFooter()
        self.navigationItem.title = "SELECT_COMPETITION_TITLE".localized
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        competitionTableView.registerNib(UINib(nibName: "EFLSelectCompetitionCell", bundle: nil), forCellReuseIdentifier: selectCompetitionCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    func backButtonAction() {
        if self.navigationController!.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: View setup
    func setFooter() {
        let backgroundFooterView : UIView = UIView (frame: CGRectMake(0,0,0,40))
        let footerLabel = UILabel(frame:CGRectMake(10, 0, self.view.frame.size.width - 20, 40))
        footerLabel.font = FONT_REGULAR_13
        footerLabel.numberOfLines = 0
        footerLabel.textAlignment = NSTextAlignment.Center
        footerLabel.textColor = UIColor.eflDarkGreyColor()
        footerLabel.text = "FOOTER_TITLE".localized
        
        backgroundFooterView.backgroundColor = UIColor.clearColor()
        backgroundFooterView.addSubview(footerLabel)
        competitionTableView.tableFooterView = backgroundFooterView
    }
    
    func populateView (){
        
        if let array = EFLCompetitionDataManager.sharedDataManager.getCompetitions() {
            competitionArray = array as! [NSManagedObject]
            [self.competitionTableView .reloadData()]
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "No Competitions", yOffset: 0)
        }
    }
    
    
    // MARK: UITableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitionArray.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:EFLSelectCompetitionCell = tableView.dequeueReusableCellWithIdentifier(selectCompetitionCellIdentifier) as! EFLSelectCompetitionCell
        let competition: NSManagedObject? = competitionArray[indexPath.row]
        if let comp = competition {
            //            cell.competitionLabel.text = comp.valueForKey("pretty_display_name") as? String
            cell.competitionLabel.text = "Competition " + (comp.valueForKey("competition_id") as? String)!
            
        }
        return cell
    }
    
    // MARK: UI Tableview Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let competition: NSManagedObject? = competitionArray[indexPath.row]
        
        if self.navigationController!.presentingViewController != nil {
            self.delegate?.didSelectCompetition(Int((competition?.valueForKey("competition_id"))! as! String)!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            let createPoolVC = self.storyboard?.instantiateViewControllerWithIdentifier(CREATE_POOL_VIEW_CONTROLLER_ID) as? EFLCreatePoolViewController
            createPoolVC?.createPoolRequest.competition_id = Int((competition?.valueForKey("competition_id"))! as! String)!
            self.navigationController?.pushViewController(createPoolVC!, animated: true)
        }
    }
    
}
