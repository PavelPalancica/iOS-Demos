//
//  PPTorch.m
//  iFlashLight
//
//  Created by AppDevWizard on 6/23/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWTorch.h"


@interface ADWTorch ()

@property (strong, nonatomic) AVCaptureDevice   *captureDevice;
@property (strong, nonatomic) AVCaptureInput    *captureInput;
@property (strong, nonatomic) AVCaptureOutput   *captureOutput;
@property (strong, nonatomic) AVCaptureSession  *captureSession;
@property (assign, nonatomic) dispatch_queue_t  queue;

@end


@implementation ADWTorch

- (BOOL)isAvailable
{
    return [self.captureDevice hasTorch];
}

- (AVCaptureDevice *)captureDevice
{
    if (!_captureDevice)
    {
        // Look for a capture device with a torch
        for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
        {
            if ([device hasTorch] &&
                [device isTorchModeSupported:AVCaptureTorchModeOn] &&
                [device isTorchModeSupported:AVCaptureTorchModeOff])
            {
                _captureDevice = device;
                break;
            }
        }
    }
    
    return _captureDevice;
}

- (AVCaptureInput *)captureInput
{
    if (!_captureInput)
    {
        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice
                                                              error:nil];
    }
    
    return _captureInput;
}

- (AVCaptureOutput *)captureOutput
{
    if (!_captureOutput)
    {
        _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    }
    
    return _captureOutput;
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession)
    {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    
    return _captureSession;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Setup a dispatch queue to handle the torch stuff
        self.queue = dispatch_queue_create("com.palancica.iFlashLight.Torch", NULL);
        
        if (!self.queue)
        {
            return nil;
        }
        
        // Perform the initialization asynchronously
        dispatch_async(_queue, ^{
            
            if (self.captureDevice)
            {
                // Setup the Capture Session and Capture Input/Output
                
                if (self.captureSession)
                {
                    if (self.captureOutput)
                    {
                        NSError *error = nil;
                        
                        if (self.captureInput)
                        {
                            // Configure the device and the session
                            if ([self.captureDevice lockForConfiguration:&error])
                            {
                                // Start session configuration
                                [self.captureSession beginConfiguration];
                                
                                // Add the capture-input to the current session
                                [self.captureSession addInput:self.captureInput];
                                
                                // Add the capture-output to the current session
                                [self.captureSession addOutput:self.captureOutput];
                                
                                // Finish session configuration
                                [self.captureSession commitConfiguration];
                                [self.captureDevice unlockForConfiguration];
                                
                                // Start the session
                                [self.captureSession startRunning];
                            }
                            else
                            {
                                NSLog(@"Failed to lock device %@ for configuration: %@", self.captureDevice, error);

                                self.captureSession = nil;
                                self.captureDevice = nil;
                            }
                        }
                        else
                        {
                            NSLog(@"Failed to setup device %@ as capture input: %@", self.captureDevice, error);
                        }
                    }
                }
            }
        });
    }
    
    return self;
}

- (void)destroySession
{
    dispatch_sync(_queue, ^{
        [self.captureSession stopRunning];
        
        self.captureSession = nil;
        self.captureDevice = nil;
    });
    
    if (self.queue)
    {
        dispatch_release(self.queue);
        
        self.queue = NULL;
    }
}

- (BOOL)isEnabled
{
    __block BOOL enabled = NO;
    
    dispatch_sync(self.queue, ^{
        
        enabled = ([self.captureSession isRunning] &&
                   ([self.captureDevice torchMode] == AVCaptureTorchModeOn));
    });
    
    return enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    dispatch_async(self.queue, ^{
        
        NSError *error = nil;
        
        if ([self.captureDevice lockForConfiguration:&error])
        {
            if (enabled)
            {
                [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
            }
            else
            {
                [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            }
            
            [self.captureDevice unlockForConfiguration];
            
            if (![self.captureSession isRunning])
            {
                [self.captureSession startRunning];
            }
        }
        else
        {
            NSLog(@"Failed to lock device %@ for configuration: %@", self.captureDevice, error);
        }
    });
}

@end
