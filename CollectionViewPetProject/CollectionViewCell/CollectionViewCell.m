//
//  ColumnsCollectionViewItem.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CollectionViewItem.h"

@interface CollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSArray *imageWidthConstraints;

@end

@implementation CollectionViewCell

- (void)setItem:(CollectionViewItem *)item {
    _item = item;
    self.image.image = item.image;
    self.label.text = item.text;
    NSString *format = [NSString stringWithFormat:@"V:[view(==%d@1000)]", (int)self.item.imageHeight];
    if (self.imageWidthConstraints.count) {
        [self removeConstraints:self.imageWidthConstraints];
    }
    self.imageWidthConstraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:NSLayoutFormatDirectionLeadingToTrailing
                            metrics:nil
                            views:@{@"view" : self.image}];
    [self addConstraints:self.imageWidthConstraints];
    [self layoutIfNeeded];
}

@end
