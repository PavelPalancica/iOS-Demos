//
//  PPViewController.h
//  iFlashLight
//
//  Created by AppDevWizard on 6/23/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADWTorch.h"


@interface ADWViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonTurnOnOrOffFlashLight;

- (IBAction)onButtonTurnOnOrOffFlashLightTap:(id)sender;

@end
