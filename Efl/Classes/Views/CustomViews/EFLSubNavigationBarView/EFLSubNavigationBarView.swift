//
//  UnderNavBarView.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 9/28/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

protocol EFLSubNavigationBarViewDelegate: class {
    func itemOnSubNavigationBarSelected(sender: EFLSubNavigationBarView, index: NSIndexPath)
}

enum ScrollDirection {
    case ScrollDirectionRight
    case ScrollDirectionLeft
}

class EFLSubNavigationBarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout, UIScrollViewDelegate   {

    var tapped: Bool  = false  //checking if user tapped on underNavBar at first, then
    weak var delegate: EFLSubNavigationBarViewDelegate? //collectionView Item pressed (under NavBar)
    
    private var titles: [String]?
    private var navBarColorType: EFLColorType? = nil
    private var deltaOfset: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var wholeTextWidth: CGFloat = 0
    private var padding: CGFloat = 0
    private var titlesCollectionView: UICollectionView? = nil
    private var color: EFLColorType!
     var triangleView: EFLTriangleView? = nil
    
    init(titles: [String], color: EFLColorType) {
        
        super.init(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 44))
        self.navBarColorType = color
        self.titles = titles
        
        self.backgroundColor = UIColor.clearColor()
        let index = NSIndexPath(forItem: 0, inSection: 0)
        
        collectionViewCreationWithSelectedItem(selectedItem: index, navigationColor: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EFLSubNavigationBarView {
    
    //method called when user makes swipe and triangleView moves to the choosen controller's title
    func moveTo(index: Int, percent: CGFloat) {
        
        let path = NSIndexPath(forItem: index, inSection: 0)
        
        self.titlesCollectionView?.scrollToItemAtIndexPath(path, atScrollPosition: .CenteredHorizontally, animated: true)
        
        if self.tapped == false {
            
            let itemsCount = self.titlesCollectionView!.numberOfItemsInSection(0)
            
            if index >= 0 && index < itemsCount {
                var indexPath = NSIndexPath(forItem: index, inSection: 0)
                let currentCell = self.titlesCollectionView!.cellForItemAtIndexPath(indexPath)
                let currentCellCenterX = currentCell!.center.x - self.lastContentOffset
                let currentCellArray = currentCell?.contentView.subviews
                
                for item in currentCellArray! {
                    if item.isKindOfClass(UILabel) {
                        let lable = item as! UILabel
                        lable.font = FONT_REGULAR_13
                        lable.sizeToFit()
                    }
                }
                
                var nextCellCenterX : CGFloat = 0.0
                if index + 1 != itemsCount {
                    indexPath = NSIndexPath(forItem: index + 1, inSection: 0)
                    let nextCell = self.titlesCollectionView!.cellForItemAtIndexPath(indexPath)
                    nextCellCenterX = nextCell!.center.x  - self.lastContentOffset
                } else {
                    nextCellCenterX = self.titlesCollectionView!.bounds.width
                }
                
                let difference = (nextCellCenterX - currentCellCenterX) * percent
                let centerY = self.triangleView!.center.y
                self.triangleView?.center = CGPointMake(currentCellCenterX + difference, centerY)
            }
        }
    }
    
    func highlightItemAt(index: Int)  {
        
        let path = NSIndexPath(forItem: index, inSection: 0)
        
        let cell = self.titlesCollectionView?.cellForItemAtIndexPath(path)
        
        let allVisibleCells = self.titlesCollectionView!.visibleCells()
        for i in allVisibleCells {
            self.changeFont(i, isHighLight: false)
        }
        
        if cell != nil {
            self.changeFont(cell!, isHighLight: true)
        }
    }
    
    func changeFont(cell : UICollectionViewCell, isHighLight: Bool) {
        let currentCellArray = cell.contentView.subviews
        for item in currentCellArray {
            if item.isKindOfClass(UILabel) {
                let lable = item as! UILabel
                lable.font = isHighLight ? FONT_BOLD_14 : FONT_REGULAR_13
                lable.sizeToFit()
            }
        }
    }
}



private extension EFLSubNavigationBarView  {
    //top collection view with, titles
    func collectionViewCreationWithSelectedItem(selectedItem itemIndexPath: NSIndexPath?, navigationColor:EFLColorType)  {
        
        color = navigationColor
        let padding = paddingCalculation()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom:0, right: padding)
        layout.scrollDirection = .Horizontal
        
        let frame = CGRectMake(0, 0, self.bounds.width, 30)
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        self.titlesCollectionView = collection
        
        if navigationColor == EFLColorType.Green {
            collection.backgroundColor = UIColor.eflGreenColor()
        } else {
            collection.backgroundColor = UIColor.whiteColor()
        }
        collection.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 30)
        collection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collection.alwaysBounceHorizontal = true
        collection.showsHorizontalScrollIndicator = false
        collection.selectItemAtIndexPath(itemIndexPath, animated: true, scrollPosition: .None)
        
        let compareWidth = self.wholeTextWidth + (self.padding * (CGFloat(self.titles!.count)+1))
        if compareWidth < UIScreen.mainScreen().bounds.width {
            collection.scrollEnabled = false
        } else {
            collection.scrollEnabled = true
        }
        
        self.addSubview(collection)
        
        self.triangleView = triangleViewCreation(navigationColor)
        
        let myCollectionViewcell =  collection.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: itemIndexPath!)
        self.triangleView?.center = CGPointMake(myCollectionViewcell.center.x, (self.triangleView?.center.y)!)
        self.deltaOfset = collection.contentOffset.x
    }
}


//MARK: - collectionViewDataSource
extension EFLSubNavigationBarView {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.titles?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let subArray = cell.contentView.subviews
        for item in subArray {
            item.removeFromSuperview()
        }
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 40))
        
        label.text = titles![indexPath.row]
        label.font = FONT_REGULAR_13
        
        if navBarColorType == .Green {
            label.textColor = UIColor.whiteColor()
        } else {
            label.textColor = UIColor.grayColor()
        }
        
        label.sizeToFit()
        cell.contentView.addSubview(label)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension EFLSubNavigationBarView {

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = calculateSizeOfText(self.titles![(indexPath.row)], font: FONT_REGULAR_13)
        
        return  size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.padding
    }
}

//MARK: - UICollectionViewDelegate

extension EFLSubNavigationBarView {
    
    //increse font size, when item is tapped
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.tapped = true
        
        let tappedCollectionViewcell =  collectionView.cellForItemAtIndexPath(indexPath)
        let tappedCollectionViewCellCenter = tappedCollectionViewcell!.center
        
        self.highlightItemAt(indexPath.row)
        
        //animate moving trinagleView
        UIView.animateWithDuration(0.3, animations: {
            self.triangleView?.center = CGPointMake(tappedCollectionViewCellCenter.x - self.lastContentOffset, (self.triangleView?.center.y)!)
        }) { (true) in
            self.tapped = false
        }
        self.delegate?.itemOnSubNavigationBarSelected(self, index: indexPath)
    }
}

//MARK:  - UIScrollViewDelegate

extension EFLSubNavigationBarView {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var scrollDirection: ScrollDirection
        
        if (self.lastContentOffset > scrollView.contentOffset.x) {
            scrollDirection = .ScrollDirectionRight;
            self.deltaOfset = scrollView.contentOffset.x - self.lastContentOffset
            self.triangleView?.center.x -= self.deltaOfset
        }
        else if (self.lastContentOffset < scrollView.contentOffset.x) {
            scrollDirection = .ScrollDirectionLeft;
            self.deltaOfset = self.lastContentOffset - scrollView.contentOffset.x
            self.triangleView?.center.x += self.deltaOfset
        }
        
        self.lastContentOffset = scrollView.contentOffset.x;
    }
}


private extension EFLSubNavigationBarView  {
    // padding calculation for collectionView
    func  paddingCalculation() -> CGFloat {
        for text in self.titles! {
            let sizeOfText = calculateSizeOfText(text, font:FONT_REGULAR_13)
            self.wholeTextWidth  += sizeOfText.width
        }
        let size = UIScreen.mainScreen().bounds.width - self.wholeTextWidth
        var padding : CGFloat = 40
        
        if self.titles != nil {
            padding = size / CGFloat(self.titles!.count+1)
            self.padding = padding
            if self.padding < 40 {
                padding = 40
            }
        }
        return padding
    }
    
    //triangle view creation  with color
    func triangleViewCreation(color: EFLColorType) -> EFLTriangleView? {
        
        let triangleView = EFLTriangleView(view: self, type: .White, multiplyWidth: self.titles!.count)
        if color == .Green {
            triangleView.color = .Green
        } else {
            triangleView.color = .White
        }
        
        return triangleView
    }
}


private extension EFLSubNavigationBarView {
    
    func indexPathForLastCell() -> NSIndexPath {
        
        return NSIndexPath(forRow: self.titles!.count - 1, inSection: 0)
    }
    //help func, for text size(width) calculation
    func calculateSizeOfText(string: String, font: UIFont!) -> CGSize {
        
        var sizeOfString = CGSize()
        
        if let font = font
        {
            let text = string
            let fontAttributes = [NSFontAttributeName: font]
            sizeOfString = (text as NSString).sizeWithAttributes(fontAttributes)
        }
        return sizeOfString
    }
    
}


