//
//  GHPUserViewController.m
//  iGithub
//
//  Created by Oliver Letterer on 01.07.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHPUserViewController.h"
#import "GHPOwnedRepositoriesOfUserViewController.h"
#import "GHPWatchedRepositoriesViewController.h"
#import "GHPFollwingUsersViewController.h"
#import "GHPFollowedUsersViewController.h"
#import "GHPGistsOfUserViewController.h"
#import "GHPUsersNewsFeedViewController.h"
#import "GHPOrganizationsOfUserViewController.h"
#import "GHPIssuesOfAuthenticatedUserViewController.h"

#import "ANNotificationQueue.h"

#define kUITableViewSectionUserInfo         0
#define kUITableViewSectionUserContent      1

#define kUITableViewNumberOfSections        2

@implementation GHPUserViewController

@synthesize user=_user, username=_username;

#pragma mark - setters and getters

- (BOOL)canFollowUser {
    return !self.isAdminsitrativeUser;
}

- (BOOL)isAdminsitrativeUser {
    return [[GHAPIAuthenticationManager sharedInstance].authenticatedUser.login isEqualToString:self.username];
}

- (void)setUsername:(NSString *)username {
    _username = [username copy];
    
    self.isDownloadingEssentialData = YES;
    [GHAPIUserV3 userWithName:_username 
            completionHandler:^(GHAPIUserV3 *user, NSError *error) {
                self.isDownloadingEssentialData = NO;
                if (error) {
                    [self handleError:error];
                } else {
                    self.user = user;
                    if (self.isViewLoaded) {
                        [self.tableView reloadData];
                    }
                }
            }];
}

- (NSString *)userDetailInfoString {
    NSMutableString *string = [NSMutableString stringWithCapacity:500];
    
    [string appendFormat:NSLocalizedString(@"Member since: %@\n", @""), self.user.createdAt.prettyTimeIntervalSinceNow];
    [string appendFormat:NSLocalizedString(@"Repositories: %d\n", @""), self.user.publicRepos.intValue + self.user.totalPrivateRepos.intValue];
    [string appendFormat:NSLocalizedString(@"Followers: %@\n", @""), self.user.followers];
    if (self.user.hasEMail) {
        [string appendFormat:NSLocalizedString(@"E-Mail: %@\n", @""), self.user.EMail];
    }
    if (self.user.hasLocation) {
        [string appendFormat:NSLocalizedString(@"Location: %@\n", @""), self.user.location];
    }
    if (self.user.hasCompany) {
        [string appendFormat:NSLocalizedString(@"Company: %@\n", @""), self.user.company];
    }
    
    return string;
}

#pragma mark - initialization

- (id)initWithUsername:(NSString *)username {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.username = username;
    }
    return self;
}

#pragma mark - memory management


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.user) {
        return 0;
    }
    return kUITableViewNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kUITableViewSectionUserContent) {
        return 7;
    } else if (section == kUITableViewSectionUserInfo) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kUITableViewSectionUserContent) {
        GHPDefaultTableViewCell *cell = [self defaultTableViewCellForRowAtIndexPath:indexPath withReuseIdentifier:@"GHPDefaultTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Repositories", @"");
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Watched Repositories", @"");
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Following", @"");
        } else if (indexPath.row == 3) {
            cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"User following %@", @""), self.user.login];
        } else if (indexPath.row == 4) {
            cell.textLabel.text = NSLocalizedString(@"Gists", @"");
        } else if (indexPath.row == 5) {
            cell.textLabel.text = NSLocalizedString(@"Organizations", @"");
        } else if (indexPath.row == 6) {
            cell.textLabel.text = NSLocalizedString(@"Public Activity", @"");
        } else {
            cell.textLabel.text = nil;
        }
        
        return cell;
    } else if (indexPath.section == kUITableViewSectionUserInfo) {
        if (indexPath.row == 0) {
            GHPInfoTableViewCell *cell = self.infoCell;
            
            cell.textLabel.text = self.user.login;
            cell.detailTextLabel.text = self.userDetailInfoString;
            
            [self updateImageView:cell.imageView atIndexPath:indexPath withAvatarURLString:self.user.avatarURL];
            
            if (!self.canDisplayActionButton) {
                [cell.actionButton removeFromSuperview];
            }
            
            return cell;
        }
    }

    return self.dummyCell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kUITableViewSectionUserInfo) {
        return [GHPInfoTableViewCell heightWithContent:self.userDetailInfoString];
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    
    if (indexPath.section == kUITableViewSectionUserContent) {
        if (indexPath.row == 0) {
            // Repositories
            viewController = [[GHPOwnedRepositoriesOfUserViewController alloc] initWithUsername:self.username];
        } else if (indexPath.row == 1) {
            viewController = [[GHPWatchedRepositoriesViewController alloc] initWithUsername:self.username];
        } else if (indexPath.row == 2) {
            viewController = [[GHPFollwingUsersViewController alloc] initWithUsername:self.username];
        } else if (indexPath.row == 3) {
            viewController = [[GHPFollowedUsersViewController alloc] initWithUsername:self.username];
        } else if (indexPath.row == 4) {
            viewController = [[GHPGistsOfUserViewController alloc] initWithUsername:self.username];
        } else if (indexPath.row == 6) {
            viewController = [[GHPUsersNewsFeedViewController alloc] initWithUsername:self.username];
        } else if (indexPath.row == 5) {
            viewController = [[GHPOrganizationsOfUserViewController alloc] initWithUsername:self.username];
        }
    }
    
    if (viewController) {
        [self.advancedNavigationController pushViewController:viewController afterViewController:self animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - GHCreateRepositoryViewControllerDelegate

- (void)createRepositoryViewControllerDidCancel:(GHCreateRepositoryViewController *)createRepositoryViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRepositoryViewController:(GHCreateRepositoryViewController *)createRepositoryViewController didCreateRepository:(GHAPIRepositoryV3 *)repository {
    [[ANNotificationQueue sharedInstance] detatchSuccesNotificationWithTitle:NSLocalizedString(@"Created Repository", @"") 
                                                                     message:repository.name];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = nil;
    @try {
        title = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    @catch (NSException *exception) { }
    
    if ([title isEqualToString:NSLocalizedString(@"Follow", @"")]) {
        [self setActionButtonActive:YES];
        [GHAPIUserV3 followUser:self.username 
              completionHandler:^(NSError *error) {
                  [self setActionButtonActive:NO];
                  if (error) {
                      [self handleError:error];
                  } else {
                      [[ANNotificationQueue sharedInstance] detatchSuccesNotificationWithTitle:NSLocalizedString(@"Now following", @"") message:self.username];
                      _isFollowingUser = YES;
                  }
              }];
    } else if ([title isEqualToString:NSLocalizedString(@"Unfollow", @"")]) {
        [self setActionButtonActive:YES];
        [GHAPIUserV3 unfollowUser:self.username 
              completionHandler:^(NSError *error) {
                  [self setActionButtonActive:NO];
                  if (error) {
                      [self handleError:error];
                  } else {
                      [[ANNotificationQueue sharedInstance] detatchSuccesNotificationWithTitle:NSLocalizedString(@"Stopped following", @"") message:self.username];
                      _isFollowingUser = NO;
                  }
              }];
    } else if ([title isEqualToString:NSLocalizedString(@"View Blog in Safari", @"")]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.blog] ];
    } else if ([title isEqualToString:NSLocalizedString(@"E-Mail", @"")]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:self.user.EMail]];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else if ([title isEqualToString:NSLocalizedString(@"Create Repository", @"")]) {
        GHCreateRepositoryViewController *createViewController = [[GHCreateRepositoryViewController alloc] init];
        createViewController.delegate = self;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createViewController];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ActionMenu

- (void)downloadDataToDisplayActionButton {
    [GHAPIUserV3 isFollowingUserNamed:self.username 
                    completionHandler:^(BOOL following, NSError *error) {
                        if (error) {
                            [self failedToDownloadDataToDisplayActionButtonWithError:error];
                        } else {
                            _hasFollowingData = YES;
                            _isFollowingUser = following;
                            
                            [self didDownloadDataToDisplayActionButton];
                        }
                    }];
}

- (UIActionSheet *)actionButtonActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    
    if (!self.isAdminsitrativeUser) {
        if (!_isFollowingUser) {
            [sheet addButtonWithTitle:NSLocalizedString(@"Follow", @"")];
        } else {
            [sheet addButtonWithTitle:NSLocalizedString(@"Unfollow", @"")];
        }
    } else {
        [sheet addButtonWithTitle:NSLocalizedString(@"Create Repository", @"")];
    }
    
    if (self.user.hasBlog) {
        [sheet addButtonWithTitle:NSLocalizedString(@"View Blog in Safari", @"")];
    }
    if (self.user.hasEMail && [MFMailComposeViewController canSendMail]) {
        [sheet addButtonWithTitle:NSLocalizedString(@"E-Mail", @"")];
    }
    
    if (sheet.numberOfButtons == 0) {
        return nil;
    }
    sheet.delegate = self;
    return sheet;
}

- (BOOL)canDisplayActionButton {
    return YES;
}

- (BOOL)needsToDownloadDataToDisplayActionButtonActionSheet {
    if (self.canFollowUser) {
        return !_hasFollowingData;
    }
    return NO;
}

#pragma mark - Keyed Archiving

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:_user forKey:@"user"];
    [encoder encodeObject:_username forKey:@"username"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        _user = [decoder decodeObjectForKey:@"user"];
        _username = [decoder decodeObjectForKey:@"username"];
    }
    return self;
}

@end
