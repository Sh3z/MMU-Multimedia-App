//
//  CameraEngine.h
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//  Copyright (c) 2013 GDCL http://www.gdcl.co.uk/license.htm
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVCaptureSession.h"
#import "AVFoundation/AVCaptureOutput.h"
#import "AVFoundation/AVCaptureDevice.h"
#import "AVFoundation/AVCaptureInput.h"
#import "AVFoundation/AVCaptureVideoPreviewLayer.h"
#import "AVFoundation/AVMediaFormat.h"

@interface CameraEngine : NSObject

+ (CameraEngine*) engine;
- (void) startup;
- (void) shutdown;
- (AVCaptureVideoPreviewLayer*) getPreviewLayer;

+ (BOOL) canCapture;
- (void) startCapture;
- (void) pauseCapture;
- (void) stopCapture;
- (void) resumeCapture;
- (void)exportVideoToCameraRoll:(NSString*)name;
- (void)exportVideoToCameraRoll:(NSString *)name waitForCompletion:(BOOL)wait;
- (void)deleteVideoWithName:(NSString*)name;

@property (atomic, readwrite) BOOL isCapturing;
@property (atomic, readwrite) BOOL isPaused;

@property (strong, atomic) NSString* fileName;

@end
