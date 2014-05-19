//
//  MMResponseViewController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultimediaResponse;

/// Represents the UIViewController used to present a single MultimediaResponse.
@interface MMResponseViewController : UIViewController<UIPageViewControllerDelegate>

/// Contains a reference to the UIPageViewController to use when presenting each
/// MediaResponse.
@property (strong, nonatomic) UIPageViewController *pageViewController;

/// Contains the MultimediaResponse to be presented.
@property (strong, nonatomic) MultimediaResponse* response;

/// Contains the UIBarButtonItem used to delete the response.
@property (strong, nonatomic) UIBarButtonItem *deleteBarButtonItem;

/// Contains a reference to the UIView used for displaying the pages.
@property (weak, nonatomic) IBOutlet UIView *pagesContainerView;

/// Contains a reference to the UIView used for displaying the video.
@property (weak, nonatomic) IBOutlet UIView *movieContainerView;

/// Contains a reference to the UIBarButtonItem used to export the response.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportBarButtonItem;

/// Occurs when the user taps the export/action button.
- (IBAction)didTapActionButton:(id)sender;

@end
