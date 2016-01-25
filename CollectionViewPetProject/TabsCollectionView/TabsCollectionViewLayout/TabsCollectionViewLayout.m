//
//  TabsCollectionViewLayout.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 23.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "TabsCollectionViewLayout.h"

#import "TabsCollectionViewDataSource.h"

const NSInteger kTabCellOffset = 8;

@interface TabsCollectionViewLayout ()

@property (nonatomic) CGFloat itemsHeight;
@property (nonatomic) CGFloat itemsWidth;
@property (nonatomic) NSInteger itemsCount;

@end

@implementation TabsCollectionViewLayout

#pragma mark - Layout

- (void)prepareLayout {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
        self.itemsHeight = self.collectionView.bounds.size.height - kTabCellOffset * 2;
        self.itemsWidth = self.collectionView.bounds.size.width - kTabCellOffset * 2;
        [(TabsCollectionViewDataSource *)self.collectionView.dataSource configureWithWidth:self.itemsWidth];
        CGFloat startContentOffset = (self.itemsHeight + kTabCellOffset) * [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0] - kTabCellOffset - self.itemsHeight;
        self.collectionView.contentOffset = CGPointMake(0, startContentOffset);
    });
}

- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
 
    CGFloat contentHeight = (self.itemsHeight + kTabCellOffset) * [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    NSInteger lowerItem = [self lowerItem];
    NSInteger higherItem = lowerItem + 1;
    
    UICollectionViewLayoutAttributes *lowerAttributes =
        [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lowerItem inSection:0]];
    [layoutAttributes addObject:lowerAttributes];
    if (higherItem < self.itemsCount) {
        UICollectionViewLayoutAttributes *higherAttributes =
            [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:higherItem inSection:0]];
        [layoutAttributes addObject:higherAttributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger lowerItem = [self lowerItem];
    CGFloat y;
    if (indexPath.row == lowerItem ) {
        y = self.collectionViewContentSize.height - (lowerItem + 1) * (self.itemsHeight + kTabCellOffset) + kTabCellOffset;
        //Some magic. First item is plased lower, than it needs to.
        if (lowerItem == 0) {
            y -= kTabCellOffset;
        }
    } else {
        y = self.collectionView.contentOffset.y + kTabCellOffset;
    }
    attributes.frame = CGRectMake(kTabCellOffset, y, self.itemsWidth, self.itemsHeight);
    attributes.zIndex = self.itemsCount - indexPath.row;
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Private

- (NSInteger)lowerItem {
    return (NSInteger)((self.collectionViewContentSize.height - self.collectionView.contentOffset.y) / (self.itemsHeight + kTabCellOffset)) - 1;
}

@end
