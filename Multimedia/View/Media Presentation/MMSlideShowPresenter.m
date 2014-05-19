//
//  MMSlideShowPresenter.m
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMSlideShowPresenter.h"

@implementation MMSlideShowPresenter

@synthesize slideShowEngine;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_presenterType = Image;
	[slideShowEngine setRepeat:NO];
	[slideShowEngine setImagesContentMode:UIViewContentModeScaleAspectFit];
	[slideShowEngine setDelay:5];
	[slideShowEngine setDelegate:self];
}

- (void)beginPresentingMedia
{
	[slideShowEngine start];
	[self respondFromSlideshowMediaChange];
}

- (void)skipToNextMedia
{
	[slideShowEngine next];
}

- (void)stopPresentingMedia
{
	NSUInteger index = slideShowEngine.currentIndex;
	[slideShowEngine stop];
	if([self.delegate respondsToSelector:@selector(didStopPresentingMedia:atPath:)])
	{
		[self.delegate didStopPresentingMedia:self atPath:[self.media objectAtIndex:index]];
	}
}

- (void)reinitializeFromMedia:(NSArray *)media
{
	[slideShowEngine emptyAndAddImagesFromResources:media];
}

/// Performs common slide transition behaviour from the SlideShowEngine
- (void)respondFromSlideshowMediaChange
{
	_currentMediaPath = [self.media objectAtIndex:[slideShowEngine currentIndex]];
	if([self.delegate respondsToSelector:@selector(didBeginPresentingMedia:atPath:)])
	{
		[self.delegate didBeginPresentingMedia:self atPath:[self.media objectAtIndex:[slideShowEngine currentIndex]]];
	}
}

/**
 * Notifies our delegate of a transition in media
 * @param from the previous media file
 * @param to the new media file
 */
- (void)notifyTransitionFrom:(NSString*)from to:(NSString*)to
{
	if([self.delegate respondsToSelector:@selector(isPreparingToTransition:from:to:)])
	{
		[self.delegate isPreparingToTransition:self from:from to:to];
	}
}

#pragma mark - SlideShowDelegate

- (void) SlideShowEngineDidNext:(SlideShowEngine *) slideShow
{
	if((int)[slideShowEngine currentIndex] - 1 >= 0)
	{
		[self notifyTransitionFrom:[self.media objectAtIndex:[slideShowEngine currentIndex] - 1] to:[self.media objectAtIndex:[slideShowEngine currentIndex]]];
	}
	
	[self respondFromSlideshowMediaChange];
}

- (void) SlideShowEngineDidPrevious:(SlideShowEngine *) slideShow
{
	[self respondFromSlideshowMediaChange];
}

- (void) SlideShowEngineDidReachEndOfImages:(SlideShowEngine*) slideShow willLoop:(BOOL)loop
{
	[self notifyTransitionFrom:[self.media lastObject] to:nil];
	if([self.delegate respondsToSelector:@selector(didReachEndOfMedia:)])
	{
		[self.delegate didReachEndOfMedia:self];
	}
}

@end
