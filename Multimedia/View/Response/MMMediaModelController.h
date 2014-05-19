//
//  MMMediaModelController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMMediaController, MultimediaResponse;

/// Provides a UIPageViewController with the needed information to present pages
/// representing the MediaResponses.
@interface MMMediaModelController : NSObject<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

/// Contains the MultimediaResponse being presented within the UIPageView.
@property (strong, nonatomic) MultimediaResponse* response;

/**
 * Returns an appropriate MMMediaController to display the MediaResponse at the
 * associated index
 * @param index the index number of the MediaResponse to be displayed
 * @param storyboard the UIStoryboard currently being used to provide the UI.
 */
- (MMMediaController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

/**
 * Gets the index of the view controller within the UIPageView
 * @param viewController the MMMediaController to resolve the index of
 * @return an NSUInteger representing the index of the controller.
 */
- (NSUInteger)indexOfViewController:(MMMediaController*)viewController;

@end
