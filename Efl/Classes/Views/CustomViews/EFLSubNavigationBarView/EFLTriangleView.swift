//
//  TriangleView.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 9/30/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

class EFLTriangleView: UIView {
    
    private var trinagleSuperView: UIView? = nil
    var color: EFLColorType? = nil
    
    init(view: UIView, type: EFLColorType, multiplyWidth: Int) {
        
        super.init(frame: CGRectMake(view.frame.origin.x - view.frame.width-10, 27, CGRectGetWidth(view.bounds)*CGFloat(multiplyWidth), 14))
        self.backgroundColor = UIColor.clearColor()
        self.trinagleSuperView = view
        self.color = type
        
        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Overriding this function, we make custom view with triangle cutout, and different fill color.
    override func drawRect(rect: CGRect) {
        
        let customViewHeight: CGFloat = 1
        let plusPath = UIBezierPath()
        plusPath.lineWidth = customViewHeight
        
        if self.color == .White {
            
            plusPath.moveToPoint(CGPointMake(0, 0)) // Path creation
            plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 0))
            plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 + 10, 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2, 5))            //top of triangle
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 - 10, 14))
            plusPath.addLineToPoint(CGPointMake(0, 14))
            plusPath.addLineToPoint(CGPointMake(0, 0))
            UIColor.whiteColor().setFill()
            plusPath.fill()
            
            self.layer.shadowColor = UIColor.lightGrayColor().CGColor //Shadow
            self.layer.shadowOffset = CGSizeMake(1, 2);
            self.layer.shadowOpacity = 1;
            self.layer.masksToBounds = false
            self.layer.shadowRadius = 1;
            
        } else {
            
            plusPath.moveToPoint(CGPointMake(0, 0)) // Path creation
            plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 0))
            plusPath.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 + 10, 14))
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2, 5))           //top of triangle
            plusPath.addLineToPoint(CGPointMake(self.frame.width/2 - 10, 14))
            plusPath.addLineToPoint(CGPointMake(0, 14))
            plusPath.addLineToPoint(CGPointMake(0, 0))
            UIColor.eflGreenColor().setFill()
            plusPath.fill()
            
            self.layer.shadowColor = UIColor.lightGrayColor().CGColor //Shadow
            self.layer.shadowOffset = CGSizeMake(0,1);
            self.layer.shadowOpacity = 1;
            self.layer.masksToBounds = false
            self.layer.shadowRadius = 1;
        }
    }
}
