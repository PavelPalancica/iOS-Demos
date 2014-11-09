//
//  PPTorch.h
//  iFlashLight
//
//  Created by AppDevWizard on 6/23/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>


@interface ADWTorch : NSObject

@property (nonatomic, readonly, getter = isAvailable) BOOL available;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
