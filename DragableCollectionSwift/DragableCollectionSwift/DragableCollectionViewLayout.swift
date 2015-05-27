//
//  DragableCollectionViewLayout.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/21/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

@ objc protocol DragableCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout{
    
    optional func willBeginDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
    optional func didBeginDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
    optional func willEndDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
    optional func didEndDraggingItem (collectionView: DragableCollectionView?, layout: UICollectionViewFlowLayout?, atIndexpath: NSIndexPath?)
}

let LX_FRAMES_PER_SECOND = 60.0

#if CGGEOMETRY_LXSUPPORT_H_
    CG_INLINE CGPoint LXS_CGPointAdd(CGPoint point1, CGPoint point2) = {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
    }
#endif

class DragableCollectionViewLayout: UICollectionViewFlowLayout {
   
    var scrollingSpeed : CGFloat = 0.0
    var scrollingTriggerEdgeInsets : UIEdgeInsets?
    var longPressGestureRecognizer : UILongPressGestureRecognizer?
    var panGestureRecognizer : UIPanGestureRecognizer?
}
