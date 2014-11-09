//
//  PPViewController.m
//  iAudioPlayer
//
//  Created by AppDevWizard on 6/30/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWViewController.h"

#import "ADWPlayerViewController.h"


@interface ADWViewController ()

@property (strong, nonatomic) NSArray *thumbnailImagesArray;
@property (strong, nonatomic) NSArray *songsNames;
@property (strong, nonatomic) NSArray *imagesNames;

@end


@implementation ADWViewController

- (NSArray *)thumbnailImagesArray
{
    if (!_thumbnailImagesArray)
    {
        _thumbnailImagesArray = [[NSArray alloc] init];
    }
    
    return _thumbnailImagesArray;
}

- (NSArray *)songNames
{
    if (!_songsNames)
    {
        _songsNames = [[NSArray alloc] initWithObjects:@"Birds", @"Disco", @"Guitar", @"Love", @"Oriental", @"Reggae", @"Romantic", @"Twinkle", nil];
    }
    
    return _songsNames;
}

- (NSArray *)imagesNames
{
    if (!_imagesNames)
    {
        _imagesNames = [[NSArray alloc] initWithObjects:@"Birds", @"Disco", @"Guitar", @"Love", @"Oriental", @"Reggae", @"Romantic", @"Twinkle", nil];
    }
    
    return _imagesNames;
}

- (void)viewDidLoad
{
    self.tableViewSongs.dataSource = self;
    self.tableViewSongs.delegate = self;
    
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.title = NSLocalizedString(@"iAudioPlayer", @"iAudioPlayer");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTableViewSongs:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)   tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [self.songNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    
    cell.textLabel.text = [self.songNames objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (IS_IPAD ? 88.0f : 44.0f);
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViewSongs deselectRowAtIndexPath:indexPath
                                       animated:YES];
    
    NSString *selectedImageName = [self.songsNames objectAtIndex:indexPath.row];
    NSString *selectedSongName = [self.imagesNames objectAtIndex:indexPath.row];
    
    NSString *iDeviceType = (IS_IPAD ? @"iPad" : (IS_IPHONE_RETINA_3_5 ? @"iPhone" : @"iPhone5"));
    
    ADWPlayerViewController *playerVC = [[ADWPlayerViewController alloc] initWithNibName:[NSString stringWithFormat:@"ADWPlayerViewController_%@", iDeviceType] bundle:nil];
    
    playerVC.imageName = selectedImageName;
    playerVC.songName = selectedSongName;
    
//    soundController.playLength = timeSlider.value*60;  //convert time to seconds
    
    [self.navigationController pushViewController:playerVC
                                         animated:YES];
    
}

@end
