//
//  ColumnsCollectionViewItem.h
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColumnsCollectionViewItem;

@interface ColumnsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ColumnsCollectionViewItem *item;

- (void)setImage:(UIImage *)image andText:(NSString *)text;

@end
