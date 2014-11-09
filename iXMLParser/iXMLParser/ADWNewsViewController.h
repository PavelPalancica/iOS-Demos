//
//  PPNewsViewController.h
//  iXMLParser
//
//  Created by AppDevWizard on 6/29/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADWNewsViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel                  *labelTitle;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView  *activityIndicator;
@property (strong, nonatomic) IBOutlet UIWebView                *webViewNews;

@property (strong, nonatomic) NSString  *newsTitle;
@property (strong, nonatomic) NSURL     *url;

- (IBAction)onButtonBackTap:(id)sender;

@end
