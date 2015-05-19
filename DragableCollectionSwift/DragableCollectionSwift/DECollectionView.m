//
//  DECollectionView.m
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import "DECollectionView.h"
#import "DragabbleCell.h"
#import "Option.h"

#import "OptionsLayout.h"

#define DRAG_SHADOW_HEIGHT 19
#define SCROLL_SPEED_MAX_MULTIPLIER 4.0
#define FRAMES_PER_SECOND 60.0

static inline CGPoint AddPoints(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

@implementation DECollectionView

-(void) setupCollectionView{
    [self registerClass:[DragabbleCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    // UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    OptionsLayout *flowLayout = [[OptionsLayout alloc] init];
    
    //[self setPagingEnabled:YES];
    [self setCollectionViewLayout:flowLayout animated:YES];
    self.dataSource = self;
    self.delegate = self;
    [self initGestures];
    //    self.draggedCell = [[DragabbleCell alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    //
    //    _autoscrollBounds = CGRectZero;
    //    _autoscrollBounds.size = self.frame.size;
    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(100, 100, 100, 100);
    _phantomCellIndex = NSNotFound;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupCollectionView];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - override reload data

-(void) reloadData{
    if (!self.optionsArr) {
        self.optionsArr = [self.dragEnableCollectionDatasource optionsArrayForCollectionView:self];
    }
    
    [super reloadData];
}

#pragma mark - collection view datasource/delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"count is %d",[self.optionsArr count]);
    return [self.optionsArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DragabbleCell *cell = (DragabbleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    Option *anOption = [self.optionsArr objectAtIndex:indexPath.row];
    
    // NSLog(@"%d -- %@ ", indexPath.row, anOption.optionTitle);
    [cell.optionImageView setImage:anOption.optionImage];
    [cell.optionLbl setText:anOption.optionTitle];
    if (self.isEditable) {
        
        [cell startQuivering];
    }
    
    //[cell updateCell];
    return cell;
}


#pragma mark - flowlayout delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 150);
}

#pragma mark - Drag reorder support

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    return YES;
}



-(void) initGestures{
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    longPressRecognizer.numberOfTapsRequired = 0;
    longPressRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    
    [self addGestureRecognizer:panRecognizer];
    [panRecognizer setDelegate:self];
    
    UIScreenEdgePanGestureRecognizer *bottomPan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePan:)];
    [bottomPan setEdges:UIRectEdgeBottom];
    [self addGestureRecognizer:bottomPan];
    //[self.panGestureRecognizer requireGestureRecognizerToFail:panRecognizer];
    //[self.panGestureRecognizer ];
    //    /[self.panGestureRecognizer];
}

-(void) handleEdgePan:(UIScreenEdgePanGestureRecognizer*) edgePanRecognizer{
    //NSLog(@"edge");
    
}

-(void) tapRecognized:(UITapGestureRecognizer*) tapRecognizer{
    [self setIsEditable:NO];
    [self reloadData];
}

-(void) longPressRecognized:(UILongPressGestureRecognizer*) longPressRecognizer{
    // NSLog(@"recognized");
    
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"started");
        [self setIsEditable:YES];
        [self reloadData];
    }
    //
    //    if (longPressRecognizer.state == UIGestureRecognizerStateEnded) {
    //        NSLog(@"ended");
    //    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        //return NO;
        //CGPoint translation = [gestureRecognizer translationInView:self];
        //[self setContentOffset:CGPointMake(translation.x , translation.y) animated:YES];
        
    }
    
    
    return YES;
}

- (CGPoint)pointConstrainedToDragBounds:(CGPoint)viewCenter
{
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        CGFloat left = CGRectGetMinX(_dragBounds);
        CGFloat right = CGRectGetMaxX(_dragBounds);
        if (viewCenter.x < left)
            viewCenter.x = left;
        else if (viewCenter.x > right)
            viewCenter.x = right;
    }
    
    return viewCenter;
}

-(void) beginDraggingItemAtIndexPath:(NSIndexPath*) indexPath{
    self.selectedOption = [self.optionsArr objectAtIndex:indexPath.row];
    _phantomCellIndex = indexPath.row;
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    CGRect dragFrame = cell.frame;
    _dragCellSize = dragFrame.size;
    UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:YES];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectInset(dragFrame, 0, -DRAG_SHADOW_HEIGHT)];
    shadowView.image = [[UIImage imageNamed:@"AAPLDragShadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(DRAG_SHADOW_HEIGHT, 1, DRAG_SHADOW_HEIGHT, 1)];
    shadowView.opaque = NO;
    
    dragFrame.origin = CGPointMake(0, DRAG_SHADOW_HEIGHT);
    snapshotView.frame = dragFrame;
    [shadowView addSubview:snapshotView];
    _currentView = shadowView;
    [_currentView  setClipsToBounds:YES];
    
    _currentView.center = cell.center;
    [self addSubview:_currentView];
    
    //[self ];
    
    [self performBatchUpdates:^{
        [self.optionsArr removeObjectAtIndex:self.selectedIndexPath.row];
        [self deleteItemsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f animations:^{
            //CGRect originalRect =self.draggedCell.frame;
            //[_currentView setFrame:<#(CGRect)#>];
            
            [_currentView setFrame:CGRectMake(_currentView.frame.origin.x, _currentView.frame.origin.y,
                                              _currentView.frame.size.width+10,
                                              _currentView.frame.size.height+10)];
            [_currentView setAlpha:0.9f];
            _currentView.layer.borderWidth = 3.0f;
            _currentView.layer.borderColor = [[UIColor yellowColor] CGColor];
            _currentView.layer.cornerRadius = 10.0f;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
    _currentViewCenter = _currentView.center;
    
    _autoscrollBounds = CGRectZero;
    _autoscrollBounds.size = self.frame.size;
    _autoscrollBounds = UIEdgeInsetsInsetRect(_autoscrollBounds, _scrollingTriggerEdgeInsets);
    
    CGRect collectionViewFrame = self.frame;
    CGFloat collectionViewWidth = CGRectGetWidth(collectionViewFrame);
    CGFloat collectionViewHeight = CGRectGetHeight(collectionViewFrame);
    
    _dragBounds = CGRectMake(_dragCellSize.width/2, _dragCellSize.height/2, collectionViewWidth - _dragCellSize.width, collectionViewHeight - _dragCellSize.height);
}


- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer{
    CGPoint contentOffset = self.contentOffset;
    if (![self isEditable]) {
        return;
    }
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        self.selectedIndexPath = [self indexPathForItemAtPoint:[panRecognizer locationInView:self]];
        if (!self.selectedIndexPath) {
            return;
        }
        [self beginDraggingItemAtIndexPath:self.selectedIndexPath];
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        self.panTranslationInCollectionView = [panRecognizer translationInView:self];
        CGPoint viewCenter = AddPoints(self.currentViewCenter, self.panTranslationInCollectionView);
        self.currentView.center = [self pointConstrainedToDragBounds:viewCenter];
        NSIndexPath *currentIndexPath = [self indexPathForItemAtPoint:[panRecognizer locationInView:self]];
        
//        if (currentIndexPath) {
//            [self makeWayForTheDraggedCellAtIndexPath:currentIndexPath];
//        }
        
        CGPoint location = [panRecognizer locationInView:self];
        CGFloat y = location.y - contentOffset.y;
        CGFloat top = CGRectGetMinY(_autoscrollBounds);
        CGFloat bottom = CGRectGetMaxY(_autoscrollBounds);
        
        //NSLog(@"contsntsize is %f",self.contentSize.height);
        if (y < top) {
           // NSLog(@"scroll up");
            _autoScrollDirection = DEAutoScrollDirectionUp;
            self.scrollingSpeed = 300 * ((top - y) / _scrollingTriggerEdgeInsets.top) * SCROLL_SPEED_MAX_MULTIPLIER;
            [self setupScrollTimerInDirection:DEAutoScrollDirectionUp];
            
        }else if (y>bottom){
           // NSLog(@"scroll down");
            self.scrollingSpeed = 300 * ((y - bottom) / _scrollingTriggerEdgeInsets.bottom) * SCROLL_SPEED_MAX_MULTIPLIER;
            _autoScrollDirection = DEAutoScrollDirectionDown;
            [self setupScrollTimerInDirection:DEAutoScrollDirectionDown];
        }else{
            [self invalidateScrollTimer];
        }
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        [self invalidateScrollTimer];
        NSIndexPath *finalIndexPath = [self indexPathForItemAtPoint:[panRecognizer locationInView:self]];
        if (finalIndexPath) {
            [self.currentView removeFromSuperview];
            [self insertDraggedCellAtIndex:finalIndexPath];
            //[self interchangeThePositionOfItemAt:self.selectedIndexPath withItemAt:finalIndexPath];
        }else{
            
            NSLog(@"move to previous location");
            [self.currentView removeFromSuperview];
            [self insertDraggedCellAtIndex:self.selectedIndexPath];
        }
    }
}





- (void)invalidateScrollTimer
{
    if (!_displayLink.paused)
        [_displayLink invalidate];
    _displayLink = nil;
}

- (void)setupScrollTimerInDirection:(DEAutoScrollDirection)direction {
    if (_displayLink && !_displayLink.paused) {
        if (_autoScrollDirection == direction)
            return;
    }
    
    [self invalidateScrollTimer];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
    _autoScrollDirection = direction;
    
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}




-(void) handleScroll:(CADisplayLink*)displayLink {
    
    //    CGFloat diff = point.y-500.0f;
    //    diff +=250.0f;
    //    [self setContentOffset:CGPointMake(self.contentOffset.x, diff) animated:YES];
    //    DEAutoScrollDirectionDown direction = _autoScrollDirection;
    //    if (direction == DEAutoScrollDirectionUnknown)
    //        return;
    
    DEAutoScrollDirection direction = _autoScrollDirection;
    if (direction == DEAutoScrollDirectionUnknown)
        return;
    
    
    UICollectionView *collectionView = self;
    CGSize frameSize = collectionView.bounds.size;
    CGSize contentSize = collectionView.contentSize;
    CGPoint contentOffset = collectionView.contentOffset;
    
    
    // Need to keep the distance as an integer, because the contentOffset property is automatically rounded. This would cause the view center to begin to diverge from the scrolling and appear to slip away from under the user's finger.
    CGFloat distance = rint(self.scrollingSpeed / FRAMES_PER_SECOND);
    CGPoint translation = CGPointZero;
    
    switch (direction) {
            //NSLog(@"")
        case DEAutoScrollDirectionUp:{
            //NSLog(@"scrolling up ...");
            distance = -distance;
            CGFloat minY = 0.0f;
            
            if ((contentOffset.y + distance) <= minY) {
                distance = -contentOffset.y;
            }
            
            translation = CGPointMake(0.0f, distance);
           // NSLog(@"translation %@",NSStringFromCGPoint(translation));
            
            break;
        }
        case DEAutoScrollDirectionDown:{
            
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height;
           // NSLog(@"scrolling speed = %f, distance =%f, cont size = %f, fram size =%f, maxY = %f",self.scrollingSpeed,  distance, contentSize.height, frameSize.height, maxY);
            
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            
            translation = CGPointMake(0.0f, distance);
            //NSLog(@"translation %@",NSStringFromCGPoint(translation));
            
            
            break;
        }
            
        default:
            break;
    }
    
    _currentViewCenter = AddPoints(_currentViewCenter, translation);
    _currentView.center = [self pointConstrainedToDragBounds:AddPoints(_currentViewCenter, _panTranslationInCollectionView)];
   // NSLog(@"%@ + %@ = %@",NSStringFromCGPoint(contentOffset), NSStringFromCGPoint(translation), NSStringFromCGPoint(AddPoints(contentOffset, translation)));
    self.contentOffset = AddPoints(contentOffset, translation);
    //[self setContentOffset:AddPoints(contentOffset, translation) animated:YES];
}

-(void) makeWayForTheDraggedCellAtIndexPath:(NSIndexPath*) indexPath{
    NSLog(@"phantom cell at %@",indexPath);
    if (_phantomCellIndex == indexPath.row) {
        NSLog(@"returning");
        return;
    }
    __block NSMutableArray *deletedItems = [NSMutableArray new];
    [self.optionsArr enumerateObjectsUsingBlock:^(Option *obj, NSUInteger idx, BOOL *stop) {
        if (obj.isPhantom) {
            NSLog(@"deleting/crashing here");
            [self.optionsArr removeObjectAtIndex:idx];
            [deletedItems addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            
            [self deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:0]]];
            
        }
    }];
    Option *phantomOption = [[Option alloc] init];
    [phantomOption setIsPhantom:YES];
    [self.optionsArr insertObject:phantomOption atIndex:indexPath.row];
    
    [self performBatchUpdates:^{
        NSLog(@"crashing here");
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray new];
        for (int i = indexPath.row+1; i<[self.optionsArr count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [arrayWithIndexPaths addObject:indexPath];
        }
        //[self reloadItemsAtIndexPaths:arrayWithIndexPaths];
        //[self deleteItemsAtIndexPaths:deletedItems];
        [self insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
        //[self reloadItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:^(BOOL finished) {
        
        //self.isEditable = NO;
        [self reloadData];
        
    }];
    
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.isEditable) {
        return NO;
    }
    return YES;
}
//-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return YES;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGPoint point = [scrollView.panGestureRecognizer locationInView:scrollView];
//
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
//}

-(void) insertDraggedCellAtIndex:(NSIndexPath*) targetIndexPath{
    __block NSMutableArray *deletedItems = [NSMutableArray new];
    [self.optionsArr enumerateObjectsUsingBlock:^(Option *obj, NSUInteger idx, BOOL *stop) {
        if (obj.isPhantom) {
            NSLog(@"deleting/crashing here");
            [self.optionsArr removeObjectAtIndex:idx];
            [deletedItems addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            
            [self deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:0]]];
            
        }
    }];

    [self performBatchUpdates:^{
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray new];
        for (int i = 0; i<[self.optionsArr count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [arrayWithIndexPaths addObject:indexPath];
        }
        [self reloadItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:^(BOOL finished) {
        
        self.isEditable = NO;
        [self reloadData];
        //[self scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }];
    [self.optionsArr insertObject:self.selectedOption atIndex:targetIndexPath.row];
    
}





@end
