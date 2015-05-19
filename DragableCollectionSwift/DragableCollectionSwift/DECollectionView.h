//
//  DECollectionView.h
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECollectionViewDatasource.h"
#import "DECollectionViewDelegate.h"
#import "LXReorderableCollectionViewFlowLayout.h"


#import "DragabbleCell.h"
#import "Option.h"

typedef NS_ENUM(NSInteger, DEAutoScrollDirection) {
    DEAutoScrollDirectionUnknown = 0,
    DEAutoScrollDirectionUp,
    DEAutoScrollDirectionDown,
    DEAutoScrollDirectionLeft,
    DEAutoScrollDirectionRight
};

@interface DECollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *optionsArr;
@property (nonatomic, assign) BOOL isEditable;

@property (nonatomic, assign) id<DECollectionViewDatasource> dragEnableCollectionDatasource;
@property (nonatomic, assign) id<DECollectionViewDelegate> dragEnableCollectionDelegate;

@property (nonatomic) CGPoint initialPos;
@property (nonatomic, strong) DragabbleCell *draggedCell;
//@property (nonatomic, assign) BOOL programaticScrollEnabled;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) Option *selectedOption;

@property (nonatomic , strong) NSTimer *scrollTimer;
@property (nonatomic, readonly) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGFloat scrollingSpeed;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (nonatomic) DEAutoScrollDirection autoScrollDirection;

@property (nonatomic) CGRect autoscrollBounds;

@property (nonatomic) CGRect dragBounds;
@property (nonatomic) CGSize dragCellSize;

@property (strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;

@property (assign, nonatomic) CGPoint panTranslationInCollectionView;

@property (nonatomic) UIEdgeInsets scrollingTriggerEdgeInsets;

@property (nonatomic) CGPoint toPoint;

@property (nonatomic) NSUInteger phantomCellIndex;

@end
