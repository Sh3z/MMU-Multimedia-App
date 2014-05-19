//
//  MMMediaPresenter.m
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMediaPresenter.h"

@implementation MMMediaPresenter

@synthesize media = _media, delegate, currentMediaPath = _currentMediaPath, presenterType = _presenterType;

- (void)setMedia:(NSArray *)media
{
	_media = media;
	[self reinitializeFromMedia:media];
}

- (void)beginPresentingMedia
{
}

- (void)skipToNextMedia
{
}

- (void)stopPresentingMedia
{
}

- (void)reinitializeFromMedia:(NSArray *)media
{
}

@end

@implementation MMMediaTypeFormatter

+ (NSString*)enumToString:(MMMediaType)type
{
	if(type == Audio)
	{
		return @"Audio";
	}
	else
	{
		return @"Image";
	}
}

@end
