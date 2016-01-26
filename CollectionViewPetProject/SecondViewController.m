//
//  SecondViewController.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "SecondViewController.h"

#import "TabsCollectionViewDataSource.h"

@interface SecondViewController ()

@property (strong, nonatomic) TabsCollectionViewDataSource *dataSource;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[TabsCollectionViewDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;
}

@end
