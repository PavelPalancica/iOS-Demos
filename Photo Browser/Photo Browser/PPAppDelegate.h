//
//  PPAppDelegate.h
//  Photo Browser
//
//  Created by App Dev Wizard on 7/26/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

/*

 
 https://github.com/AFNetworking/AFNetworking
 http://oauth.net/2/
 
 
 https://github.com/calebd/SimpleAuth/blob/master/Readme.markdown
 
 Connecting to the Instagram API involves installing a Cocoapod called SimpleAuth which makes it effortless to deal with authentication.
 
 http://simpleauth.io/
 
 
 Go to:
 
 http://instagram.com/developer/
 
 Click to Register Your Application.
 
 Accept the API Terms of Use, if first time there:
 
 http://instagram.com/about/legal/terms/api/
 
 Click Register a New Client.
 
 Give a name to the application, for example Photo Browser.
 
 Five a description to the application, for example An iOS app that displays the user's photos in a nice gallery.
 
 For the website, use http://palancica.com, but it does not matter much.
 
 For the OAuth redirec_uri, choose something like:
 
 photobrowser://auth/instagram
 
 Finally, click Register.
 
 Now we have a new client created.
 
 We can use all those credentials to integrate our app with Instagram API.
 
 Go to:
 
 http://instagram.com/developer/endpoints/tags/
 
 Copy:
 
 https://api.instagram.com/v1/tags/snow/media/recent?access_token=ACCESS-TOKEN
 
 
 */