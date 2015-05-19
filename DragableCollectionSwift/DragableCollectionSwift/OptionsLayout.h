//
//  OptionsLayout.h
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECollectionViewDatasource.h"
#import "DECollectionViewDelegate.h"

@interface OptionsLayout : UICollectionViewFlowLayout<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat scrollingSpeed;
@property (nonatomic, assign) UIEdgeInsets scrollingTriggerEdgeInsets;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end
