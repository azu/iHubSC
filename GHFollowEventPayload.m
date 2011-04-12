//
//  GHFollowEventPayload.m
//  iGithub
//
//  Created by Oliver Letterer on 02.04.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHFollowEventPayload.h"
#import "GithubAPI.h"

@implementation GHFollowEventPayload

@synthesize target=_target;

- (GHPayloadEvent)type {
    return GHPayloadFollowEvent;
}

#pragma mark - Initialization

- (id)initWithRawDictionary:(NSDictionary *)rawDictionary {
    if ((self = [super initWithRawDictionary:rawDictionary])) {
        // Initialization code
        id targetDictionary = [rawDictionary objectForKeyOrNilOnNullObject:@"target"];
        id targetAttributes = [rawDictionary objectForKeyOrNilOnNullObject:@"target_attributes"];
        if ([[targetDictionary class] isSubclassOfClass:[NSDictionary class] ]) {
            self.target = [[[GHTarget alloc] initWithRawDictionary:targetDictionary] autorelease];
        } else if ([[targetAttributes class] isSubclassOfClass:[NSDictionary class] ]) {
            self.target = [[[GHTarget alloc] initWithRawDictionary:targetAttributes] autorelease];
        }
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc {
    [_target release];
    [super dealloc];
}

@end
