//
//  ColumnsCollectionViewDataSource.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewDataSource.h"

#import "CollectionViewItem.h"
#import "CollectionViewCell.h"

const NSInteger kColumnCellOffset = 8;
const NSInteger kItemsCount = 20;

@interface ColumnsCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *indexPathsItems;
@property (nonatomic) NSInteger sectionCount;
@property (nonatomic) CGFloat totalHeight;

@end

@implementation ColumnsCollectionViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionCount = 1;
        [self itemsInit];
    }
    return self;
}

#pragma mark - Collection View Data Sourse

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self.indexPathsItems objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CollectionViewCell alloc] init];
    }
    CollectionViewItem *item = [self itemAtIndexPath:indexPath];
    if (item) {
        cell.item = item;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionCount;
}

#pragma  mark - Public

- (void)configureItemsWithColumnsCount:(NSInteger)count columnWidth:(CGFloat)width {
    if (width == 1) {
        self.sectionCount = 1;
        [self configureItemsForSingleColumnWithWidth:width];
        return;
    }
    if (width < 1) {
        return;
    }
    self.sectionCount = count;
    NSMutableArray *offsets = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *heights = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *counts = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *indexPathsItems = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [offsets addObject:[NSNumber numberWithFloat:kColumnCellOffset]];
        [heights addObject:[NSNumber numberWithFloat:0.0]];
        [counts addObject:[NSNumber numberWithInteger:0]];
        [indexPathsItems addObject:[NSMutableArray array]];
    }
    NSInteger min = 0;
    for (CollectionViewItem *item in self.items) {
        [item configureWithWidth:width];
        
        item.y = [[offsets objectAtIndex:min] integerValue];
        CGFloat newOffset = [[offsets objectAtIndex:min] floatValue];
        newOffset += item.height + kColumnCellOffset;
        [offsets setObject:[NSNumber numberWithFloat:newOffset] atIndexedSubscript:min];
        
        NSInteger count = [[counts objectAtIndex:min]integerValue];
        item.indexPath = [NSIndexPath indexPathForItem:count inSection:min];
        [counts setObject:[NSNumber numberWithInteger:count + 1] atIndexedSubscript:min];
        
        [[indexPathsItems objectAtIndex:min] addObject:item];
        
        NSInteger newHeight = [[heights objectAtIndex:min] floatValue] + item.height + kColumnCellOffset;
        [heights setObject:[NSNumber numberWithFloat:newHeight] atIndexedSubscript:min];
        min = [self findMin:heights];
        
        if (self.totalHeight < item.y + item.height + kColumnCellOffset) {
            self.totalHeight = item.y + item.height + kColumnCellOffset;
        }
    }
    self.indexPathsItems = [NSArray arrayWithArray:indexPathsItems];
}

- (CollectionViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sectionCount) {
        return [[self.indexPathsItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    }
    return nil;
}

#pragma mark - Private

- (NSInteger)findMin:(NSArray *)array {
    NSInteger min = 0;
    CGFloat minIndex = [[array objectAtIndex:0] floatValue];
    for (int i = 1; i < array.count; i++) {
        if ([[array objectAtIndex:i] floatValue] < minIndex) {
            minIndex = [[array objectAtIndex:i] floatValue];
            min = i;
        }
    }
    return min;
}

- (void)configureItemsForSingleColumnWithWidth:(CGFloat)width {
    int i = 0;
    CGFloat generalHeight = kColumnCellOffset;
    for (CollectionViewItem *item in self.items) {
        item.y = generalHeight;
        [item configureWithWidth:width];
        generalHeight += item.height + kColumnCellOffset;
        item.indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        i++;
    }
}

- (void)itemsInit {
    NSArray *rawTextArray =
    @[
      @"Тест",
      @"Тестовая надпись, которая чуть больше",
      @"Чуть большая надпись, мало ли, надо проверить",
      @"Воошще огромное описание, на много строк, а то мало ли как поведет себя все это"
      ];
    UIImage *first = [UIImage imageNamed:@"wide"];
    UIImage *second = [UIImage imageNamed:@"tall"];
    UIImage *third = [UIImage imageNamed:@"square"];
    
    NSArray *rawImageArray = @[first, second, third];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < kItemsCount; i++) {
        NSUInteger rs = arc4random_uniform((u_int32_t)[rawTextArray count]);
        NSString *s = [rawTextArray objectAtIndex:rs];
        NSUInteger ri = arc4random_uniform((u_int32_t)[rawImageArray count]);
        UIImage *i = [rawImageArray objectAtIndex:ri];
        CollectionViewItem *item = [[CollectionViewItem alloc] initWithText:s image:i];
        [items addObject:item];
    }
    self.items = [NSArray arrayWithArray:items];
}

@end
