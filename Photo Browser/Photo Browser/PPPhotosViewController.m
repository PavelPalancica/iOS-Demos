//
//  PPPhotosViewController.m
//  Photo Browser
//
//  Created by App Dev Wizard on 7/27/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//

#import "PPPhotosViewController.h"

#import "PPPhotoCell.h"

#import <SimpleAuth/SimpleAuth.h>
#import <SAMCache/SAMCache.h>


@interface PPPhotosViewController ()

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) UIImageView *imageViewFull;

- (void)loadInstagramImagesAsynchronously;

- (void)showFullImage:(NSNotification *)notification;
- (void)hideImageViewFull;

@end


@implementation PPPhotosViewController

- (UIImageView *)imageViewFull
{
    if (!_imageViewFull) {
        _imageViewFull = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageViewFull.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewFull.alpha = 0.0f;

        _imageViewFull.hidden = YES;
        
        [self.view addSubview:_imageViewFull];
    }
    
    return _imageViewFull;
}

- (void)loadInstagramImagesAsynchronously
{
    NSURLSession *session = [NSURLSession sharedSession];
    
//    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/snow/media/recent?access_token=%@", self.accessToken];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/photomania/media/recent?access_token=%@", self.accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                        
//                                                        NSString *text = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//                                                        
//                                                        NSLog(@"Response: %@", response);
//                                                        NSLog(@"Text: %@", text);
                                                        
                                                        NSData *data = [NSData dataWithContentsOfURL:location];
                                                        
                                                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                        
                                                        NSLog(@"Response Dictionary = %@", responseDictionary);
                                                        
//                                                        NSArray *photos = [responseDictionary valueForKeyPath:@"data.images.standard_resolution.url"];
//                                                        
//                                                        NSLog(@"Photos: %@", photos);
                                                        
                                                        self.photos = [responseDictionary valueForKeyPath:@"data"];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self.collectionView reloadData];
                                                        });
                                                    }];
    
    [task resume];
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)showFullImage:(NSNotification *)notification
{
    NSLog(@"%s", __FUNCTION__);
    
    NSString *key = notification.userInfo[@"CacheKey"];
    
    self.imageViewFull.hidden = NO;
    self.imageViewFull.image = [[SAMCache sharedCache] imageForKey:key];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.imageViewFull.alpha = 1.0f;
                     }];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFullImage:)
                                                 name:@"FullImageDownloadFinished"
                                               object:nil];
    
    [super viewDidLoad];
    
    self.title = @"Photo Browser";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[PPPhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.accessToken = [userDefaults stringForKey:@"AccessToken"];
    
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram"
                   completion:^(NSDictionary *responseObject, NSError *error) {
                       NSLog(@"Response: %@", responseObject);
                       
                       // token = "301882432.edacfad.c036d8ebffdc4bcea15a65fe6597da50";
                       
                       self.accessToken = responseObject[@"credentials"][@"token"];
                       
                       NSLog(@"accesToken = %@", self.accessToken);
                       
                       [userDefaults setObject:self.accessToken forKey:@"AccessToken"];
                       [userDefaults synchronize];
                       
                       [self loadInstagramImagesAsynchronously];
                   }];
    } else {
        // Already signed in and authorized
        
        [self loadInstagramImagesAsynchronously];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageViewFull)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)hideImageViewFull
{
    if (!self.imageViewFull.isHidden) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.imageViewFull.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             self.imageViewFull.hidden = YES;
                         }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // We always want to see either the default loading image, or the actual image
//    
//    PPPhotoCell *removedCell = (PPPhotoCell *) cell;
//    
//    removedCell.imageView.image = [UIImage imageNamed:@"loading-image"];
//}

@end
