//
//  ColumnsCollectionViewDataSource.h
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnsCollectionViewDataSource : NSObject <UICollectionViewDataSource>

- (void)configureItemsWithColumnsCount:(NSInteger)count width:(NSInteger)width;

@end
