//
//  DragabbleCell.h
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragabbleCell : UICollectionViewCell<NSCopying>

@property (nonatomic) int index;
@property (nonatomic, weak) IBOutlet UIImageView *optionImageView;
@property (nonatomic, weak) IBOutlet UILabel *optionLbl;


-(void) initGestures;
-(void)startQuivering;

@end
