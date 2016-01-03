//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Chloe on 2015-12-20.
//  Copyright © 2015 Chloe Horgan. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"

#import <SimpleAuth/SimpleAuth.h>

@interface PhotosViewController ()

@property (nonatomic) NSString *accessToken;

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
    
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
        
            NSString *accessToken = responseObject[@"credentials"][@"token"];

            [userDefaults setObject:accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
        }];
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@", self.accessToken];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"Text: %@", text);
        }];
        [task resume];
    }
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









