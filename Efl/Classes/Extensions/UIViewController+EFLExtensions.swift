//
//  EFLControllersManager.swift
//  Efl
//
//  Created by TS on 23.09.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit


typealias EmptyFunk = () -> Void


extension UIViewController {
    
    func pushViewController(toViewController: UIViewController, animation: EFLTransitionAnimationType) {
        let navigationController = self.navigationController as! EFLBaseNavigationController
        
        switch animation {
        case .None:
            navigationController.pushViewController(toViewController, animated: false)
        case .Default:
            navigationController.pushViewController(toViewController, animated: true)
        case .FlipHorizontal:
            UIView.beginAnimations("View Flip", context: nil)
            UIView.setAnimationDuration(0.8)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationTransition(.FlipFromRight, forView: (self.navigationController?.view)!, cache: false)
        
            navigationController.pushViewController(toViewController, animated: false)
            UIView.commitAnimations()
        }
    }
    
    func popViewController(animation: EFLTransitionAnimationType) {
        let navigationController = self.navigationController as! EFLBaseNavigationController
        
        switch animation {
        case .None:
            navigationController.popViewControllerAnimated(false)
        case .Default:
            navigationController.popViewControllerAnimated(true)
        case .FlipHorizontal:
            UIView.beginAnimations("View Flip", context: nil)
            UIView.setAnimationDuration(0.8)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationTransition(.FlipFromLeft, forView: (self.navigationController?.view)!, cache: false)
        
            navigationController.popViewControllerAnimated(false)
            UIView.commitAnimations()
        }
    }
    
    func presentViewController(toViewController: UIViewController, animation: EFLTransitionAnimationType, comletion: (() -> Void)?) {
        
        switch animation {
        case .None:
            self.presentViewController(toViewController, animated: false, completion:  comletion)
            return
        case .Default:
            self.presentViewController(toViewController, animated: true, completion:  comletion)
            return
        case .FlipHorizontal:
            let navigationController = EFLBaseNavigationController(rootViewController: toViewController)
            toViewController.modalTransitionStyle = .FlipHorizontal
            self.presentViewController(navigationController, animated: true, completion:  comletion)
        }
    }
    
    func dismissViewController(animation: EFLTransitionAnimationType, completion: (() -> Void)?) {
        switch animation {
        case .None:
            self.dismissViewControllerAnimated(false, completion: completion)
            return
        case .Default:
            self.dismissViewControllerAnimated(true, completion: completion)
            return
        case .FlipHorizontal:
            self.dismissViewControllerAnimated(true, completion: completion)
        }
    }
}








