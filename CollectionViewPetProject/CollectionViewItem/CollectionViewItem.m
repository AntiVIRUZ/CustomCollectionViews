//
//  CollumnCollectionViewItem.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 16.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "CollectionViewItem.h"

const NSInteger kOffset = 8;

@interface CollectionViewItem ()

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;

@end

@implementation CollectionViewItem

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
    }
    return self;
}

- (void)configureWithWidth:(CGFloat)width {
    NSInteger contentWidth = width - kOffset * 4;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0] };
    CGRect textSize = [self.text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGFloat scaleFactor = contentWidth / self.image.size.width;
    self.imageHeight = self.image.size.height * scaleFactor;
    self.height = textSize.size.height + self.imageHeight + kOffset * 3;
}

+ (NSArray *)generateItemsWithCount:(NSInteger)count {
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
    for (int i = 0; i < count; i++) {
        NSUInteger rs = arc4random_uniform((u_int32_t)[rawTextArray count]);
        NSString *s = [rawTextArray objectAtIndex:rs];
        NSUInteger ri = arc4random_uniform((u_int32_t)[rawImageArray count]);
        UIImage *i = [rawImageArray objectAtIndex:ri];
        CollectionViewItem *item = [[CollectionViewItem alloc] initWithText:s image:i];
        [items addObject:item];
    }
    return items;
}

@end
