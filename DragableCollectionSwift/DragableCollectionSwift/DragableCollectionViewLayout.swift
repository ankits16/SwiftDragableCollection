//
//  DragableCollectionViewLayout.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/21/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

class DragableCollectionViewLayout: UICollectionViewFlowLayout {
   
    var scrollingSpeed : CGFloat = 0.0
    var scrollingTriggerEdgeInsets : UIEdgeInsets?
    var longPressGestureRecognizer : UILongPressGestureRecognizer?
    var panGestureRecognizer : UIPanGestureRecognizer?
}
