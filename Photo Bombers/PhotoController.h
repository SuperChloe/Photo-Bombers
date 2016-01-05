//
//  PhotoController.h
//  Photo Bombers
//
//  Created by Chloe on 2016-01-04.
//  Copyright © 2016 Treehouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoController : NSObject

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
