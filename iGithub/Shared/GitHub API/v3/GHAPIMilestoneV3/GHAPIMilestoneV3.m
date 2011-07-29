//
//  GHAPIMilestoneV3.m
//  iGithub
//
//  Created by Oliver Letterer on 30.04.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHAPIMilestoneV3.h"
#import "GithubAPI.h"

@implementation GHAPIMilestoneV3

@synthesize closedIssues=_closedIssues, createdAt=_createdAt, creator=_creator, milestoneDescription=_milestoneDescription, dueOn=_dueOn, number=_number, openIssues=_openIssues, state=_state, title=_title, URL=_URL;

- (CGFloat)progress {
    CGFloat nenner = ([self.closedIssues floatValue] + [self.openIssues floatValue]);
    CGFloat zaehler = [self.closedIssues floatValue];
    return nenner == 0.0f ? 0.0f : zaehler/nenner;
}

- (NSString *)dueFormattedString {
    if (!self.dueOn) {
        return NSLocalizedString(@"No due date", @"");
    }
    
    NSDate *pastDate = self.dueOn.dateFromGithubAPIDateString;
    
    NSString *timeString = pastDate.prettyTimeIntervalSinceNow;
    
    if (self.dueInTime) {
        return [NSString stringWithFormat:NSLocalizedString(@"Due in %@", @""), timeString];
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"Past due by %@", @""), timeString];
}

- (BOOL)dueInTime {
    NSDate *pastDate = self.dueOn.dateFromGithubAPIDateString;
    
    return [pastDate timeIntervalSinceNow] > 0 || !self.dueOn;
}

#pragma mark - Initialization

- (id)initWithRawDictionary:(NSDictionary *)rawDictionary {
    rawDictionary = GHAPIObjectExpectedClass(rawDictionary, NSDictionary.class);
    if ((self = [super init])) {
        // Initialization code
        self.closedIssues = [rawDictionary objectForKeyOrNilOnNullObject:@"closed_issues"];
        self.createdAt = [rawDictionary objectForKeyOrNilOnNullObject:@"created_at"];
        self.milestoneDescription = [rawDictionary objectForKeyOrNilOnNullObject:@"description"];
        self.dueOn = [rawDictionary objectForKeyOrNilOnNullObject:@"due_on"];
        self.number = [rawDictionary objectForKeyOrNilOnNullObject:@"number"];
        self.openIssues = [rawDictionary objectForKeyOrNilOnNullObject:@"open_issues"];
        self.state = [rawDictionary objectForKeyOrNilOnNullObject:@"state"];
        self.title = [rawDictionary objectForKeyOrNilOnNullObject:@"title"];
        self.URL = [rawDictionary objectForKeyOrNilOnNullObject:@"url"];
        self.creator = [[GHAPIUserV3 alloc] initWithRawDictionary:[rawDictionary objectForKeyOrNilOnNullObject:@"creator"] ];
    }
    return self;
}

#pragma mark - Memory management


#pragma mark - Keyed Archiving

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_closedIssues forKey:@"closedIssues"];
    [encoder encodeObject:_createdAt forKey:@"createdAt"];
    [encoder encodeObject:_creator forKey:@"creator"];
    [encoder encodeObject:_milestoneDescription forKey:@"milestoneDescription"];
    [encoder encodeObject:_dueOn forKey:@"dueOn"];
    [encoder encodeObject:_number forKey:@"number"];
    [encoder encodeObject:_openIssues forKey:@"openIssues"];
    [encoder encodeObject:_state forKey:@"state"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_URL forKey:@"uRL"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _closedIssues = [decoder decodeObjectForKey:@"closedIssues"];
        _createdAt = [decoder decodeObjectForKey:@"createdAt"];
        _creator = [decoder decodeObjectForKey:@"creator"];
        _milestoneDescription = [decoder decodeObjectForKey:@"milestoneDescription"];
        _dueOn = [decoder decodeObjectForKey:@"dueOn"];
        _number = [decoder decodeObjectForKey:@"number"];
        _openIssues = [decoder decodeObjectForKey:@"openIssues"];
        _state = [decoder decodeObjectForKey:@"state"];
        _title = [decoder decodeObjectForKey:@"title"];
        _URL = [decoder decodeObjectForKey:@"uRL"];
    }
    return self;
}

#pragma mark - downloading

+ (void)milestoneOnRepository:(NSString *)repository number:(NSNumber *)number 
            completionHandler:(void(^)(GHAPIMilestoneV3 *milestone, NSError *error))handler {
    
    // v3: GET /repos/:user/:repo/milestones/:id
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/milestones/%@",
                                       [repository stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                       number]];
    
    [[GHAPIBackgroundQueueV3 sharedInstance] sendRequestToURL:URL setupHandler:nil completionHandler:^(id object, NSError *error, ASIFormDataRequest *request) {
        if (error) {
            handler(nil, error);
        } else {
            handler([[GHAPIMilestoneV3 alloc] initWithRawDictionary:object], nil);
        }
    }];
}

@end