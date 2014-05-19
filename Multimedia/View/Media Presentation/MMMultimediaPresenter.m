//
//  MMMultimediaPresenter.m
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMultimediaPresenter.h"

@implementation MMMultimediaPresenter

@synthesize presenter = _presenter;

- (void)setPresenter:(MMMediaPresenter *)presenter
{
	if(_presenter)
	{
		[[_presenter view] removeFromSuperview];
	}
	
	_presenter =  presenter;
	UIView* presenterView = _presenter.view;
	[presenterView setFrame:self.innerView.frame];
	[_innerView addSubview:presenterView];
}

@end
