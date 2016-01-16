//
//  CollumnCollectionViewItem.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 16.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "CollumnCollectionViewItem.h"

@interface CollumnCollectionViewItem ()

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;

@end

@implementation CollumnCollectionViewItem

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
    }
    return self;
}

@end
