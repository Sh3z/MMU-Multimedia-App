//
//  MMTutorialAnimationController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 02/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "MMTutorialAnimationController.h"

@interface MMTutorialAnimationController ()
{
	BOOL _waitingForTap;
	UIImageView* _imageView;
	CAShapeLayer* _tapCircleLayer;
}
@end

@implementation MMTutorialAnimationController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audioicon"]];
	[_imageView setContentMode:UIViewContentModeCenter];
	
	[_imageView setFrame:self.animationView.frame];
	[self.animationView addSubview:_imageView];
	
	for(UIImageView* imgView in self.imageViews)
	{
		UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
		recognizer.numberOfTapsRequired = 1;
		[imgView addGestureRecognizer:recognizer];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)notifyDelegateAtStage:(NSString*)stage
{
	if([_animationDelegate respondsToSelector:@selector(animationController:didPresentStageWithDescription:)])
	{
		[_animationDelegate animationController:self didPresentStageWithDescription:stage];
	}
}

- (void)imageTapped:(UIGestureRecognizer*)recognizer
{
	if(_waitingForTap)
	{
		_waitingForTap = NO;
		[self animateTapDrawingOnView:recognizer.view];
	}
}

- (void)startTutorialAnimation
{
	[self clearDownAndReset];
	[self notifyDelegateAtStage:@"1. An image or sound will be presented to you."];
	
	[self performSelector:@selector(notifyWaitingForTap) withObject:Nil afterDelay:7];
}

- (void)notifyWaitingForTap
{
	_waitingForTap = YES;
	[self notifyDelegateAtStage:@"2. Tap the icon which best represents your mood for the picture or sound"];
	
	[self performSelector:@selector(didTimeoutForTap) withObject:nil afterDelay:7];
}

- (void)clearDownAndReset
{
	_waitingForTap = NO;
	[_tapCircleLayer removeFromSuperlayer];
}

- (void)animateTapDrawingOnView:(UIView*)viewToAnimateTap;
{
	CGRect frame = viewToAnimateTap.frame;
	int radius = (frame.size.height / 2) + 5;
	_tapCircleLayer = [CAShapeLayer layer];
	_tapCircleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius].CGPath;
	_tapCircleLayer.position = CGPointMake(CGRectGetMidX(frame)-radius, CGRectGetMidY(frame)-radius);
	_tapCircleLayer.fillColor = [UIColor clearColor].CGColor;
	_tapCircleLayer.strokeColor = [UIColor redColor].CGColor;
	_tapCircleLayer.lineWidth = 3;
	
	[self.view.layer addSublayer:_tapCircleLayer];
	
	CABasicAnimation* drawTapAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	drawTapAnimation.duration = 0.5;
	drawTapAnimation.repeatCount = 1.0;
	drawTapAnimation.removedOnCompletion = NO;
	
	drawTapAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	drawTapAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
	drawTapAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[drawTapAnimation setValue:@"tapAnim" forKey:@"animationName"];
	drawTapAnimation.delegate = self;
	
	[_tapCircleLayer addAnimation:drawTapAnimation forKey:@"drawCircleAnimation"];
}

- (void)didTimeoutForTap
{
	_waitingForTap = NO;
	[self notifyDelegateAtStage:@"3. If no response is picked within a few seconds, no response is saved"];
	[self animateMediaTransition];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if([[anim valueForKey:@"animationName"] isEqualToString:@"tapAnim"])
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeoutForTap) object:nil];
		[self notifyDelegateAtStage:@"3. Your response is saved, and a new media presented"];
		[self animateMediaTransition];
	}
}

- (void)animateMediaTransition
{
	CGRect originalFrame = _imageView.frame;
	CGRect destinationFrame = _imageView.frame;
	destinationFrame.origin.x = self.animationView.frame.size.width * -1;
	[UIView animateWithDuration:0.75 delay:0  options:UIViewAnimationOptionCurveLinear  animations:^
	 {
		 [_imageView setFrame:destinationFrame];
	 } completion:^(BOOL finished)
	 {
		 CGRect tmp = originalFrame;
		 tmp.origin.x = originalFrame.origin.x + _imageView.frame.size.width;
		 [_imageView setFrame:tmp];
		 [UIView animateWithDuration:0.75 delay:0  options:UIViewAnimationOptionCurveLinear  animations:^
		  {
			  [_imageView setFrame:originalFrame];
		  } completion:^(BOOL finished)
		  {
			  [self performSelector:@selector(notifyLooping) withObject:nil afterDelay:3];
		  }];
	 }];
}

- (void)notifyLooping
{
	[self notifyDelegateAtStage:@"This process repeats until you have seen all media"];
	if([_animationDelegate respondsToSelector:@selector(animationControllerDidReachEndOfTutorial:)])
	{
		[_animationDelegate animationControllerDidReachEndOfTutorial:self];
	}
}

@end
