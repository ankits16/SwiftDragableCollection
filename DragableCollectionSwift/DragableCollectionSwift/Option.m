//
//  Option.m
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import "Option.h"

@implementation Option

-(id) initWithTitle:(NSString*) title anImage:(UIImage*) optionImage{
    self = [super init];
    if (self) {
        self.optionTitle = title;
        self.optionImage = optionImage;
        self.isPhantom = NO;
    }
    
    return self;
}
@end
