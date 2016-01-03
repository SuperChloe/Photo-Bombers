//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Chloe on 2015-12-20.
//  Copyright © 2015 Chloe Horgan. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Bombers";
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://blog.teamtreehouse.com/api/get_recent_summary/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Response: %@", text);
    }];
    [task resume];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

@end









