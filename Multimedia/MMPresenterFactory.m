//
//  MMPresenterFactory.m
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMPresenterFactory.h"

@implementation MMPresenterFactory

+ (MMMediaPresenter*)createPresenterForType:(MMMediaType)type
{
	switch (type)
	{
		case Image:
			return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"imagePresenter"];
			
			
		case Audio:
			return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"audioPresenter"];
			
		default:
			return nil;
	}
}

@end
