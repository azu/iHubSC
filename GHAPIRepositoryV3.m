//
//  GHAPIRepositoryV3.m
//  iGithub
//
//  Created by Oliver Letterer on 22.05.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHAPIRepositoryV3.h"
#import "GithubAPI.h"

@interface GHAPIRepositoryV3 ()

- (id)initWithRawDictionary:(NSDictionary *)rawDictionary parseChildren:(BOOL)parse;

@end

@implementation GHAPIRepositoryV3

@synthesize URL = _URL, HTMLURL = _HTMLURL, owner = _owner, name = _name, description = _description, homepage = _homepage, language = _language, private = _private, fork = _fork, forks = _forks, watchers = _watchers, size = _size, openIssues = _openIssues, pushedAt = _pushedAt, createdAt = _createdAt, organization = _organization, parent = _parent, source = _source, integralBranch = _integralBranch, masterBranch = _masterBranch, hasIssues = _hasIssues, hasWiki = _hasWiki, hasDownloads = _hasDownloads;

#pragma mark - setters and getters

- (BOOL)hasLanguage {
    return self.language != nil;
}

- (BOOL)hasHomepage {
    return self.homepage != nil && ![self.homepage isEqualToString:@""];
}

- (BOOL)isForked {
    return [self.fork boolValue];
}

- (NSString *)description {
    if (!_description) {
        return [super description];
    }
    return _description;
}

#pragma mark - Initialization

- (id)initWithRawDictionary:(NSDictionary *)rawDictionary parseChildren:(BOOL)parse {
    if ((self = [super init])) {
        DLog(@"%@", rawDictionary);
        // Initialization code
        self.URL = [rawDictionary objectForKeyOrNilOnNullObject:@"url"];
        self.HTMLURL = [rawDictionary objectForKeyOrNilOnNullObject:@"html_url"];
        self.owner = [[[GHAPIUserV3 alloc] initWithRawDictionary:[rawDictionary objectForKeyOrNilOnNullObject:@"owner"]] autorelease];
        self.name = [rawDictionary objectForKeyOrNilOnNullObject:@"name"];
        self.description = [rawDictionary objectForKeyOrNilOnNullObject:@"description"];
        self.homepage = [rawDictionary objectForKeyOrNilOnNullObject:@"homepage"];
        self.language = [rawDictionary objectForKeyOrNilOnNullObject:@"language"];
        self.private = [rawDictionary objectForKeyOrNilOnNullObject:@"private"];
        self.fork = [rawDictionary objectForKeyOrNilOnNullObject:@"fork"];
        self.forks = [rawDictionary objectForKeyOrNilOnNullObject:@"forks"];
        self.watchers = [rawDictionary objectForKeyOrNilOnNullObject:@"watchers"];
        self.size = [rawDictionary objectForKeyOrNilOnNullObject:@"size"];
        self.openIssues = [rawDictionary objectForKeyOrNilOnNullObject:@"open_issues"];
        self.pushedAt = [rawDictionary objectForKeyOrNilOnNullObject:@"pushed_at"];
        self.createdAt = [rawDictionary objectForKeyOrNilOnNullObject:@"created_at"];
//        self.organization = [rawDictionary objectForKeyOrNilOnNullObject:@"organization"];
        if (parse) {
            self.parent = [[[GHAPIRepositoryV3 alloc] initWithRawDictionary:[rawDictionary objectForKeyOrNilOnNullObject:@"parent"] parseChildren:NO] autorelease];
            self.source = [[[GHAPIRepositoryV3 alloc] initWithRawDictionary:[rawDictionary objectForKeyOrNilOnNullObject:@"source"] parseChildren:NO] autorelease];
        }
        self.integralBranch = [rawDictionary objectForKeyOrNilOnNullObject:@"integrate_branch"];
        self.masterBranch = [rawDictionary objectForKeyOrNilOnNullObject:@"master_branch"];
        self.hasIssues = [rawDictionary objectForKeyOrNilOnNullObject:@"has_issues"];
        self.hasWiki = [rawDictionary objectForKeyOrNilOnNullObject:@"has_wiki"];
        self.hasDownloads = [rawDictionary objectForKeyOrNilOnNullObject:@"has_downloads"];
    }
    return self;
}

- (id)initWithRawDictionary:(NSDictionary *)rawDictionary {
    if ((self = [self initWithRawDictionary:rawDictionary parseChildren:YES])) {
        
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc {
    [_URL release];
    [_HTMLURL release];
    [_owner release];
    [_name release];
    [_description release];
    [_homepage release];
    [_language release];
    [_private release];
    [_fork release];
    [_forks release];
    [_watchers release];
    [_size release];
    [_openIssues release];
    [_pushedAt release];
    [_createdAt release];
    [_organization release];
    [_parent release];
    [_source release];
    [_integralBranch release];
    [_masterBranch release];
    [_hasIssues release];
    [_hasWiki release];
    [_hasDownloads release];
    
    [super dealloc];
}

#pragma mark - downloading

+ (void)labelOnRepository:(NSString *)repository completionHandler:(void(^)(NSArray *labels, NSError *error))handler {
    // v3: GET /repos/:user/:repo/labels
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/labels",
                                       [repository stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] ];
    
    [[GHBackgroundQueue sharedInstance] sendRequestToURL:URL setupHandler:nil
                                       completionHandler:^(id object, NSError *error, ASIFormDataRequest *request) {
                                           if (error) {
                                               handler(nil, error);
                                           } else {
                                               NSArray *rawArray = object;
                                               
                                               NSMutableArray *finalArray = [NSMutableArray arrayWithCapacity:rawArray.count];
                                               for (NSDictionary *rawDictionary in rawArray) {
                                                   [finalArray addObject:[[[GHAPILabelV3 alloc] initWithRawDictionary:rawDictionary] autorelease] ];
                                               }
                                               
                                               handler(finalArray, nil);
                                           }
                                       }];
}

+ (void)repositoryNamed:(NSString *)repositoryName 
  withCompletionHandler:(void (^)(GHAPIRepositoryV3 *repository, NSError *error))handler {
    // v3: GET /repos/:user/:repo
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/repos/%@",
                                       [repositoryName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] ];
    
    [[GHBackgroundQueue sharedInstance] sendRequestToURL:URL setupHandler:nil
                                       completionHandler:^(id object, NSError *error, ASIFormDataRequest *request) {
                                           if (error) {
                                               handler(nil, error);
                                           } else {
                                               handler([[[GHAPIRepositoryV3 alloc] initWithRawDictionary:object] autorelease], nil);
                                           }
                                       }];
}

@end
