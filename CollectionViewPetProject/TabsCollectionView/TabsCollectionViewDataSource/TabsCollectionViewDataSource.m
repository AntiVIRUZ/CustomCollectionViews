//
//  TabsCollectionViewDataSource.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 23.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "TabsCollectionViewDataSource.h"

#import "CollectionViewItem.h"
#import "CollectionViewCell.h"

const NSInteger kTabItemsCount = 10;

@interface TabsCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation TabsCollectionViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray<CollectionViewItem *> *arr = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            NSString *text = [NSString stringWithFormat:@"i = %d", i];
            CollectionViewItem *item = [[CollectionViewItem alloc] initWithText:text image:nil];
            [arr addObject:item];
        }
        _items = arr;//[CollectionViewItem generateItemsWithCount:kTabItemsCount];
    }
    return self;
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
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
