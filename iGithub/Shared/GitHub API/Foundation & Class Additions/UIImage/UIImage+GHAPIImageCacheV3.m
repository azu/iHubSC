//
//  UIImage+GHAPIImageCacheV3.m
//  iGithub
//
//  Created by Oliver Letterer on 11.07.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "UIImage+GHAPIImageCacheV3.h"
#import "GithubAPI.h"
#import "UIImage+Resize.h"
#import "ASIHTTPRequest.h"
#import "GHAPIImageCacheV3.h"

@implementation UIImage (GHAPIImageCacheV3)

+ (void)imageFromAvatarURLString:(NSString *)avatarURLString 
      withCompletionHandler:(void(^)(UIImage *image))handler {
    
    UIImage *myImage = [UIImage cachedImageFromAvatarURLString:avatarURLString];
    
    dispatch_queue_t backgroundQueue = [GHAPIBackgroundQueueV3 sharedInstance].imageQueue;
    
    if (!myImage) {
        dispatch_async(backgroundQueue, ^(void) {
            UIImage *myImage = [UIImage cachedImageFromAvatarURLString:avatarURLString];
            if (myImage) {
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    handler(myImage);
                });
                return;
            }
            
            NSError *myError = nil;
            NSURL *imageURL = [NSURL URLWithString:avatarURLString];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURL];
            [request startSynchronous];
            
            myError = [request error];
            
            NSData *imageData = [request responseData];
            
            UIImage *theImage = [[UIImage alloc] initWithData:imageData];
            
            if (theImage) {
                CGSize imageSize = CGSizeMake(56.0f * [UIScreen mainScreen].scale, 56.0f * [UIScreen mainScreen].scale);
                
                theImage = [theImage resizedImageToSize:imageSize];
                if (!theImage) {
                    theImage = [UIImage imageNamed:@"DefaultUserImage.png"];
                }
                [[GHAPIImageCacheV3 sharedInstance] cacheImage:theImage forURL:avatarURLString storeOnDisk:YES];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (myError) {
                    [[GHAPIImageCacheV3 sharedInstance] cacheImage:[UIImage imageNamed:@"DefaultUserImage.png"] forURL:avatarURLString storeOnDisk:NO];
                    handler([UIImage imageNamed:@"DefaultUserImage.png"]);
                } else {
                    if (theImage) {
                        handler(theImage);
                    } else {
                        handler([UIImage imageNamed:@"DefaultUserImage.png"]);
                    }
                }
            });
        });
    } else {
        handler(myImage);
    }
}

+ (UIImage *)cachedImageFromAvatarURLString:(NSString *)avatarURLString {
    return [[GHAPIImageCacheV3 sharedInstance] cachedImageFromURL:avatarURLString];
}

@end
