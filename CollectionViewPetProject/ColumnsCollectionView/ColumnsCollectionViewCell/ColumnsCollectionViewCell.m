//
//  ColumnsCollectionViewItem.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewCell.h"

@interface ColumnsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ColumnsCollectionViewCell

- (void)setImage:(UIImage *)image andText:(NSString *)text {
    self.image.image = image;
    [self configureImageView];
    self.label.text = text;
    [self layoutIfNeeded];
}

- (void)configureImageView {
    CGFloat scale = self.image.image.size.width / self.bounds.size.width;
    CGFloat height = self.image.image.size.height / scale;
    NSString *format = [NSString stringWithFormat:@"V:[view(==%f)]", height];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:format
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:@{@"view" : self.image}]];
}

@end
