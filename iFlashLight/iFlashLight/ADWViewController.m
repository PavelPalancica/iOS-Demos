//
//  PPViewController.m
//  iFlashLight
//
//  Created by AppDevWizard on 6/23/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWViewController.h"


@interface ADWViewController ()

@property (strong, nonatomic) ADWTorch *torch;

@property (assign, nonatomic, getter = isFlashLightOn) BOOL flashLightOn;

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification;
- (void)resumeSession;

- (void)toggleTorchAndFlashLightButtonTitle;

@end


@implementation ADWViewController

- (ADWTorch *)torch
{
    if (!_torch)
    {
        _torch = [[ADWTorch alloc] init];
    }
    
    return _torch;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // If torch is not supported, do the corresponding actions
    if (![self.torch isAvailable])
    {
        self.buttonTurnOnOrOffFlashLight.enabled = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There is no Torch available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setButtonTurnOnOrOffFlashLight:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonTurnOnOrOffFlashLightTap:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self toggleTorchAndFlashLightButtonTitle];
}


#pragma mark - Private methods

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(resumeSession)
                           withObject:nil
                        waitUntilDone:NO];
}

- (void)resumeSession
{
    if (self.isFlashLightOn)
    {
        [self.torch setEnabled:YES];
        
        [self.buttonTurnOnOrOffFlashLight setBackgroundImage:[UIImage imageNamed:@"torch-off"]
                                                    forState:UIControlStateNormal];
        
        self.flashLightOn = YES;
    }
    else
    {
        [self.torch setEnabled:NO];
        
        [self.buttonTurnOnOrOffFlashLight setBackgroundImage:[UIImage imageNamed:@"torch-on"]
                                                    forState:UIControlStateNormal];
        
        self.flashLightOn = NO;
    }
}


- (void)toggleTorchAndFlashLightButtonTitle
{
    if (self.isFlashLightOn)
    {
        [self.torch setEnabled:NO];
        
        [self.buttonTurnOnOrOffFlashLight setBackgroundImage:[UIImage imageNamed:@"torch-on"]
                                                    forState:UIControlStateNormal];
        
        self.flashLightOn = NO;
    }
    else
    {
        [self.torch setEnabled:YES];
        
        [self.buttonTurnOnOrOffFlashLight setBackgroundImage:[UIImage imageNamed:@"torch-off"]
                                                    forState:UIControlStateNormal];
        
        self.flashLightOn = YES;
    }
}

@end
