//
//  PPViewController.h
//  iXMLParser
//
//  Created by AppDevWizard on 6/29/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADWViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableViewArticles;

@end
