//
//  CollumnCollectionViewItem.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 16.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewItem.h"

@interface ColumnsCollectionViewItem ()

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;

@end

@implementation ColumnsCollectionViewItem

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
    }
    return self;
}

@end
