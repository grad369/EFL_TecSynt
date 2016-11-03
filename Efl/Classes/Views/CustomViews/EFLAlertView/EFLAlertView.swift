//
//  EFLAlertController.swift
//  Efl
//
//  Created by vaskov on 21.09.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit

protocol EFLAlertViewDelegate {
    func challengeButtonClickWithAlertView(view: EFLAlertView)
    func poolButtonClickWithAlertView(view: EFLAlertView)
}


class EFLAlertView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var alertViewWithoutCancelButton: UIView!
    @IBOutlet weak var bottomCancelButtonConstraint: NSLayoutConstraint!
    
    var delegate: EFLAlertViewDelegate?
    
    private var defaultTopAlertView: CGFloat?
}


// MARK: - Public functions
extension EFLAlertView {

    class func alertView() -> EFLAlertView {
        let alertView = NSBundle.mainBundle().loadNibNamed("EFLAlertView", owner: nil, options: nil)![0] as! EFLAlertView
        alertView.frame = APP_DELEGATE.window!.frame
        
        return alertView
    }
    
    func show() {
        
        APP_DELEGATE.window!.addSubview(self)
        
        self.backgroundView.alpha = 0
        self.defaultTopAlertView = self.frame.height
        self.bottomCancelButtonConstraint.constant -= self.defaultTopAlertView!
        self.layoutIfNeeded()
        
        self.bottomCancelButtonConstraint.constant += self.defaultTopAlertView!
        UIView.animateWithDuration(0.5, animations: {
            self.backgroundView.alpha = 0.4
            self.layoutIfNeeded()
        })
    }
    
    func hide() {
        self.bottomCancelButtonConstraint.constant -= self.defaultTopAlertView!
        
        UIView.animateWithDuration(0.5, animations: {
            self.backgroundView.alpha = 0.0
            self.layoutIfNeeded()
        }) { (bool) in
            self.removeFromSuperview()
        }
    }
}


// MARK: - Actions
extension EFLAlertView {
    
    @IBAction func challengeButtonClick(sender: AnyObject) {
        delegate!.challengeButtonClickWithAlertView(self)
        self.hide()
    }
    
    @IBAction func poolButtonClick(sender: AnyObject) {
        delegate!.poolButtonClickWithAlertView(self)
        self.hide()
    }
    
    @IBAction func cancelButtonClick(sender: AnyObject) {
        self.hide()
    }
}
