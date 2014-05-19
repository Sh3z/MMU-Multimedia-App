//
//  MMAudioPresenter.m
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMAudioPresenter.h"

@interface MMAudioPresenter ()
{
	NSArray* _players;
	int _currentPlayerIndex;
}

@end

@implementation MMAudioPresenter

@synthesize currentPlayer = _currentPlayer;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_presenterType = Audio;
}

- (void)beginPresentingMedia
{
	_currentPlayerIndex = 0;
	[self playNextMedia];
}

- (void)skipToNextMedia
{
	if(_currentPlayer)
	{
		[_currentPlayer stop];
		if([self.delegate respondsToSelector:@selector(didStopPresentingMedia:atPath:)])
		{
			NSString* file = [[[_currentPlayer url] absoluteString] lastPathComponent];
			[self.delegate didStopPresentingMedia:self atPath:file];
		}
	}
	
	if(_currentPlayerIndex + 1 == [_players count])
	{
		[self notifyTransitionFrom:[[_currentPlayer url] lastPathComponent] to:nil];
		[self notifyReachedEndOfMedia];
	}
	else
	{
		[self notifyTransitionFrom:[[_currentPlayer url] lastPathComponent] to:[[[_players objectAtIndex:_currentPlayerIndex + 1] url] lastPathComponent]];
		_currentPlayerIndex++;
		[self playNextMedia];
	}
}

- (void)stopPresentingMedia
{
	if(_currentPlayer)
	{
		[_currentPlayer stop];
	}
	
	_currentPlayerIndex = 0;
}

- (void)reinitializeFromMedia:(NSArray *)media
{
	if(_currentPlayer)
	{
		[_currentPlayer stop];
	}
	
	NSMutableArray* newPlayers = [[NSMutableArray alloc] initWithCapacity:[media count]];
	for(NSString* file in media)
	{
		NSError* error;
		AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:[file stringByDeletingPathExtension] withExtension:[file pathExtension]] error:&error];
		if(!player)
		{
			NSLog(@"Error creating player: %@", error);
		}
		else
		{
			[newPlayers addObject:player];
		}
	}
	
	_players = newPlayers;
}

/// Begins playing the next media in the set.
- (void)playNextMedia
{
	_currentPlayer = [_players objectAtIndex:_currentPlayerIndex];
	_currentPlayer.delegate = self;
	[_currentPlayer play];
	_currentMediaPath = [[_currentPlayer url] lastPathComponent];
	
	if([self.delegate respondsToSelector:@selector(didBeginPresentingMedia:atPath:)])
	{
		[self.delegate didBeginPresentingMedia:self atPath:[[_currentPlayer url] lastPathComponent]];
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

/// Notifies the end of the media has been reached to the delegate.
- (void)notifyReachedEndOfMedia
{
	if([self.delegate respondsToSelector:@selector(didReachEndOfMedia:)])
	{
		[self.delegate didReachEndOfMedia:self];
	}
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[self skipToNextMedia];
}

@end
