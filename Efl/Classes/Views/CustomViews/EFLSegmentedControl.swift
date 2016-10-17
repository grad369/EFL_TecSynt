//
//  EFLSegmentedControl.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

protocol EFLSegmentedControlDelegate{
    func segmentedControlDidSelectIndex(segmentedControl: EFLSegmentedControl, selectedIndex: Int)
}

class EFLSegmentedControl: UIView {
    var delegate:EFLSegmentedControlDelegate?
    var buttonCount = 0
    var bgColor = UIColor.clearColor()

    init()
    {
        super.init(frame: CGRectMake(0, 0, CGRectGetWidth(APP_DELEGATE.window!.frame), 44))
        
        self.layer.shadowColor = UIColor.eflBlackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.5;
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpControl(color: UIColor, buttonTitles: [String]) {
        
        self.bgColor = color
        self.buttonCount = buttonTitles.count
        self.backgroundColor = color
        var x = CGFloat(16)
        for (index, element) in buttonTitles.enumerate() {
            let button = UIButton.init(type: UIButtonType.Custom)
            let width = (CGRectGetWidth(self.frame) - 32) / CGFloat(buttonTitles.count)
            button.frame = CGRectMake(x, 0, width, 44)
            button.backgroundColor = UIColor.clearColor()
            
            button.setTitle(element, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.eflWhiteColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = FONT_REGULAR_16
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.tag = index + 1
            
            x = x + width
            
            self.addSubview(button)
            button.addTarget(self, action: #selector(buttonDidPress), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func setSelectedIndex(index: Int) {
        let button = self.viewWithTag(index) as! UIButton
        self.buttonDidPress(button)
    }

    func buttonDidPress(sender : AnyObject?) {
        
        let button = sender as! UIButton
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        let viewWidth = CGRectGetWidth(self.frame)
        let width = (CGRectGetWidth(self.frame) - 32) / CGFloat(buttonCount)
        path.addLineToPoint(CGPointMake(viewWidth, 0))
        path.addLineToPoint(CGPointMake(viewWidth, 44))
        path.addLineToPoint(CGPointMake(viewWidth - 16, 44))
        var currentX = viewWidth - 16

        
        if button.tag == 1 {
            currentX = currentX - width
            path.addLineToPoint(CGPointMake(currentX, 44))
            currentX = currentX - ( (width / 2) - 6)
            path.addLineToPoint(CGPointMake(currentX, 44))
            currentX = currentX - 6
            path.addLineToPoint(CGPointMake(currentX, 38))
            currentX = currentX - 6
            path.addLineToPoint(CGPointMake(currentX, 44))
            path.addLineToPoint(CGPointMake(0, 44))
            path.addLineToPoint(CGPointMake(0, 0))

        }
        else {
            currentX = currentX - ( (width / 2) - 6)
            path.addLineToPoint(CGPointMake(currentX, 44))
            currentX = currentX - 6
            path.addLineToPoint(CGPointMake(currentX, 38))
            currentX = currentX - 6
            path.addLineToPoint(CGPointMake(currentX, 44))
            path.addLineToPoint(CGPointMake(0, 44))
            
            path.addLineToPoint(CGPointMake(0, 0))

        }

        path.closePath()
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.CGPath
        shapeLayer.backgroundColor = UIColor.yellowColor().CGColor
        shapeLayer.fillColor = UIColor.eflGreenColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.shadowColor = UIColor.blackColor().CGColor
        shapeLayer.shadowOffset = CGSizeMake(0.0, 0.0);
        shapeLayer.shadowRadius = 2.0;
        shapeLayer.shadowOpacity = 1.0;
        self.layer.mask = shapeLayer
        self.delegate?.segmentedControlDidSelectIndex(self, selectedIndex: button.tag)
    }
    
    
    func addShadowLayer(){
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.5;
    }
}
