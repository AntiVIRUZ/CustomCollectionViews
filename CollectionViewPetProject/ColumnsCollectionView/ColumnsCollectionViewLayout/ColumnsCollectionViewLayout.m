//
//  ColumnsCollectionViewLayout.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewLayout.h"
#import "ColumnsCollectionViewDataSource.h"
#import "ColumnsCollectionViewCell.h"
#import "ColumnsCollectionViewItem.h"

@interface ColumnsCollectionViewLayout ()

@property (nonatomic) CGFloat colWidth;
@property (nonatomic) CGFloat colXOffset;

@end

@implementation ColumnsCollectionViewLayout

#pragma mark - Layout

- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    // Calculate a maximum of column's heights
    CGFloat contentHeight = [self calculateContentHeight];
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // Cells
    // We call a custom helper method -indexPathsOfElementsInRect: here
    // which computes the index paths of the cells that should be included
    // in rect.
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColumnsCollectionViewDataSource *dataSource = self.collectionView.dataSource;
    ColumnsCollectionViewItem *item = [dataSource itemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x = (indexPath.section + 1) * self.colXOffset + indexPath.section * self.colWidth;
    attributes.frame = CGRectMake(x, item.y, self.colWidth, item.height);
    return attributes;
}

#pragma mark - private

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect {
    return nil;
}

- (CGFloat)calculateContentHeight {
    return 100;
}

@end
