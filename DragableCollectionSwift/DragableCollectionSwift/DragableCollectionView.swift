//
//  DragableCollectionView.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/21/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

enum DEAutoScrollDirection{
    case DEAutoScrollDirectionUnknown
    case DEAutoScrollDirectionUp
    case DEAutoScrollDirectionDown
    case DEAutoScrollDirectionLeft
    case DEAutoScrollDirectionRight
}

@objc protocol DECollectionViewDatasource{
    
    func optionsArrayforCollectionView() -> NSArray;
    optional func willMoveItem (collectionView:DragableCollectionView?, fromIndexpath:NSIndexPath?, toIndexpath:NSIndexPath?)
    optional func didMoveItem (collectionView:DragableCollectionView?, fromIndexpath:NSIndexPath?, toIndexpath:NSIndexPath?)
}

@objc protocol DECollectionViewDelegate{
    
}

class DragableCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var optionsArr : NSMutableArray?
    var isEditable = false
    
    var dragEnableCollectionDatasource : DECollectionViewDatasource?
    var dragEnableCollectionDelegate : DECollectionViewDelegate?
    
    var draggedCell :DragableCell?
    var selectedIndexPath : NSIndexPath?
    var selectedOption : Option?
    var scrollTimer : NSTimer?
    var scrollDirection : UICollectionViewScrollDirection?
    var scrollingSpeed = 0.0
    var displayLink : CADisplayLink?
    var autoScrollDirection = DEAutoScrollDirection.DEAutoScrollDirectionUnknown
    
    var autoscrollBounds = CGRectZero
    var dragBounds = CGRectZero
    var dragCellSize = CGRectZero
    
    var currentView : UIView?
    
    var initialPos : CGPoint?
    var currentViewCenter : CGPoint?
    var panTranslationInCollectionView : CGPoint?
    var toPoint : CGPoint?
    
    var scrollingTriggerEdgeInsets : UIEdgeInsets?
    var phantomCellIndex : NSInteger?
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
//    override init(frame: CGRect) {
//        self.setupCollectionView()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//        self.setupCollectionView()
//    }
    
    // MARK:- setup
    
    func setupCollectionView(){
        self.registerClass( DragableCell.self, forCellWithReuseIdentifier: "DragableCell")
        let flowloayout = DragableCollectionViewLayout()
        self.setCollectionViewLayout(flowloayout, animated: true)
        self.dataSource = self
        self.delegate = self
        scrollingTriggerEdgeInsets = UIEdgeInsetsMake(100, 100, 100, 100)
        phantomCellIndex = NSNotFound
        
    }
    
    // MARK:-  reload
    
    override func reloadData() {
        if optionsArr? == nil {
            NSLog("not initialised")
            self.optionsArr = self.dragEnableCollectionDatasource?.optionsArrayforCollectionView().mutableCopy() as? NSMutableArray
        }
    }
    
    // MARK:- collectionView dataSource/delegate/lowlayout
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 0;
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell : UICollectionViewCell?
        
        return cell!
    }
    // MARK:- scrollView delegate
    
    // MARK:- gesture recognizer delegate
    
    

    
}
