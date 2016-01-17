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

const CGFloat kMinCellWidth = 160.0;
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
    if ((width - self.colCount * kMinCellOffset) / (self.colCount - 1) > kMinCellWidth) {
        self.colCount++;
    }
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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - private

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect {
    ColumnsCollectionViewDataSource *dataSource = self.collectionView.dataSource;
    NSInteger startSection = (NSInteger)(rect.origin.x / (self.colWidth + self.colXOffset));
    NSInteger endSection = MIN((NSInteger)ceil((rect.origin.x + rect.size.width - self.colXOffset) / (self.colWidth + self.colXOffset)), self.colCount - 1);
    NSMutableArray *indexes = [NSMutableArray array];
    for (NSInteger i = startSection; i <= endSection; i++) {
        NSInteger itemsCount = [dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < itemsCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            ColumnsCollectionViewItem *item = [dataSource itemAtIndexPath:indexPath];
            if (item.y < rect.origin.y + rect.size.height) {
                [indexes addObject:indexPath];
            } else {
                break;
            }
        }
    }
    return [NSArray arrayWithArray:indexes];
}

- (CGFloat)calculateContentHeight {
    ColumnsCollectionViewDataSource *dataSource = self.collectionView.dataSource;
    return [dataSource totalHeight];
}

@end
