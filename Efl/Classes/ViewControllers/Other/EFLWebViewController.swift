//
//  EFLWebViewController.swift
//  Efl
//
//  Created by vaskov on 02/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import SafariServices

class EFLWebViewController: EFLBaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    lazy private var spinner: EFLActivityIndicator = {
        return EFLActivityIndicator(supView: self.view, size: CGSizeMake(40, 40))
    }()
}


// MARK: - EFLBaseViewController's functions
extension EFLWebViewController {
    
    override func configurationNavigationAndStatusBars() {
        self.setConfigurationStatusBar(.Green)
        self.setConfigurationNavigationBar("SETTINGS_TITLE".localized, titleView: nil, backgroundColor: .Green)
        self.setBarButtonItem(.Back, placeType: .Left, tintColorType: .White)
    }
}


// MARK: - Public methods
extension EFLWebViewController {
    
    func load(url urlString: String, title: String) {
        let url = NSURL(string: urlString)
        let requestObj = NSURLRequest(URL: url!)
        self.webView.loadRequest(requestObj)
        
        self.title = title.localized
    }
}


// MARK: - Actions
extension EFLWebViewController {
    
    func leftBarButtonItemDidPress() {
        self.popViewController(.Default)
    }
}


// MARK: - UIWebView Delegate Methods
extension EFLWebViewController {
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        spinner.showIndicator()
        self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height), centerPoint: self.view.center)
        self.spinner.showIndicator()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        spinner.hideIndicator()
        self.spinner.hideIndicator()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        EFLUtility.showOKAlertWithMessage((error.localizedDescription), andTitle: EmptyString)
    }
}
