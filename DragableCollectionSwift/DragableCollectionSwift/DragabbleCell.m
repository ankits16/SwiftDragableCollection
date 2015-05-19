//
//  DragabbleCell.m
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import "DragabbleCell.h"

@implementation DragabbleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DragabbleCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
//   / [self initGestures];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DragabbleCell *newCell = [[[self class] allocWithZone:zone] init];
    newCell.optionImageView.image = [self optionImageView].image;
    newCell.optionLbl.text = [self optionLbl].text;
//    newCrime->_month = [_month copyWithZone:zone];
//    newCrime->_category = [_category copyWithZone:zone];
    // etc...
    return newCell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) initGestures{
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    longPressRecognizer.numberOfTapsRequired = 0;
    longPressRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressRecognizer];
}

-(void) longPressRecognized:(UILongPressGestureRecognizer*) longPressRecognizer{
    NSLog(@"recognized");
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"started");
        
    }
    
    if (longPressRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended");
    }
}

#pragma mark - animation
-(void)startQuivering{
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    float startAngle = (-2) * M_PI/180.0;
    float stopAngle = -startAngle;
    quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration = 0.2;
    quiverAnim.repeatCount = HUGE_VALF;
    float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset = timeOffset;
    CALayer *layer = self.layer;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    [layer addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering
{
    CALayer *layer = self.layer;
    
    [layer removeAnimationForKey:@"quivering"];
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    
//    NSLog(@"%@", NSStringFromCGPoint([touch locationInView:self]));
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    NSLog(@"%@", NSStringFromCGPoint([touches ]));
//}
//
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    UITouch *touch = [touches anyObject];
//    
//    NSLog(@"%@", NSStringFromCGPoint([touch locationInView:self]));
//}
@end
