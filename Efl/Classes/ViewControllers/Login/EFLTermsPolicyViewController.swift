//
//  EFLTermsPolicyViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 02/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import SafariServices

class EFLTermsPolicyViewController: EFLBaseViewController {
    @IBOutlet weak var webView: UIWebView!
    var spinner: EFLActivityIndicator!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "SETTINGS_TERMS_PRIVACY_TEXT".localized

        let url = NSURL (string: URLTermsAndPolicy);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        //self.addNavigationBackButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIWebView Delegate Methods
    
    func webViewDidStartLoad(webView: UIWebView) {
        
//        EFLActivityIndicator.sharedSpinner.showIndicator()
        self.spinner = EFLActivityIndicator (supView: self.view, size: CGSizeMake(self.view.frame.width, self.view.frame.height), centerPoint: self.view.center)
        self.spinner.showIndicator()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
//        EFLActivityIndicator.sharedSpinner.hideIndicator()
        self.spinner.hideIndicator()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        EFLUtility.showOKAlertWithMessage((error?.localizedDescription)!, andTitle: EmptyString)
    }
}
