//
//  PPAppDelegate.m
//  Photo Browser
//
//  Created by App Dev Wizard on 7/26/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//

#import "PPAppDelegate.h"

#import "PPPhotosViewController.h"

#import <SimpleAuth/SimpleAuth.h>


@implementation PPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Code from:
    // https://github.com/calebd/SimpleAuth/wiki/Instagram
    SimpleAuth.configuration[@"instagram"] = @{
                                               
        @"client_id" : @"edacfad533034bf782230ddbd1b556cb",
        
        SimpleAuthRedirectURIKey : @"photobrowser://auth/instagram"
    };
    
    // @"https://mysite.com/auth/instagram/callback"
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    PPPhotosViewController *photosViewController = [[PPPhotosViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    
    UINavigationBar *navigationBar = navigationController.navigationBar;
    
    navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationBar.barTintColor = [UIColor colorWithRed:255.0 / 255.0 green:149.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    
    self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
