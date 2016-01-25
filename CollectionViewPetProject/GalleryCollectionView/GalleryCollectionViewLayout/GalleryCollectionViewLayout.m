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

@interface GalleryCollectionViewLayout ()

@property (nonatomic) CGFloat itemsHeight;
@property (nonatomic) CGFloat itemsWidth;
@property (nonatomic) NSInteger itemsCount;

@end

@implementation GalleryCollectionViewLayout

#pragma mark - Layout

- (void)prepareLayout {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
        self.itemsWidth = self.collectionView.bounds.size.width / 2.5;
        self.itemsHeight = self.itemsWidth * 1.5;
        if (self.itemsHeight > self.collectionView.bounds.size.height - kGalleryCellOffset * 2) {
            self.itemsHeight = self.collectionView.bounds.size.height - kGalleryCellOffset * 2;
            self.itemsWidth = self.itemsHeight / 1.5;
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
    UICollectionViewLayoutAttributes *lowerAttributes =
        [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [layoutAttributes addObject:lowerAttributes];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = CGRectMake(kGalleryCellOffset, kGalleryCellOffset, self.itemsWidth, self.itemsHeight);
    CATransform3D t = CATransform3DIdentity;
    //Add the perspective!!!
    t.m34 = 1.0/ -500;
    t = CATransform3DRotate(t, 45.0f * M_PI / 180.0f, 0, 1, 0);
    attributes.transform3D = t;
    return attributes;
}


@end
