//
//  ColumnsCollectionViewDataSource.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewDataSource.h"

#import "ColumnsCollectionViewItem.h"
#import "ColumnsCollectionViewCell.h"

const NSInteger kColumnCellOffset = 8;
const NSInteger kItemsCount = 50;

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
    ColumnsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ColumnsCollectionViewCell alloc] init];
    }
    ColumnsCollectionViewItem *item = [self itemAtIndexPath:indexPath];
    if (item) {
        [cell setImage:item.image andText:item.text];
    } else {
        [cell setImage:nil andText:@"Ошибка! Не найден item"];
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
    for (ColumnsCollectionViewItem *item in self.items) {
        item.height = [self heightWithWidth:width image:item.image text:item.text];
        
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
    }
    CGFloat maxHeight = 0;
    for (int i = 0; i < count; i++) {
        maxHeight = MAX(maxHeight, [[offsets objectAtIndex:i] integerValue] + [[heights objectAtIndex:i] integerValue]);
    }
    self.totalHeight = maxHeight + kColumnCellOffset;
    self.indexPathsItems = [NSArray arrayWithArray:indexPathsItems];
}

- (ColumnsCollectionViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
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
    for (ColumnsCollectionViewItem *item in self.items) {
        item.y = generalHeight;
        item.height = [self heightWithWidth:width image:item.image text:item.text];
        generalHeight += item.height + kColumnCellOffset;
        item.indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        i++;
    }
}

- (CGFloat)heightWithWidth:(CGFloat)width image:(UIImage *)image text:(NSString *)text {
    NSInteger contentWidth = width - kColumnCellOffset * 4;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0] };
    CGRect textSize = [text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGFloat scaleFactor = contentWidth / image.size.width;
    CGFloat imageHeight = image.size.height * scaleFactor;
    return textSize.size.height + imageHeight + kColumnCellOffset * 3;
}

- (void)itemsInit {
    NSArray *rawTextArray =
    @[
      @"Один молодой человек отправился со своей невестой на медовый месяц в Париж",
      @"Она села рядом с женихом и пугающе серьезно спросила его, бросил ли он её, не будь она так красива. Молодой человек засмеялся, решив, что невеста просто показывает, как она хороша.",
      @"Но та схватила тряпочку и вытерла свое лицо, стирая макияж, под которым оказалось множество безобразных пурпурных родинок. Разумеется, молодой человек не бросил бы её, но он имел неосторожность издать вздох, увидев эти родинки.Невеста заплакала и убежала, не вернувшись к тому времени, когда медовый месяц должен был закончиться",
      @"У нее не было ни денег, ни паспорта, и испуганный молодой человек пошел в полицию. Там решили, что невеста просто передумала с браком, однако, она не умела говорить по-французски и у нее не было никаких документов, так что поиски начались. Но ничего не дали. Шли недели, месяцы, а молодой человек все никак не мог найти свою невесту. Его жизнь рухнула, ибо он был убит горем.Тогда он отправился бродить по миру, надеясь найти что-либо, способное смягчить его боль"
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
        ColumnsCollectionViewItem *item = [[ColumnsCollectionViewItem alloc] initWithText:s image:i];
        [items addObject:item];
    }
    self.items = [NSArray arrayWithArray:items];
}

@end
