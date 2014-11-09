//
//  PPPlayerViewController.h
//  iAudioPlayer
//
//  Created by AppDevWizard on 6/30/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface ADWPlayerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel      *labelSongName;
@property (strong, nonatomic) IBOutlet UIImageView  *imageViewSongRepresentation;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlayPause;

@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *songName;

- (IBAction)onButtonBackTap:(id)sender;
- (IBAction)onButtonPlayPauseTap:(id)sender;

@end
