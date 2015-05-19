//
//  DECollectionViewDatasource.h
//  DragableCollectionView
//
//  Created by Ankit on 09/06/14.
//  Copyright (c) 2014 Ankit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DECollectionView;
@protocol DECollectionViewDatasource <NSObject>

@required
-(NSMutableArray*) optionsArrayForCollectionView:(DECollectionView*) deCollectionView;;

@optional
- (void)collectionView:(DECollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(DECollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

@end
