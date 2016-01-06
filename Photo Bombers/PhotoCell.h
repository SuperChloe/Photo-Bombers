//
//  PhotoCell.h
//  Photo Bombers
//
//  Created by Chloe on 2016-01-02.
//  Copyright © 2016 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSDictionary *photo;
@property (nonatomic) UITapGestureRecognizer *doubleTap;

@end
