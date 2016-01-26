//
//  GalleryCollectionViewDataSource.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 25.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "GalleryCollectionViewDataSource.h"

#import "CollectionViewItem.h"
#import "CollectionViewCell.h"

const NSInteger kGalleryItemsCount = 10;

@interface GalleryCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation GalleryCollectionViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [CollectionViewItem generateItemsWithCount:kGalleryItemsCount];
    }
    return self;
}

- (void)configureWithWidth:(CGFloat)width {
    for (CollectionViewItem *item in self.items) {
        [item configureWithWidth:width];
    }
}

#pragma mark - Collection View Data Sourse

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CollectionViewCell alloc] init];
    }
    CollectionViewItem *item = [self.items objectAtIndex:indexPath.row];
    if (item) {
        cell.item = item;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
