//
//  GalleryViewController.m
//  CollectionViewPetProject
//
//  Created by Vasiliy on 25.01.16.
//  Copyright © 2016 MPK. All rights reserved.
//

#import "GalleryViewController.h"

#import "GalleryCollectionViewDataSource.h"

@interface GalleryViewController ()

@property (strong, nonatomic) GalleryCollectionViewDataSource *dataSource;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[GalleryCollectionViewDataSource alloc] init];
}

@end
