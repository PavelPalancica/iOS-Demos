//
//  PPViewController.m
//  iXMLParser
//
//  Created by AppDevWizard on 6/29/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWViewController.h"

#import "ADWParser.h"
#import "ADWNewsViewController.h"


@interface ADWViewController ()

@property (strong, nonatomic) NSArray *objectsArray;
@property (strong, nonatomic) NSCache *imageCache;

- (void)parse;
- (NSArray *)imagesFromString:(NSString *)string;
- (void)    tableView:(UITableView *)tableView
   updateImageForCell:(UITableViewCell *)cell
            indexPath:(NSIndexPath *)indexPath;

@end


@implementation ADWViewController

- (NSArray *)objectsArray
{
    if (!_objectsArray)
    {
        _objectsArray = [[NSArray alloc] init];
    }
    
    return _objectsArray;
}

- (NSCache *)imageCache
{
    if (!_imageCache)
    {
        _imageCache = [[NSCache alloc] init]; 
    }
    
    return _imageCache;
}

- (void)viewDidLoad
{
    self.tableViewArticles.dataSource = self;
    self.tableViewArticles.delegate = self;
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [self.activityIndicator startAnimating];
        [self parse];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewArticles reloadData];
            [self.activityIndicator stopAnimating];
            
            self.activityIndicator.hidden = YES;
            
            NSLog(@"Data loaded!!!");
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}


#pragma mark - Private methods

- (void)parse
{
    NSURL *url = [NSURL URLWithString:@"http://rss.news.yahoo.com/rss"];
    
    ADWParser *parser = [[ADWParser alloc] initWithContentsOfURL:url];
    
    parser.rowElementName = @"item";
    parser.elementNames = [NSArray arrayWithObjects:@"title", @"description", @"link", @"pubDate", nil];
    
    [parser parse];
    
    self.objectsArray = parser.items;
}

- (NSArray *)imagesFromString:(NSString *)string
{
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, [string length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSString *imgUrlString = [string substringWithRange:[result rangeAtIndex:2]];
                             [imageUrls addObject:[NSURL URLWithString:imgUrlString]];
                         }];
    
    return imageUrls;
}

- (void)    tableView:(UITableView *)tableView
   updateImageForCell:(UITableViewCell *)cell
            indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.objectsArray[indexPath.row];
    NSArray *imageUrls = [self imagesFromString:[dict objectForKey:@"description"]];
    
    if ([imageUrls count] > 0)
    {
        NSURL *url = imageUrls[0];
        UIImage *image = [self.imageCache objectForKey:[url absoluteString]];
        
        if (image)
        {
            cell.imageView.image = image;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:imageUrls[0]];
                UIImage *image = [UIImage imageWithData:data];
                
                if (image != nil)
                {
                    [self.imageCache setObject:image
                                        forKey:[url absoluteString]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UITableViewCell *cellForUpdating = (id) [tableView cellForRowAtIndexPath:indexPath];
                        
                        if (cellForUpdating != nil)
                        {
                            cellForUpdating.imageView.image = image;
                        }
                    });
                }
            });
        }
    }
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)   tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [self.objectsArray count];
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (IS_IPAD ? 88.0f : 44.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ArticleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"cell-left-default-image"];
    
    [self       tableView:tableView
       updateImageForCell:cell
                indexPath:indexPath];
   
    NSDictionary *dict = [self.objectsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text         =   [dict objectForKey:@"title"];
    cell.detailTextLabel.text   =   [dict objectForKey:@"pubDate"];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deviceType = (IS_IPAD ? @"iPad" : (IS_IPHONE_RETINA_3_5 ? @"iPhone" : @"iPhone5"));
    
    ADWNewsViewController *newsVC = [[ADWNewsViewController alloc] initWithNibName:[NSString stringWithFormat:@"ADWNewsViewController_%@", deviceType] bundle:nil];
    
    NSDictionary    *object = [self.objectsArray objectAtIndex:indexPath.row];
    NSURL           *url    = [NSURL URLWithString:object[@"link"]];
    
    newsVC.url = url;
    newsVC.newsTitle = object[@"title"];

    [self.navigationController pushViewController:newsVC
                                         animated:YES];
}

@end
