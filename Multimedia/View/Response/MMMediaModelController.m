//
//  MMMediaModelController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMediaModelController.h"
#import "MultimediaResponse.h"
#import "MMMediaController.h"

@implementation MMMediaModelController

- (MMMediaController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
	MMMediaController* controller = [storyboard instantiateViewControllerWithIdentifier:@"mediaResponsePage"];
	[controller setParentResponse:_response];
	[controller setMediaResponse:[[_response media] objectAtIndex:index]];
	return controller;
}

- (NSUInteger)indexOfViewController:(MMMediaController*)viewController
{
	return [[_response media] indexOfObject:[viewController mediaResponse]];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(MMMediaController*)viewController];
    if ((index == 0) || (index == NSNotFound))
	{
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(MMMediaController*)viewController];
    if (index == NSNotFound)
	{
        return nil;
    }
    
    index++;
    if (index == [[_response media] count])
	{
        return nil;
    }
	
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return [[_response media] count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return [self indexOfViewController:[[pageViewController viewControllers] lastObject]];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	if(completed)
	{
		[(MMMediaController*)[[pageViewController viewControllers] lastObject] onSetAsCurrentView];
		[(MMMediaController*)[[pageViewController viewControllers] objectAtIndex:[[pageViewController viewControllers] count] - 1] onHiddenFromView];
	}
}

@end
