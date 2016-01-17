//
//  ColumnsCollectionViewDataSource.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewDataSource.h"

#import "CollumnCollectionViewItem.h"

const NSInteger kColumnCellOffset = 8;

@interface ColumnsCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation ColumnsCollectionViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        [self itemsInit];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)configureItemsWithColumnsCount:(NSInteger)count columnWidth:(CGFloat)width {
    if (width == 1) {
        [self configureItemsForSingleColumnWithWidth:width];
        return;
    }
    if (width < 1) {
        return;
    }
    NSMutableArray *heights = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *counts = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [heights addObject:[NSNumber numberWithFloat:0.0]];
        [counts addObject:[NSNumber numberWithInteger:0]];
    }
    NSInteger min = 0;
    for (CollumnCollectionViewItem *item in self.items) {
        item.height = [self heightWithWidth:width image:item.image text:item.text];
        NSInteger count = [[counts objectAtIndex:min]integerValue];
        item.indexPath = [NSIndexPath indexPathForItem:count inSection:min];
        [counts setObject:[NSNumber numberWithInteger:count + 1] atIndexedSubscript:min];
        NSInteger newHeight = [[heights objectAtIndex:min] floatValue] + item.height + kColumnCellOffset;
        [heights setObject:[NSNumber numberWithFloat:newHeight] atIndexedSubscript:min];
        min = [self findMin:heights];
    }
}

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
    for (CollumnCollectionViewItem *item in self.items) {
        item.height = [self heightWithWidth:width image:item.image text:item.text];
        item.indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        i++;
    }
}

- (CGFloat)heightWithWidth:(CGFloat)width image:(UIImage *)image text:(NSString *)text {
    NSInteger contentWidth = width - kColumnCellOffset * 4;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:9.0] };
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
    
    NSArray *rawImageArray =
    @[
      [UIImage imageWithContentsOfFile:@"wide"],
      [UIImage imageWithContentsOfFile:@"tall"],
      [UIImage imageWithContentsOfFile:@"square"]
      ];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < 50; i++) {
        NSUInteger rs = arc4random_uniform((u_int32_t)[rawTextArray count]);
        NSString *s = [rawTextArray objectAtIndex:rs];
        NSUInteger ri = arc4random_uniform((u_int32_t)[rawImageArray count]);
        UIImage *i = [rawTextArray objectAtIndex:ri];
        CollumnCollectionViewItem *item = [[CollumnCollectionViewItem alloc] initWithText:s image:i];
        [items addObject:item];
    }
}

@end
