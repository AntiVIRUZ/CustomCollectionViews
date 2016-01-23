//
//  TabsCollectionViewLayout.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 23.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "TabsCollectionViewLayout.h"

const NSInteger kTabCellOffset = 8;

@interface TabsCollectionViewLayout ()

@property (nonatomic) CGFloat itemsHeight;
@property (nonatomic) CGFloat itemsWidth;

@end

@implementation TabsCollectionViewLayout

#pragma mark - Layout

- (void)prepareLayout {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.itemsHeight = self.collectionView.bounds.size.height - kTabCellOffset * 2;
        self.itemsWidth = self.collectionView.bounds.size.width - kTabCellOffset * 2;
    });
}

- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    // Make +200 becouse we need space to scroll on the top and bottom of scroll view
    CGFloat contentHeight = (self.itemsHeight + kTabCellOffset) * [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0] + kTabCellOffset;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    NSInteger lowerItem = (NSInteger)(self.collectionView.contentOffset.y / (self.itemsHeight + kTabCellOffset));
    NSInteger higherItem = lowerItem + 1;
    
    UICollectionViewLayoutAttributes *lowerAttributes =
        [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lowerItem inSection:0]];
    [layoutAttributes addObject:lowerAttributes];
    if (higherItem < [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0]) {
        UICollectionViewLayoutAttributes *higherAttributes =
            [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:higherItem inSection:0]];;
        [layoutAttributes addObject:higherAttributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger lowerItem = (NSInteger)(self.collectionView.contentOffset.y / (self.itemsHeight + kTabCellOffset));
    CGFloat y;
    if (indexPath.row == lowerItem ) {
        y = self.collectionView.contentOffset.y + kTabCellOffset;
    } else {
        y = 2 * self.collectionView.contentOffset.y + fabs(self.collectionView.contentOffset.y / self.itemsHeight) * self.itemsHeight + kTabCellOffset;
    }
    attributes.frame = CGRectMake(kTabCellOffset, y, self.itemsWidth, self.itemsHeight);
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
