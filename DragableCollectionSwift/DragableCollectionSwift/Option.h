//
//  Option.h
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

@property (nonatomic, strong) UIImage *optionImage;
@property (nonatomic, strong) NSString *optionTitle;
@property (nonatomic) BOOL isPhantom;
@end
