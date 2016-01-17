//
//  FirstViewController.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 14.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "FirstViewController.h"

#import "ColumnsCollectionViewDataSource.h"

@interface FirstViewController ()

@property (nonatomic, strong) ColumnsCollectionViewDataSource *dataSource;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[ColumnsCollectionViewDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;
}

@end
