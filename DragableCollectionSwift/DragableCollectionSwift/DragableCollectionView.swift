//
//  DragableCollectionView.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/21/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit



@objc protocol DECollectionViewDatasource{
    
    func optionsArrayforCollectionView() -> NSArray;
    optional func willMoveItem (collectionView:DragableCollectionView?, fromIndexpath:NSIndexPath?, toIndexpath:NSIndexPath?)
    optional func didMoveItem (collectionView:DragableCollectionView?, fromIndexpath:NSIndexPath?, toIndexpath:NSIndexPath?)
    optional func canMoveItemAtIndexPath (collectionView: DragableCollectionView?, targetIndexPath: NSIndexPath?) -> Bool
    
}

@objc protocol DECollectionViewDelegate{
    
    optional func beginEditing (collectionView:DragableCollectionView?, gestureRecognizer:UILongPressGestureRecognizer?)
    
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
    
    //MARK:- init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollectionView()
    }

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.setupCollectionView()
    }
    
    // MARK:- setup
    
    func setupCollectionView(){
        
        //self.registerClass( DragableCell.self, forCellWithReuseIdentifier: "DragableCell")
        self.registerNib(UINib(nibName: "DragableCell", bundle: nil), forCellWithReuseIdentifier: "DragableCell")
        let flowloayout = DragableCollectionViewLayout()
        self.setCollectionViewLayout(flowloayout, animated: true)
        self.dataSource = self
        self.delegate = self
        scrollingTriggerEdgeInsets = UIEdgeInsetsMake(100, 100, 100, 100)
        phantomCellIndex = NSNotFound
        self.configureGestures()
        
    }
    
    func configureGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture"))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK:-  reload
    
    override func reloadData() {
        if optionsArr? == nil {
            NSLog("not initialised")
            self.optionsArr = self.dragEnableCollectionDatasource?.optionsArrayforCollectionView().mutableCopy() as? NSMutableArray
        }
        super.reloadData()
    }
    
    // MARK:- collectionView dataSource/delegate/lowlayout
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return self.optionsArr!.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("DragableCell", forIndexPath: indexPath) as DragableCell
        let anOption = self.optionsArr!.objectAtIndex(indexPath.row) as Option
        cell.optionImageView?.image = anOption.optionImage
        cell.optionLbl?.text = anOption.optionTitle
        
        let registeredGestures : NSArray? = cell.gestureRecognizers
        
        if ((registeredGestures?) == nil) {
            
            NSLog("long press added")
            let longPress = UILongPressGestureRecognizer(target: self, action: Selector("handlLongPress"))
            cell.addGestureRecognizer(longPress)
        }
        

         //cell.startQuivering()
        
        if self.isEditable{
            cell.startQuivering()
        }else{
            cell.stopQuivering()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, 150)
    }
    // MARK:- scrollView delegate
    
    // MARK:- gesture recognizer and delegate
    
    func handlLongPress(){
        NSLog("long pressed")
        self.isEditable = true
        self.reloadData()
    }
    
    func handleTapGesture(){
        self.isEditable = false
        self.reloadData()
    }

    
}
