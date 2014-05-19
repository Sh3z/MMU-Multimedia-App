//
//  MMAudioPresenter.h
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MMMediaPresenter.h"

/// Represents the MMMediaPresenter used to present Audio files.
@interface MMAudioPresenter : MMMediaPresenter<AVAudioPlayerDelegate>

/// Contains the AVAudioPlayer currently in use by this presenter.
@property (strong, nonatomic, readonly) AVAudioPlayer* currentPlayer;

@end
