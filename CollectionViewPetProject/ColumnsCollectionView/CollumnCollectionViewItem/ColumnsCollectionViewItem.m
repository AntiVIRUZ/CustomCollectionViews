//
//  CollumnCollectionViewItem.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 16.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewItem.h"

const NSInteger kOffset = 8;

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

- (void)configureWithWidth:(CGFloat)width {
    NSInteger contentWidth = width - kOffset * 4;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0] };
    CGRect textSize = [self.text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGFloat scaleFactor = contentWidth / self.image.size.width;
    self.imageHeight = self.image.size.height * scaleFactor;
    self.height = textSize.size.height + self.imageHeight + kOffset * 3;
}

@end
