//
//  ColumnsCollectionViewDataSource.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "ColumnsCollectionViewDataSource.h"

#import "CollumnCollectionViewItem.h"

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

- (void)configureItemsWithColumnsCount:(NSInteger)count width:(NSInteger)width {
    
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
