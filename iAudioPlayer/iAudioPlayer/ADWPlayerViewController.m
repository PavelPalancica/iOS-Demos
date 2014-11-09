//
//  PPPlayerViewController.m
//  iAudioPlayer
//
//  Created by AppDevWizard on 6/30/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWPlayerViewController.h"

#define NOW_IS_PLAYING 1
#define NOW_IS_PAUSED 0


@interface ADWPlayerViewController ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (assign, nonatomic) NSUInteger playingState;
@property (strong, nonatomic) NSTimer *stopWatch;

@end


@implementation ADWPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
 
    NSLog(@"self.songName = %@", self.songName);
    
    if (self.songName != nil)
    {
        self.labelSongName.text = self.songName;
    }

    if (self.imageViewSongRepresentation != nil)
    {
        self.imageViewSongRepresentation.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.imageName]];
    }
    
    self.playingState = NOW_IS_PAUSED;

    NSURL *urlForSong = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.songName
                                                                             ofType:@"mp3"]];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlForSong
                                                              error:nil];

    // Loop indefinitely until stopped
    self.audioPlayer.numberOfLoops = -1;
    
    [self.audioPlayer prepareToPlay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.audioPlayer isPlaying])
    {
        [self.audioPlayer stop];
        
        self.audioPlayer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setImageViewSongRepresentation:nil];
    [self setLabelSongName:nil];
    [self setButtonPlayPause:nil];
    [super viewDidUnload];
}

- (IBAction)onButtonBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onButtonPlayPauseTap:(id)sender
{
    if (self.playingState == NOW_IS_PLAYING)
    {
        [self.buttonPlayPause setTitle:@"Play"
                              forState:UIControlStateNormal];
        
        [self.audioPlayer stop];
    }
    else if (self.playingState == NOW_IS_PAUSED)
    {
        [self.buttonPlayPause setTitle:@"Pause"
                              forState:UIControlStateNormal];
        
        [self.audioPlayer play];
    }
    
    self.playingState = (self.playingState == NOW_IS_PLAYING) ? NOW_IS_PAUSED : NOW_IS_PLAYING;
}

@end
