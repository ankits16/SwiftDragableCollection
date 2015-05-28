//
//  DragableCollectionViewLayout.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/21/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

@objc protocol DragableCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout{
    
    optional func willBeginDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
    optional func didBeginDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
    optional func willEndDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
    optional func didEndDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
}

let LX_FRAMES_PER_SECOND = 60.0
//
//#if CGGEOMETRY_LXSUPPORT_H_
//    CG_INLINE CGPoint LXS_CGPointAdd(CGPoint point1, CGPoint point2) = {
//    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
//    }
//#endif

extension CADisplayLink{
    func setLX_userInfo(userInfo:NSDictionary?){
        //objc_setAssociatedObject(self, "LX_userInfo", userInfo, OBJC_ASSOCIATION_COPY)
        objc_setAssociatedObject(self, "LX_userInfo", userInfo!, objc_AssociationPolicy(OBJC_ASSOCIATION_COPY))
    }
    
    func LX_userInfo() -> NSDictionary{
        return objc_getAssociatedObject(self, "LX_userInfo") as NSDictionary
    }
}

extension UICollectionViewCell{
    func DC_raterizedImage () -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()  as UIImage
        UIGraphicsEndImageContext()
        return image
    }
}

enum DEAutoScrollDirection{
    case DEAutoScrollDirectionUnknown
    case DEAutoScrollDirectionUp
    case DEAutoScrollDirectionDown
    case DEAutoScrollDirectionLeft
    case DEAutoScrollDirectionRight
}


class DragableCollectionViewLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate {
    let kDCScrollingDirectionKey = "DCScrollingDirection"
    let kDCCollectionViewKeyPath = "collectionView"
   
    var scrollingSpeed : CGFloat = 0.0
    var scrollingTriggerEdgeInsets : UIEdgeInsets?
    var longPressGestureRecognizer : UILongPressGestureRecognizer?
    var panGestureRecognizer : UIPanGestureRecognizer?
    
    func DCV_CGPointAdd(point1:CGPoint?, point2:CGPoint?) -> CGPoint{
        
        return CGPointMake(point1!.x + point2!.x , point1!.y + point2!.y)
    }
    
    func setDefaults(){
        self.scrollingSpeed = 300
        self.scrollingTriggerEdgeInsets = UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0)
        self.addObserver(self, forKeyPath: kDCCollectionViewKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func setupCollectionView(){
        
        // add long press
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector(handleLongPressGesture(longPressGestureRecognizer)))
        longPressGestureRecognizer?.delegate = self
        
//        for (index, gestureRecognizer) in enumerate(self.collectionView?.gestureRecognizers){
//            
//        }
        let registeredGestures : NSArray? = self.collectionView?.gestureRecognizers
        for gestureRecognizer in registeredGestures!{
            if (gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer)){
                gestureRecognizer.requireGestureRecognizerToFail(longPressGestureRecognizer!)
            }
        }
        
        self.collectionView?.addGestureRecognizer(longPressGestureRecognizer!)
        
        // add pan
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector(handleLongPressGesture(longPressGestureRecognizer)))
        panGestureRecognizer?.delegate = self
        self.collectionView?.addGestureRecognizer(panGestureRecognizer!)
        
        // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    //MARK:- init
    
    override init() {
        super.init()
        self.setDefaults()
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setDefaults()
    }
    
    //#MARK:-  gesture recognizer
    
    func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer?){
        
    }
    
    func handlePanGesture(){
        
    }
    
    //#MARK:- app resign active
    func handleApplicationWillResignActive( notification:NSNotification?){
        self.panGestureRecognizer?.enabled = false;
        self.panGestureRecognizer?.enabled = true;
    }
    
    //#MARK:- KVO
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
    }
    
    //MARK:- deinit
    
    deinit{
        self.removeObserver(self, forKeyPath: kDCCollectionViewKeyPath)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
}
