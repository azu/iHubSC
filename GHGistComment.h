//
//  GHGistComment.h
//  iGithub
//
//  Created by Oliver Letterer on 05.05.11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GHUser;

@interface GHGistComment : NSObject {
@private
    NSNumber *_ID;
    NSString *_URL;
    NSString *_body;
    GHUser *_user;
    NSString *_createdAt;
}

@property (nonatomic, copy) NSNumber *ID;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, retain) GHUser *user;
@property (nonatomic, copy) NSString *createdAt;

- (id)initWithRawDictionary:(NSDictionary *)rawDictionay;

@end