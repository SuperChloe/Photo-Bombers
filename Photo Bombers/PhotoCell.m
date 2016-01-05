//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Chloe on 2016-01-02.
//  Copyright © 2016 Treehouse. All rights reserved.
//

#import "PhotoCell.h"

#import <SAMCache/SAMCache.h>

@implementation PhotoCell

- (void)setPhoto:(NSDictionary *)photo {
    _photo = photo;
    
    NSURL *url = [[NSURL alloc] initWithString:_photo[@"images"][@"thumbnail"][@"url"]];
    [self downloadPhotoWithURL:url];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

- (void)downloadPhotoWithURL:(NSURL *)url {
    NSString *key = [[NSString alloc] initWithFormat:@"%@-thumbnail", self.photo[@"id"]];
    UIImage *photo = [[SAMCache sharedCache] imageForKey:key];
    if (photo) {
        self.imageView.image = photo;
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }];
    [task resume];
}

- (void)like {
    NSLog(@"Link: %@", self.photo[@"link"]);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@",
                           self.photo[@"id"], accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
    }];
    [task resume];
}


- (void)showLikeCompletion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Liked!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    [topController presentViewController:alert animated:YES completion:nil];
    
    double delayInSeconds =1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
