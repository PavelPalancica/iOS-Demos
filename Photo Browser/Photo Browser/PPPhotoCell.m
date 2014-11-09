//
//  PPPhotoCell.m
//  Photo Browser
//
//  Created by App Dev Wizard on 7/27/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//

#import "PPPhotoCell.h"

#import <SAMCache/SAMCache.h>


@interface PPPhotoCell ()

- (void)downloadPhotoWithURL:(NSURL *)url;

- (void)downloadFullPhotoWithURL:(NSURL *)url;

@end


@implementation PPPhotoCell

- (void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    
//    NSURL *url = [NSURL URLWithString:_photo[@"images"][@"standard_resolution"][@"url"]];
    NSURL *url = [NSURL URLWithString:_photo[@"images"][@"thumbnail"][@"url"]];
    
    [self downloadPhotoWithURL:url];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:@"loading-image"];

        self.imageView = [[UIImageView alloc] initWithImage:image];
        
        [self.contentView addSubview:self.imageView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTap:)];
        
        tapGestureRecognizer.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)downloadPhotoWithURL:(NSURL *)url
{
    NSString *key = [NSString stringWithFormat:@"%@-thumbnail", self.photo[@"id"]];
    
    UIImage *photo = [[SAMCache sharedCache] imageForKey:key];
    
    if (photo) {
        self.imageView.image = photo;
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                            
                                                            /*
                                                             This code will not crash, but we will see many errors in the Console output:
                                                             
                                                             UIImage *image = [UIImage imageWithContentsOfFile:[location path]];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                             self.imageView.image = image;
                                                             });
                                                             */
                                                            
                                                            NSData *data = [NSData dataWithContentsOfURL:location];
                                                            
                                                            UIImage *image = [UIImage imageWithData:data];
                                                            
                                                            [[SAMCache sharedCache] setImage:image forKey:key];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                self.imageView.image = image;
                                                            });
                                                        }];
        
        [task resume];
    }
}

- (void)onImageTap:(UITapGestureRecognizer *)recognizer
{
    NSURL *url = [NSURL URLWithString:_photo[@"images"][@"standard_resolution"][@"url"]];
    
    [self downloadFullPhotoWithURL:url];
}

- (void)downloadFullPhotoWithURL:(NSURL *)url
{
    NSString *key = [NSString stringWithFormat:@"%@-standard_resolution", self.photo[@"id"]];
    
    UIImage *photo = [[SAMCache sharedCache] imageForKey:key];
    
    if (photo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FullImageDownloadFinished"
                                                            object:self
                                                          userInfo:@{ @"CacheKey": key }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        [alert show];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                            
                                                            /*
                                                             This code will not crash, but we will see many errors in the Console output:
                                                             
                                                             UIImage *image = [UIImage imageWithContentsOfFile:[location path]];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                             self.imageView.image = image;
                                                             });
                                                             */
                                                            
                                                            NSData *data = [NSData dataWithContentsOfURL:location];
                                                            
                                                            UIImage *image = [UIImage imageWithData:data];
                                                            
                                                            [[SAMCache sharedCache] setImage:image forKey:key];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                                self.imageView.image = image;
                                                                
                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                                                                });

                                                                
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"FullImageDownloadFinished"
                                                                                                                    object:self
                                                                                                                  userInfo:@{ @"CacheKey": key }];
                                                            });
                                                        }];
        
        [task resume];
    }
}

@end
