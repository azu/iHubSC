//
//  GHPullToReleaseTableHeaderView.h
//  iGithub
//
//  Created by Oliver Letterer on 14.05.11.
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kGHPullToReleaseTableHeaderViewPreferedHeaderHeight 60.0f

typedef enum {
    GHPullToReleaseTableHeaderViewStateNormal,
    GHPullToReleaseTableHeaderViewStateDraggedDown,
    GHPullToReleaseTableHeaderViewStateLoading
} GHPullToReleaseTableHeaderViewState;

@interface GHPullToReleaseTableHeaderView : UIView {
@private
    UILabel *_lastUpdateLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    
    NSDate *_lastUpdateDate;
    
    GHPullToReleaseTableHeaderViewState _state;
}

@property (nonatomic, retain) UILabel *lastUpdateLabel;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) CALayer *arrowImage;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;

@property (nonatomic, retain) NSDate *lastUpdateDate;

@property (nonatomic, assign) GHPullToReleaseTableHeaderViewState state;

@end
