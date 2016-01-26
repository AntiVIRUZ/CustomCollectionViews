//
//  GalleryCollectionViewLayout.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 25.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "GalleryCollectionViewLayout.h"

#import "GalleryCollectionViewDataSource.h"

const NSInteger kGalleryCellOffset = 16;
const CGFloat kRadius = 300;
//Content offset x * kAngleCoef = angle in radians
const CGFloat kAngleCoef = 0.5 / kRadius;
//Delta between cells in radians
const CGFloat kCellAngleDelta = M_PI / 4;
//Distance between cell's centers
const CGFloat kCellSpacing = 2 * kRadius * kCellAngleDelta;

@interface GalleryCollectionViewLayout ()

@property (nonatomic) CGFloat itemsHeight;
@property (nonatomic) CGFloat itemsWidth;
@property (nonatomic) NSInteger itemsCount;
@property (nonatomic) CGFloat cellTopOffset;

@end

@implementation GalleryCollectionViewLayout

#pragma mark - Layout

- (void)prepareLayout {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
        self.itemsWidth = self.collectionView.bounds.size.width / 2.5;
        self.itemsHeight = self.itemsWidth * 1.5;
        self.cellTopOffset = (self.collectionView.bounds.size.height - self.itemsHeight) / 2;
        if (self.itemsHeight > self.collectionView.bounds.size.height - kGalleryCellOffset * 2) {
            self.itemsHeight = self.collectionView.bounds.size.height - kGalleryCellOffset * 2;
            self.itemsWidth = self.itemsHeight / 1.5;
            self.cellTopOffset = kGalleryCellOffset;
        }
        [(GalleryCollectionViewDataSource *)self.collectionView.dataSource configureWithWidth:self.itemsWidth];
    });
}

- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = self.itemsCount * (self.itemsWidth + kGalleryCellOffset);
    
    CGFloat contentHeight = self.collectionView.bounds.size.height;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    NSInteger actualIndex = (NSInteger)(self.collectionView.contentOffset.x / kCellSpacing);
    NSInteger start = MAX(0, actualIndex - 1);
    NSInteger end = MIN([self.collectionView numberOfItemsInSection:0], actualIndex + 2);
    for (NSInteger i = start; i <= end; i++) {
        UICollectionViewLayoutAttributes *attributes =
            [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [layoutAttributes addObject:attributes];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = CGRectMake(kGalleryCellOffset, kGalleryCellOffset, self.itemsWidth, self.itemsHeight);
    CATransform3D t = CATransform3DIdentity;
    //Add the perspective!
    t.m34 = 1.0 / (-kRadius);
    CGFloat zeroAngle = self.collectionView.contentOffset.x * kAngleCoef;
    CGFloat itemAngle = indexPath.row * kCellAngleDelta;
    CGFloat actualAngle = itemAngle - zeroAngle;
    CGFloat x = kRadius * sin(actualAngle) + self.collectionView.bounds.size.width / 2 + self.collectionView.contentOffset.x;
    CGFloat z = kRadius * cos(actualAngle);
    CATransform3DTranslate(t, 0, 0, z);
    t = CATransform3DRotate(t, -actualAngle, 0, 1, 0);
    attributes.transform3D = t;
    attributes.center = CGPointMake(x, self.cellTopOffset);
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end
