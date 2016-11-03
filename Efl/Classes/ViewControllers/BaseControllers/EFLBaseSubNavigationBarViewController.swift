//
//  CollectionViewController.swift
//  UnderNavBarView
//
//  Created by Anton Voropaev on 10/21/16.
//  Copyright © 2016 Anton Voropaev. All rights reserved.
//

import UIKit

class EFLBaseSubNavigationBarViewController: EFLBaseViewController, EFLSubNavigationBarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var titles: [String] = Array()
    private var underView: EFLSubNavigationBarView!
    private var controllersStack : [UIViewController]! //Content Controllers
    private var lastContentOffset: CGFloat = 0

    private var page: Int!
    private var percent: CGFloat!
    private var navBarHeight: CGFloat!
    
    lazy var collection: UICollectionView = {
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.eflLightGreycolor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true

        self.view.addSubview(collectionView)
    
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        collection.reloadData()
        
        if subNavigationBar() != nil {
            
            self.underView = subNavigationBar()!
            self.underView.delegate = self
            self.navBarHeight = 44
            self.underView.clipsToBounds = true
        }
        self.view.addSubview(underView)
        
        if let pageControllers = self.pageControllers() {
            self.controllersStack = pageControllers
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        collection.delegate = self
       
    }
    override func viewDidAppear(animated: Bool) {
         self.underView.clipsToBounds = false
    }
   
    override func viewWillDisappear(animated: Bool) {
        self.underView.triangleView?.hidden = true
    }

}


// MARK: - ChildMethods
extension EFLBaseSubNavigationBarViewController {
    
    func pageControllers() -> [UIViewController]? {
        
        return nil
    }
    
    func subNavigationBar() -> EFLSubNavigationBarView? {
        
        return nil
    }
}


extension EFLBaseSubNavigationBarViewController {
    
    override func showBannerViewWith(text: String) {
        let bannerView = EFLBannerView()
        bannerView.showBanner(self.underView, message: "Defult SubNav message", yOffset: 44)
    }
}


//MARK: - CollectionViewDataSource
extension EFLBaseSubNavigationBarViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.controllersStack.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let subArray = cell.contentView.subviews
        for item in subArray {
            item.removeFromSuperview()
        }
        
        let VC = self.controllersStack[indexPath.row]
        cell.contentView.addSubview(VC.view)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let page = Int(offsetX/width)
        let percent = (offsetX / width) - CGFloat(page)
       // var isScrolling: Bool = true
        
        self.underView.moveTo(page, percent: percent) // Calculation Offset in Percent
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.width, self.view.frame.height)
    }
    
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.width
        let page = Int(offsetX/width)
       // let percent = (offsetX / width) - CGFloat(page)

        print("FINISHED!!! page \(page)")
         // Calculation Offset in Percent
        self.underView.highlightItemAt(page)
    }
}


//MARK: - UnderNavBarDelegate
extension EFLBaseSubNavigationBarViewController {
    
    func itemOnSubNavigationBarSelected(sender: EFLSubNavigationBarView, index: NSIndexPath) { //delegate method for click on UnderNavBarView
        
        showControllerAtIndex(index.row)
        
        self.showBannerViewWith("HELLLO!!YES))")
    }
    
    func showControllerAtIndex(selectedIndex: Int)  {
        let path = NSIndexPath(forItem: selectedIndex, inSection: 0)
        self.collection.scrollToItemAtIndexPath(path, atScrollPosition: .CenteredHorizontally, animated: true)
    }
}





    

