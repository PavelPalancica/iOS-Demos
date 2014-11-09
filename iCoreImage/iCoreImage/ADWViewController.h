//
//  PPViewController.h
//  iCoreImage
//
//  Created by AppDevWizard on 6/26/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADWViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet  UIImageView     *imageViewForDisplay;
@property (strong, nonatomic) IBOutlet  UISlider        *sliderSepiaTone;
@property (strong, nonatomic) IBOutlet  UISlider        *sliderHueAdjust;
@property (strong, nonatomic) IBOutlet  UISlider        *sliderStraightenFilter;

- (IBAction)onSliderSepiaToneValueChanged:(id)sender;
- (IBAction)onSliderHueAdjustValueChanged:(id)sender;
- (IBAction)onSliderStraightenFilterValueChanged:(id)sender;

- (IBAction)onButtonResetTap:(id)sender;
- (IBAction)onButtonChooseTap:(id)sender;
- (IBAction)onButtonSaveTap:(id)sender;

@end
