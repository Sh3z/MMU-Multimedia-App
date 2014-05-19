//
// SlideShowEngine.m
//
// Copyright 2013 Alexis Creuzot
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "SlideShowEngine.h"

#define kSwipeTransitionDuration 0.25

typedef NS_ENUM(NSInteger, SlideShowEngineSlideMode) {
    SlideShowEngineSlideModeForward,
    SlideShowEngineSlideModeBackward
};

@interface SlideShowEngine()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@property (strong,nonatomic) UIImageView * topImageView;
@property (strong,nonatomic) UIImageView * bottomImageView;

@end

@implementation SlideShowEngine

@synthesize delegate;
@synthesize delay;
@synthesize repeat;
@synthesize transitionDuration;
@synthesize transitionType;
@synthesize images;

- (void)awakeFromNib
{
    [self setDefaultValues];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void) setDefaultValues
{
    self.clipsToBounds = YES;
    self.images = [NSMutableArray array];
    _currentIndex = 0;
    delay = 3;
    
    transitionDuration = 1;
    transitionType = SlideShowEngineTransitionFade;
    _doStop = YES;
    _isAnimating = NO;
	self.repeat = YES;
    
    _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _topImageView.clipsToBounds = YES;
    _bottomImageView.clipsToBounds = YES;
    [self setImagesContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:_bottomImageView];
    [self addSubview:_topImageView];
	
	delegate = nil;
}

- (void) setImagesContentMode:(UIViewContentMode)mode
{
    _topImageView.contentMode = mode;
    _bottomImageView.contentMode = mode;
}

- (UIViewContentMode) imagesContentMode
{
    return _topImageView.contentMode;
}

- (void) addGesture:(SlideShowEngineGestureType)gestureType
{
    switch (gestureType)
    {
        case SlideShowEngineGestureTap:
            [self addGestureTap];
            break;
        case SlideShowEngineGestureSwipe:
            [self addGestureSwipe];
            break;
        case SlideShowEngineGestureAll:
            [self addGestureTap];
            [self addGestureSwipe];
            break;
        default:
            break;
    }
}

- (void) addImagesFromResources:(NSArray *) names
{
    for(NSString * name in names){
        [self addImage:[UIImage imageNamed:name]];
    }
}

- (void) addImage:(UIImage*) image
{
    [self.images addObject:image];
    
    if([self.images count] == 1){
        _topImageView.image = image;
    }else if([self.images count] == 2){
        _bottomImageView.image = image;
    }
}

- (void)emptyImages
{
	[self.images removeAllObjects];
    _currentIndex = 0;
}

- (void) emptyAndAddImagesFromResources:(NSArray *)names
{
    [self emptyImages];
    [self addImagesFromResources:names];
}

- (void) start
{
    switch([self.images count])
	{
		case 0:
			return;
			
		case 1:
			[self next];
			break;
			
		default:
			_doStop = NO;
			[self performSelector:@selector(next) withObject:nil afterDelay:delay];
			break;
	}
}

- (void)transitionToImageAtIndex:(NSUInteger)nextIndex
{
	_topImageView.image = self.images[_currentIndex];
	_bottomImageView.image = self.images[nextIndex];
	_currentIndex = nextIndex;
	
	// Animate
	switch (transitionType) {
		case SlideShowEngineTransitionFade:
			[self animateFade];
			break;
			
		case SlideShowEngineTransitionSlide:
			[self animateSlide:SlideShowEngineSlideModeForward];
			break;
			
	}
	
	// Call delegate
	if([delegate respondsToSelector:@selector(SlideShowEngineDidNext:)])
	{
		[delegate SlideShowEngineDidNext:self];
	}
}

- (void) next
{
    if(! _isAnimating){
        
        // Next Image
		NSUInteger nextIndex = (_currentIndex+1)%[self.images count];
		
		if(nextIndex == 0)
		{
			if([delegate respondsToSelector:@selector(SlideShowEngineDidReachEndOfImages:willLoop:)])
			{
				[delegate SlideShowEngineDidReachEndOfImages:self willLoop:self.repeat];
			}
			
			if(self.repeat == NO)
			{
				[self stop];
				return;
			}
		}

		[self transitionToImageAtIndex:nextIndex];
    }
}


- (void) previous
{
    if(! _isAnimating){
        
        // Previous image
        NSUInteger prevIndex;
        if(_currentIndex == 0){
            prevIndex = [self.images count] - 1;
        }else{
            prevIndex = (_currentIndex-1)%[self.images count];
        }
        _topImageView.image = self.images[_currentIndex];
        _bottomImageView.image = self.images[prevIndex];
        _currentIndex = prevIndex;
        
        // Animate
        switch (transitionType) {
            case SlideShowEngineTransitionFade:
                [self animateFade];
                break;
                
            case SlideShowEngineTransitionSlide:
                [self animateSlide:SlideShowEngineSlideModeBackward];
                break;
        }
        
        // Call delegate
        if([delegate respondsToSelector:@selector(SlideShowEngineDidPrevious:)]){
            [delegate SlideShowEngineDidPrevious:self];
        }
    }
    
}

- (void) animateFade
{
    _isAnimating = YES;
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         _topImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         _topImageView.image = _bottomImageView.image;
                         _topImageView.alpha = 1;
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}

- (void) animateSlide:(SlideShowEngineSlideMode) mode
{
    _isAnimating = YES;
    
    if(mode == SlideShowEngineSlideModeBackward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(- _bottomImageView.frame.size.width, 0);
    }else if(mode == SlideShowEngineSlideModeForward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(_bottomImageView.frame.size.width, 0);
    }
    
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         
                         if(mode == SlideShowEngineSlideModeBackward){
                             _topImageView.transform = CGAffineTransformMakeTranslation( _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }else if(mode == SlideShowEngineSlideModeForward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(- _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                     }
                     completion:^(BOOL finished){
                         
                         _topImageView.image = _bottomImageView.image;
                         _topImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}


- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

#pragma mark - Gesture Recognizers initializers
- (void) addGestureTap
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          
                                                          initWithTarget:self action:@selector(handleSingleTap:)];
    
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) addGestureSwipe
{
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    [self addGestureRecognizer:swipeRightGestureRecognizer];
}

#pragma mark - Gesture Recognizers handling
- (void)handleSingleTap:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint pointTouched = [gesture locationInView:self.topImageView];
    
    if (pointTouched.x <= self.topImageView.center.x)
    {
        [self previous];
    }
    else
    {
        [self next];
    }
}

- (void) handleSwipe:(id)sender
{
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)sender;
    
    float oldTransitionDuration = self.transitionDuration;
    
    self.transitionDuration = kSwipeTransitionDuration;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self next];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self previous];
    }
    
    self.transitionDuration = oldTransitionDuration;
}

@end

