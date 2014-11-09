//
//  PPViewController.m
//  iCameraFrames
//
//  Created by AppDevWizard on 7/1/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWViewController.h"


@interface ADWViewController ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *frameOutput;

// Used to render a CIImage into a CGImage
@property (nonatomic, strong) CIContext *context;

// The actual Image on the screen, where the Camera frame will be shown
@property (nonatomic, strong) IBOutlet UIImageView *imageViewCamera;

@end


@implementation ADWViewController

// Lazy instantiation of the context
- (CIContext *)context
{
    if (!_context)
    {
        //        _context = [[CIContext alloc] init];
        _context = [CIContext contextWithOptions:nil];
    }
    
    return _context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.session = [[AVCaptureSession alloc] init];
    // We can set other values for sessionPreset, but because we do realtime camera frames processing, we will choose a lower resolution
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    //    self.videoDevice = [AVCaptureDevice devicesWithMediaType:@""];
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice
                                                            error:&error];
    
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings =
    [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self
                                        queue:dispatch_get_main_queue()]; // the global dispatch queue
    
    // Start the AVCaptureSession
    [self.session startRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate methods

- (void)    captureOutput:(AVCaptureOutput *)captureOutput
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer // a pointer to the actual pixel data that was captured in the frame
           fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef bp = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:bp];
    
    CGImageRef ref = [self.context createCGImage:ciImage
                                        fromRect:ciImage.extent];
    
    self.imageViewCamera.image = [UIImage imageWithCGImage:ref
                                                     scale:1.0f
                                               orientation:UIImageOrientationRight];
    
    CGImageRelease(ref);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
