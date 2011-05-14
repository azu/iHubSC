//
//  GHPullToReleaseTableHeaderView.m
//  iGithub
//
//  Created by Oliver Letterer on 14.05.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHPullToReleaseTableHeaderView.h"

#define kGHPullToReleaseTableHeaderViewFlipAnimationDuration 0.3f

@implementation GHPullToReleaseTableHeaderView

@synthesize lastUpdateLabel=_lastUpdateLabel, statusLabel=_statusLabel, arrowImage=_arrowImage, activityView=_activityView;
@synthesize lastUpdateDate=_lastUpdateDate;
@synthesize state=_state;

#pragma mark - setters and getetrs

- (void)setState:(GHPullToReleaseTableHeaderViewState)state {
    if (_state != state) {
        _state = state;
        
        switch (state) {
            case GHPullToReleaseTableHeaderViewStateNormal:
                // switching state to normal
                
                _statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
                _arrowImage.hidden = NO;
                [_activityView stopAnimating];
                
                [CATransaction begin];
                [CATransaction setAnimationDuration:kGHPullToReleaseTableHeaderViewFlipAnimationDuration];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
                
                break;
                
            case GHPullToReleaseTableHeaderViewStateDraggedDown:
                
                _statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
                
                [_activityView stopAnimating];
                _arrowImage.hidden = NO;
                
                [CATransaction begin];
                [CATransaction setAnimationDuration:kGHPullToReleaseTableHeaderViewFlipAnimationDuration];
                _arrowImage.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
                
                break;
                
            case GHPullToReleaseTableHeaderViewStateLoading:
                
                _statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
                [_activityView startAnimating];
                
                _arrowImage.hidden = YES;
                
                break;
            default:
                break;
        }
    }
}

- (void)setLastUpdateDate:(NSDate *)lastUpdateDate {
    if (_lastUpdateDate != lastUpdateDate || lastUpdateDate == nil) {
        [_lastUpdateDate release];
        _lastUpdateDate = [lastUpdateDate retain];
        
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:NSLocalizedString(@"MM/dd/yyyy hh:mm:ss", @"")];
        
        NSString *formattedDateString = nil;
        if (!_lastUpdateDate) {
            formattedDateString = NSLocalizedString(@"Never", @"");
        } else {
            formattedDateString = [formatter stringFromDate:_lastUpdateDate];
        }
        
        _lastUpdateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@", @""), formattedDateString];
    }
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.lastUpdateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)] 
                                 autorelease];
		self.lastUpdateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.lastUpdateLabel.font = [UIFont systemFontOfSize:12.0f];
		self.lastUpdateLabel.textColor = [UIColor colorWithWhite:0.25f alpha:1.0];
		self.lastUpdateLabel.shadowColor = [UIColor whiteColor];
		self.lastUpdateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.lastUpdateLabel.backgroundColor = [UIColor clearColor];
		self.lastUpdateLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:self.lastUpdateLabel];
		
		self.statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)] 
                            autorelease];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		self.statusLabel.textColor = [UIColor colorWithWhite:0.25f alpha:1.0];
		self.statusLabel.shadowColor = [UIColor whiteColor];
		self.statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.statusLabel.backgroundColor = [UIColor clearColor];
		self.statusLabel.textAlignment = UITextAlignmentCenter;
        self.statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
		[self addSubview:self.statusLabel];
		
		self.arrowImage = [CALayer layer];
		self.arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		self.arrowImage.contentsGravity = kCAGravityResizeAspect;
		self.arrowImage.contents = (id)[UIImage imageNamed:@"PullToRefreshArrow.png"].CGImage;
		self.arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		[self.layer addSublayer:self.arrowImage];
		
        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		self.activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        self.activityView.hidesWhenStopped = YES;
		[self addSubview:self.activityView];
        
        self.state = GHPullToReleaseTableHeaderViewStateNormal;
        self.lastUpdateDate = nil;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Memory management

- (void)dealloc {
    [_lastUpdateLabel release];
    [_statusLabel release];
    [_arrowImage release];
    [_activityView release];
    
    [_lastUpdateDate release];
    
    [super dealloc];
}

@end
