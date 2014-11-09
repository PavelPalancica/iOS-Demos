//
//  PPNewsViewController.m
//  iXMLParser
//
//  Created by AppDevWizard on 6/29/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWNewsViewController.h"


@interface ADWNewsViewController ()

@end


@implementation ADWNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.webViewNews.delegate = self;
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.labelTitle.text = self.newsTitle;

    [self.webViewNews loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setWebViewNews:nil];
    [self setActivityIndicator:nil];
    [self setLabelTitle:nil];
    [super viewDidUnload];
}

- (IBAction)onButtonBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWebViewDelegate methods

- (BOOL)            webView:(UIWebView *)webView
 shouldStartLoadWithRequest:(NSURLRequest *)request
             navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    
    self.activityIndicator.hidden = YES;
}

- (void)        webView:(UIWebView *)webView
   didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
}

@end
