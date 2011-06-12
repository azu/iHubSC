//
//  GithubAPI.h
//  iGithub
//
//  Created by Oliver Letterer on 29.03.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHManagedObjectContext.h"
#import "GHAuthenticationManager.h"

#import "GHBackgroundQueue.h"
#import "GHUser.h"
#import "GHNewsFeed.h"
#import "GHNewsFeedItem.h"
#import "GHActorAttributes.h"
#import "GHIssue.h"
#import "GHRawIssue.h"
#import "GHTarget.h"
#import "GHIssueComment.h"
#import "GHCommit.h"
#import "GHCommitFileInformation.h"
#import "GHCommitMessage.h"
#import "GHPullRequest.h"
#import "GHPullRequestDiscussion.h"
#import "GHPullRequestRepositoryInformation.h"
#import "GHRepository.h"
//#import "GHBranch.h"
#import "GHFileSystemItem.h"
#import "GHFile.h"
#import "GHDirectory.h"
#import "GHFileMetaData.h"

#warning make pagination in implemetation more genertic

// V3
#import "GHAPIConnectionHandlersV3.h"
#import "GHAPIIssueCommentV3.h"
#import "GHAPIIssueV3.h"
#import "GHAPIMilestoneV3.h"
#import "GHAPIGistV3.h"
#import "GHAPIGistFileV3.h"
#import "GHAPIGistForkV3.h"
#import "GHAPIGistCommentV3.h"
#import "GHAPIUserV3.h"
#import "GHAPIUserPlanV3.h"
#import "GHAPIIssueEventV3.h"
#import "GHAPILabelV3.h"
#import "GHAPIRepositoryBranchV3.h"
#import "GHAPIRepositoryV3.h"
#import "GHAPIOrganizationV3.h"
#import "GHAPITeamV3.h"

#import "GHPayload.h"
#import "GHIssuePayload.h"
#import "GHPushPayload.h"
#import "GHPullRequestPayload.h"
#import "GHCommitEventPayload.h"
#import "GHPayloadWithRepository.h"
#import "GHFollowEventPayload.h"
#import "GHWatchEventPayload.h"
#import "GHCreateEventPayload.h"
#import "GHForkEventPayload.h"
#import "GHDeleteEventPayload.h"
#import "GHGollumEventPayload.h"
#import "GHGistEventPayload.h"
#import "GHDownloadEventPayload.h"
#import "GHMemberEventPayload.h"
#import "GHIssuesCommentPayload.h"
#import "GHForkApplyEventPayload.h"
#import "GHPublicEventPayload.h"

#import "JSONKit.h"
#import "NSDictionary+GHNullTermination.h"
#import "NSString+GithubAPIAdditions.h"
#import "NSDate+GithubAPIAdditions.h"

#import "UIImage+Gravatar.h"
#import "GHGravatarBackgroundQueue.h"
#import "GHGravatarImageCache.h"
#import "NSDate+GithubAPIAdditions.h"
#import "ASIHTTPRequest+GithubAPIAdditions.h"
#import "NSError+GithubAPI.h"
#import "UIColor+GithubAPI.h"
