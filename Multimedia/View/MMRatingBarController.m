//
//  MMRatingBarController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMRatingBarController.h"

@interface MMRatingBarController ()
{
	BOOL _canRate;
}
@end

@implementation MMRatingBarController

@synthesize delegate;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_canRate = YES;
	[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerElapsed:) userInfo:Nil repeats:NO];
	for(UIButton* button in self.ratingButtons)
	{
		[button addTarget:self action:@selector(didTapRatingButton:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)createRatingTimer
{
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerElapsed:) userInfo:Nil repeats:NO];
}

- (void)timerElapsed:(NSTimer*)timer
{
	[timer invalidate];
	@synchronized(self)
	{
		_canRate = YES;
	}
}

/**
 * Occurs when one of the rating bar buttons is tapped
 * @param button the UIButton the event triggered for.
 */
- (void)didTapRatingButton:(UIButton*)button
{
	@synchronized(self)
	{
		if(_canRate)
		{
			_canRate = NO;
			if([delegate respondsToSelector:@selector(didSpecifyRating:withRating:)])
			{
				// Buttons tagged 1 to 5, n * 20 <= 100.
				[delegate didSpecifyRating:self withRating:[NSNumber numberWithInt:button.tag * 20]];
			}
			
			[self createRatingTimer];
		}
	}
}

@end
