//
//  UITableViewAlertViewTableViewCell.m
//  ExampleApp
//
//  Created by Oliver Letterer on 30.01.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHTableViewAlertViewTableViewCell.h"


@implementation GHTableViewAlertViewTableViewCell

@synthesize activityIndicatorView=_activityIndicatorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:_activityIndicatorView];
		_activityIndicatorView.hidesWhenStopped = YES;
		[_activityIndicatorView stopAnimating];
		
		_seperatorView = [[GHTableViewAlertViewTableViewCellSeperatorView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-2.0, self.bounds.size.width, 2.0)];
		[self addSubview:_seperatorView];
	}
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_activityIndicatorView.center = CGPointMake(self.bounds.size.width - _activityIndicatorView.bounds.size.width - 5.0, self.bounds.size.height/2.0);
	_seperatorView.frame = CGRectMake(0, self.bounds.size.height-2.0, self.bounds.size.width, 2.0);
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[_activityIndicatorView stopAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
	if (selected) {
		_activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	} else {
		_activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	if (highlighted) {
		_activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	} else {
		_activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	}
}

@end