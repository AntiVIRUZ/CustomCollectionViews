//
//  CollumnCollectionViewItem.h
//  CollectionViewPetProject
//
//  Created by Vasiliy on 16.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollumnCollectionViewItem : NSObject

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic) CGFloat height;

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image;

- (NSString *)text;
- (UIImage *)image;

@end
