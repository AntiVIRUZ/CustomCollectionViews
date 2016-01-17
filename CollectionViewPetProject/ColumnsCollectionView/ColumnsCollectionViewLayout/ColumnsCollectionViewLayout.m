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

const CGFloat kMaxCellWidth = 220.0;
const CGFloat kMinCellOffset = 8.0;

@interface ColumnsCollectionViewLayout ()

@property (nonatomic) CGFloat colWidth;
@property (nonatomic) CGFloat colXOffset;
@property (nonatomic) NSInteger colCount;

@end

@implementation ColumnsCollectionViewLayout

#pragma mark - Layout

- (void)prepareLayout {
    //All calculations becomes from 'width = count * colWodth + (count + 1) * colOffset'
    CGFloat width = self.collectionView.bounds.size.width;
    self.colCount = (NSInteger)(width - kMinCellOffset) / (kMaxCellWidth + kMinCellOffset);
    self.colWidth = (width - (self.colCount + 1) * kMinCellOffset) / self.colCount;
    if (self.colWidth - 1E-9 > kMaxCellWidth) {
        self.colWidth = kMaxCellWidth;
        self.colXOffset = (width - self.colCount * self.colWidth) / (self.colCount + 1);
    } else {
        self.colXOffset = kMinCellOffset;
    }
    ColumnsCollectionViewDataSource *dataSource = self.collectionView.dataSource;
    [dataSource configureItemsWithColumnsCount:self.colCount columnWidth:self.colWidth];
}

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
    ColumnsCollectionViewDataSource *dataSource = self.collectionView.dataSource;
    
    return nil;
}

- (CGFloat)calculateContentHeight {
    return 100;
}

@end
