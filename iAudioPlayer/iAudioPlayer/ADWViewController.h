//
//  PPViewController.h
//  iAudioPlayer
//
//  Created by AppDevWizard on 6/30/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADWViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewSongs;

@end
