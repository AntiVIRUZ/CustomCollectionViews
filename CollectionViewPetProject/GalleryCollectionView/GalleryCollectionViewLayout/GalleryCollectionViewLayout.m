//
//  GalleryCollectionViewLayout.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 25.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "GalleryCollectionViewLayout.h"

#import "GalleryCollectionViewDataSource.h"

/**
 *  Offset between cells and between screen's edge and cell
 */
const NSInteger kGalleryCellOffset = 16;
/**
 *  Number of cells in circle
 */
const NSInteger kGalleryCellsInCircle = 16;
/**
 *  Delta between cells in radians
 */
const CGFloat kCellAngleDelta = 2 * M_PI / kGalleryCellsInCircle;
/**
 *  How much cells from center should be shown
 */
const NSInteger kVisibleCellsCount = 2;

@interface GalleryCollectionViewLayout ()

@property (nonatomic) CGFloat itemsHeight;
@property (nonatomic) CGFloat itemsWidth;
@property (nonatomic) NSInteger itemsCount;
/**
 *  Real offset from top of screen
 */
@property (nonatomic) CGFloat cellTopOffset;
/**
 *  Radius of circle. Camera is placed in center of it
 */
@property (nonatomic) CGFloat radius;
/**
 *  Content offset x * angleCoef = angle in radians
 */
@property (nonatomic) CGFloat angleCoef;
/**
 *  Distance between cell's centers
 */
@property (nonatomic) CGFloat cellSpacing;

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
        
        self.radius = (self.itemsWidth + kGalleryCellOffset) * kGalleryCellsInCircle / (2 * M_PI);
        self.angleCoef = 4 / (self.radius * kGalleryCellsInCircle);
        self.cellSpacing = 2 * self.radius * kCellAngleDelta;
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
    NSInteger actualIndex = (NSInteger)(self.collectionView.contentOffset.x / self.cellSpacing);
    NSInteger start = MAX(0, actualIndex - kVisibleCellsCount);
    NSInteger end = MIN([self.collectionView numberOfItemsInSection:0], actualIndex + kVisibleCellsCount);
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
    //Add the perspective!
    CGFloat zeroAngle = self.collectionView.contentOffset.x * self.angleCoef;
    CGFloat itemAngle = indexPath.row * kCellAngleDelta;
    CGFloat actualAngle = itemAngle - zeroAngle;
    CGFloat x = self.radius * sin(actualAngle) + self.collectionView.bounds.size.width / 2 + self.collectionView.contentOffset.x;
    CGFloat z = self.radius * cos(actualAngle);
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / (-z);
    NSLog(@"Actual angle = %f", actualAngle);
    t = CATransform3DRotate(t, -actualAngle, 0, 1, 0);
    CGFloat scale = self.radius / z;
    t = CATransform3DScale(t, scale, scale, scale);
    attributes.transform3D = t;
    attributes.center = CGPointMake(x, self.cellTopOffset);
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end
