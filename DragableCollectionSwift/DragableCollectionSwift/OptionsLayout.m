//
//  OptionsLayout.m
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import "OptionsLayout.h"
#import <objc/runtime.h>

#define FRAMES_PER_SECOND 60.0

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
DES_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

#define  ITEM_WIDTH 150.0
#define ITEM_HEIGHT 150.0

typedef NS_ENUM(NSInteger, ScrollingDirecton) {
    ScrollingDirectionUnknown = 0,
    ScrollingDirectionUp,
    ScrollingDirectionDown,
    ScrollingDirectionLeft,
    ScrollingDirectionRight
};
static NSString * const kDEScrollingDirectionKey = @"crollingDirection";
static NSString * const kDECollectionViewKeyPath = @"collectionView";


#pragma mark - CADisplayLink

@interface CADisplayLink (DE_userInfo)

@property (nonatomic, copy) NSDictionary *DE_userInfo;

@end

@implementation CADisplayLink (DE_userInfo)

-(void) setDE_userInfo:(NSDictionary *)DE_userInfo{
    objc_setAssociatedObject(self, "DE_userInfo", DE_userInfo, OBJC_ASSOCIATION_COPY);
}

-(NSDictionary*) DE_userInfo{
    return objc_getAssociatedObject(self, "DE_userInfo");
}

@end

#pragma mark - catergory on collectionview cell

@interface UICollectionViewCell (OptionsLayout)
-(UIImage*) rasterizedImage;
@end

@implementation UICollectionViewCell(OptionsLayout)

-(UIImage*) rasterizedImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@interface OptionsLayout ()
@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic, readonly) id<DECollectionViewDatasource> dataSource;
@property (assign, nonatomic, readonly) id<DECollectionViewDelegate> delegate;
@end




@implementation OptionsLayout

//- (void)setDefaults {
//    _scrollingSpeed = 300.0f;
//    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
//}
//
//- (void)setupCollectionView {
//    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                action:@selector(handleLongPressGesture:)];
//    _longPressGestureRecognizer.delegate = self;
//
//    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
//        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
//            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
//        }
//    }
//    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
//    
//    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                    action:@selector(handlePanGesture:)];
//    _panGestureRecognizer.delegate = self;
//    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name: UIApplicationWillResignActiveNotification object:nil];
//}

-(id) init{
    if (self = [super init]) {
        self.itemSize = CGSizeMake(150, 150);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 20;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.sectionInset = UIEdgeInsetsMake(5, 5, 20, 5);
//        [self setDefaults];
//        [self addObserver:self forKeyPath:kDECollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self setDefaults];
//        [self addObserver:self forKeyPath:kDECollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
//    }
//    return self;
//}

#pragma mark - Target/Action methods

//-(void) handleScroll:(CADisplayLink*) displayLink{
//    ScrollingDirecton direction = (ScrollingDirecton)[displayLink.DE_userInfo[kDEScrollingDirectionKey] integerValue];
//    
//    if (direction == ScrollingDirectionUnknown) {
//        return;
//    }
//    CGSize frameSize = self.collectionView.bounds.size;
//    CGSize contentSize = self.collectionView.contentSize;
//    CGPoint contentOffset = self.collectionView.contentOffset;
//    UIEdgeInsets contentInset = self.collectionView.contentInset;
//    CGFloat distance = rint(self.scrollingSpeed / FRAMES_PER_SECOND);
//    CGPoint translation = CGPointZero;
//    
//    switch (direction) {
//        case ScrollingDirectionUp:{
//            distance = -distance;
//            CGFloat minY = 0.0f - contentInset.top;
//            
//            if ((contentOffset.y + distance) <= minY) {
//                distance = -contentOffset.y - contentInset.top;
//            }
//            
//            translation = CGPointMake(0.0f, distance);
//        }
//            break;
//            
//        case ScrollingDirectionDown:{
//            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;
//            
//            if ((contentOffset.y + distance) >= maxY) {
//                distance = maxY - contentOffset.y;
//        }
//            break;
//        default:
//            break;
//    }
//    
//}

//-(CGSize) collectionViewContentSize{
//    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
//    return CGSizeMake( ITEM_WIDTH, numberOfItems *ITEM_HEIGHT);
//}
//
//-(UICollectionViewLayoutAttributes*) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSUInteger index = [indexPath indexAtPosition:0];
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    attributes.frame = CGRectMake(0,index * ITEM_WIDTH, ITEM_WIDTH, ITEM_HEIGHT);
//    return attributes;
//    //return nil;
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *attributes = [NSMutableArray new];
//    NSUInteger firstIndex = floorf(CGRectGetMinX(rect) / ITEM_WIDTH);
//    NSUInteger lastIndex = ceilf(CGRectGetMaxX(rect) / ITEM_WIDTH);
//    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
//        NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:(NSUInteger [2]){ 0, index } length:2];
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
//    return attributes;
//}
//
////-(UICollectionViewLayoutAttributes*) initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
////    return nil;
////}
//
//-(UICollectionViewLayoutAttributes*) finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
//    
//    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    attributes.alpha = 0.0;
//    return attributes;
//}
@end
