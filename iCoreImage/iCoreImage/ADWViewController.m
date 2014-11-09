//
//  PPViewController.m
//  iCoreImage
//
//  Created by AppDevWizard on 6/26/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>


@interface ADWViewController ()

@property (nonatomic, strong) UIPopoverController *imagePickerControllerPopover;

@property (strong, nonatomic) NSMutableArray *availableCoreImageFiltersNames;

@property (nonatomic, getter = isApplyingFilter) BOOL applyingFilter;

@property (strong, nonatomic)   CIImage     *initialImage;
@property (strong, nonatomic)   CIContext   *context;

@property (strong, nonatomic)   CIFilter    *filterSepiaTone;
@property (strong, nonatomic)   CIFilter    *filterHueAdjust;
@property (strong, nonatomic)   CIFilter    *filterStraighten;

- (void)applySepiaToneToImage;
- (void)applyHueAdjustToImage;
- (void)applyStraightenFilterToImage;

@end


@implementation ADWViewController

- (NSMutableArray *)availableCoreImageFiltersNames
{
    if (!_availableCoreImageFiltersNames)
    {
        _availableCoreImageFiltersNames = [[NSMutableArray alloc] init];
        
        NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
        NSLog(@"The Built-in Filters' names are:\n%@", properties);
        
        for (NSString *filterName in properties)
        {
            CIFilter *filter = [CIFilter filterWithName:filterName];
            
            NSDictionary *filterInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:filterName, @"filterName", [filter attributes], @"filterAttributes", nil];
            
            [_availableCoreImageFiltersNames addObject:filterInfoDict];
        }
    }
    
    return _availableCoreImageFiltersNames;
}

- (CIContext *)context
{
    // Create the CIContext object, based on GPU
    if (!_context)
    {
        _context = [CIContext contextWithOptions:nil];
    }
    
    return _context;
}

- (void)viewDidLoad
{
    // Show all of the available filters, and information about them
    NSLog(@"self.availableCoreImageFiltersNames = %@", self.availableCoreImageFiltersNames);
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Get the image path for the CIImage object
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image"
                                                         ofType:@"jpg"];
    
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    
    // Create the CIImage object
    self.initialImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    
    
    // Create the filters
    self.filterSepiaTone = [CIFilter filterWithName:@"CISepiaTone"];
    self.filterHueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    self.filterStraighten = [CIFilter filterWithName:@"CIStraightenFilter"];
    
    // Set up the User Interface elements values
    self.sliderSepiaTone.value = 0.0f;
    
    self.sliderHueAdjust.minimumValue = -3.14f;
    self.sliderHueAdjust.maximumValue = 3.14f;
    self.sliderHueAdjust.value = 0.0f;
    
    self.sliderStraightenFilter.minimumValue = -3.14f;
    self.sliderStraightenFilter.maximumValue = 3.14f;
    self.sliderStraightenFilter.value = 0.0f;
    
    self.imageViewForDisplay.image = [UIImage imageWithContentsOfFile:filePath];
    
    //    [self.sliderSepiaTone addTarget:self
    //                             action:@selector(applySepiaToneToImage)
    //                   forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.sliderHueAdjust addTarget:self
    //                             action:@selector(applyHueAdjustToImage)
    //                   forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.sliderStraightenFilter addTarget:self
    //                                    action:@selector(applyStraightenFilterToImage)
    //                          forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applySepiaToneToImage
{
    self.applyingFilter = YES;
    
    self.sliderHueAdjust.value = 0.0f;
    self.sliderStraightenFilter.value = 0.0f;
    
    CGFloat slideValue = self.sliderSepiaTone.value;
    
    // Set the filter parameters
    [self.filterSepiaTone setValue:self.initialImage
                            forKey:kCIInputImageKey];
    
    [self.filterSepiaTone setValue:[NSNumber numberWithFloat:slideValue]
                            forKey:@"inputIntensity"];
    
    // Create the filtered image
    CIImage *outputImage = [self.filterSepiaTone outputImage];
    
    // Convert the image
    CGImageRef cgimg = [self.context createCGImage:outputImage
                                          fromRect:[outputImage extent]];
    
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    // Dispay the image
    self.imageViewForDisplay.image = newImg;
    
    // Release the C object
    CGImageRelease(cgimg);
    
    self.applyingFilter = NO;
}

- (IBAction)onSliderSepiaToneValueChanged:(id)sender
{
    if (!self.isApplyingFilter)
    {
        [self performSelectorInBackground:@selector(applySepiaToneToImage)
                               withObject:nil];
    }
}

- (void)applyHueAdjustToImage
{
    self.applyingFilter = YES;
    
    self.sliderSepiaTone.value = 0.0f;
    self.sliderStraightenFilter.value = 0.0f;
    
    CGFloat slideValue = self.sliderHueAdjust.value;
    
    // Set the filter parameters
    [self.filterHueAdjust setValue:self.initialImage
                            forKey:kCIInputImageKey];
    
    [self.filterHueAdjust setValue:[NSNumber numberWithFloat:slideValue]
                            forKey:@"inputAngle"];
    
    // Create the filtered image
    CIImage *outputImage = [self.filterHueAdjust outputImage];
    
    // Convert the image
    CGImageRef cgimg = [self.context createCGImage:outputImage
                                          fromRect:[outputImage extent]];
    
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    // Dispay the image
    self.imageViewForDisplay.image = newImg;
    
    // Release the C object
    CGImageRelease(cgimg);
    
    self.applyingFilter = NO;
}

- (IBAction)onSliderHueAdjustValueChanged:(id)sender
{
    if (!self.isApplyingFilter)
    {
        [self performSelectorInBackground:@selector(applyHueAdjustToImage)
                               withObject:nil];
    }
}

- (void)applyStraightenFilterToImage
{
    self.applyingFilter = YES;
    
    self.sliderSepiaTone.value = 0.0f;
    self.sliderHueAdjust.value = 0.0f;
    
    CGFloat slideValue = self.sliderStraightenFilter.value;
    
    // Set the filter parameters
    [self.filterStraighten setValue:self.initialImage
                             forKey:kCIInputImageKey];
    
    [self.filterStraighten setValue:[NSNumber numberWithFloat:slideValue]
                             forKey:@"inputAngle"];
    
    // Create the filtered image
    CIImage *outputImage = [self.filterStraighten outputImage];
    
    // Convert the image
    CGImageRef cgimg = [self.context createCGImage:outputImage
                                          fromRect:[outputImage extent]];
    
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    // Dispay the image
    self.imageViewForDisplay.image = newImg;
    
    // Release the C object
    CGImageRelease(cgimg);
    
    self.applyingFilter = NO;
}

- (IBAction)onSliderStraightenFilterValueChanged:(id)sender
{
    if (!self.isApplyingFilter)
    {
        [self performSelectorInBackground:@selector(applyStraightenFilterToImage)
                               withObject:nil];
    }
}

- (IBAction)onButtonResetTap:(id)sender
{
    // Get the image path for the CIImage object
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image"
                                                         ofType:@"jpg"];
    
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    
    // Create the CIImage object
    self.initialImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    
    // Set up the User Interface elements values
    self.sliderSepiaTone.value = 0.0f;
    self.sliderHueAdjust.value = 0.0f;
    self.sliderStraightenFilter.value = 0.0f;
    
    self.imageViewForDisplay.image = [UIImage imageWithContentsOfFile:filePath];
}

- (IBAction)onButtonChooseTap:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (IS_IPAD)
    {
        self.imagePickerControllerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerControllerPopover.delegate = self;
        [self.imagePickerControllerPopover setPopoverContentSize:CGSizeMake(320, 500)];
        
        [self.imagePickerControllerPopover presentPopoverFromRect:((UIButton *) sender).frame
                                                           inView:self.view
                                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                                         animated:YES];
    }
    else
    {
        [self presentViewController:imagePicker
                           animated:YES
                         completion:^ {
                             // Some code here if needed
                         }];
    }
}

- (IBAction)onButtonSaveTap:(id)sender
{
    CIImage *saveToSave = nil;
    
    // Check which filter is applied at the moment
    if (self.sliderSepiaTone.value != 0.0f)
    {
        saveToSave = [self.filterSepiaTone outputImage];
    }
    else if (self.sliderHueAdjust.value != 0.0f)
    {
        saveToSave = [self.filterHueAdjust outputImage];
    }
    else if (self.sliderStraightenFilter.value != 0.0f)
    {
        saveToSave = [self.filterStraighten outputImage];
    }
    
    CGImageRef imageToSave = [self.context createCGImage:saveToSave
                                                fromRect:[saveToSave extent]];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary writeImageToSavedPhotosAlbum:imageToSave
                                       metadata:[saveToSave properties]
                                completionBlock:^ (NSURL *assetURL, NSError *error) {
                                    
                                    NSLog(@"error = %@", error);
                                    
                                    NSString *alertMessage = (error == nil) ? @"Image successfully saved!" : @"There was a problem saving the Image :(";
                                    
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                    message:alertMessage
                                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    
                                    [alert show];
                                    
                                    CGImageRelease(imageToSave);
                                }];
}


#pragma mark - UIImagePickerControllerDelegate methods

- (void)    imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.initialImage = [CIImage imageWithCGImage:pickedImage.CGImage];
    self.imageViewForDisplay.image = pickedImage;
    
    if (IS_IPAD)
    {
        [self.imagePickerControllerPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
