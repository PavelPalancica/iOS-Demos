//
//  PPViewController.m
//  iAnalogClock
//
//  Created by AppDevWizard on 6/23/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWViewController.h"


@interface ADWViewController ()

@end


@implementation ADWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.viewAnalogClock.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.viewAnalogClock startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.viewAnalogClock stopAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setViewAnalogClock:nil];
    [super viewDidUnload];
}
@end
