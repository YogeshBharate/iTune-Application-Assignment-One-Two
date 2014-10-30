#define iTuneBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define iTuneJSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]



//
//  ViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "appDetailViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

NSMutableArray *applicationNames ;
NSMutableArray *applicationIconURLs ;
NSMutableArray *applicationImageURLs;
NSMutableArray *applicationArtistNames ;
NSMutableArray *applicationPrices;
NSMutableArray *applicationReleaseDates;
NSMutableArray *applicationCategories;
NSMutableArray *applicationUrlLinks;
NSMutableArray *applicationRights;
NSMutableArray *applicationIconDownloads;

NSData *iTuneApplicationData;
bool fileExists;
NSString *fileName;
AppDelegate *appDelegate;

// Application icon directory variables
NSURL *documentsDirectoryForAppIcons;
NSFileManager *appIconFileManager;
NSURL *destinationUrlForAppIcons;
UIImage *downloadAppIcons;

// Application Image directory variables
NSURL *documentDirectoryForAppImages;
NSFileManager * appImageFileManager;
NSURL *destinationUrlForAppImages;
UIImage *downloadAppImages;

UIImage *largeImage ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createJSONFile];
    [self createAppIconsDirectory];
    [self createAppImageDirectory];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _loadingView.clipsToBounds = YES;
    _loadingView.layer.cornerRadius = 10.0;
    
    _dataLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _dataLoadingIndicator.frame = CGRectMake(65, 40, _dataLoadingIndicator.bounds.size.width, _dataLoadingIndicator.bounds.size.height);
    [_loadingView addSubview:_dataLoadingIndicator];
    
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.adjustsFontSizeToFitWidth = YES;
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.text = @"Loading ...";
    [_loadingView addSubview:_loadingLabel];
    
    [self.view addSubview:_loadingView];

    // Allocated all array variables
    applicationNames            = [[NSMutableArray alloc] init];
    applicationIconURLs         = [[NSMutableArray alloc] init];
    applicationImageURLs        = [[NSMutableArray alloc] init];
    applicationArtistNames      = [[NSMutableArray alloc] init];
    applicationPrices           = [[NSMutableArray alloc] init];
    applicationReleaseDates     = [[NSMutableArray alloc] init];
    applicationCategories       = [[NSMutableArray alloc] init];
    applicationUrlLinks         = [[NSMutableArray alloc] init];
    applicationRights           = [[NSMutableArray alloc] init];
    applicationIconDownloads    = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleIdentifier"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [_dataLoadingIndicator startAnimating];
    
    if(!(appDelegate.hasInternet && fileName))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"To run this app need to connect once to network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(!appDelegate.hasInternet)
    {
        // code for offline
        [self fetchiTuneData:iTuneApplicationData];
        [_dataLoadingIndicator stopAnimating];
        _dataLoadingIndicator.hidesWhenStopped = YES;
        [_loadingView setHidden:YES];
    }
    else
    {
        // code for online fetch
        dispatch_async(iTuneBgQueue ,^{
            iTuneApplicationData = [NSData dataWithContentsOfURL:iTuneJSONURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_dataLoadingIndicator stopAnimating];
                _dataLoadingIndicator.hidesWhenStopped = YES;
                [_loadingView setHidden:YES];
                [self fetchiTuneData:iTuneApplicationData];
                [self.tableView reloadData];
            });
        });
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [applicationNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleIdentifier = @"SimpleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"smoke_gray.png"];

    if(appDelegate.hasInternet)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[applicationIconURLs objectAtIndex:indexPath.row]]]];
        
                dispatch_async(dispatch_get_main_queue(), ^{
                
                if(image1)
                {
                    cell.imageView.image = image1 ;
                }
        });
    });
    }
    else
    {
        NSString *iconName = [applicationNames objectAtIndex:indexPath.row];
        NSString *offlineIconLoadingPath = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
        
        NSString *modifiedFileName = [self removeSpecialCharactersFromFileName:iconName];
        
        NSString *appDirectory = [offlineIconLoadingPath stringByAppendingPathComponent:modifiedFileName];
        
        UIImage *appIcon =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:appDirectory]]];
        
        if(appIcon)
        {
            cell.imageView.image = appIcon ;
        }
    }
   
    cell.textLabel.text = [applicationNames objectAtIndex:indexPath.row];

    return cell ;
}

- (void)fetchiTuneData:(NSData *)responseData
{
    NSDictionary *feed;
    
    if(appDelegate.hasInternet)
    {
        NSError *erroriTune;
        NSDictionary *jsoniTune = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&erroriTune];
        feed = [jsoniTune objectForKey:@"feed"];
        [feed writeToFile:[self createJSONFile] atomically:YES];
    }
    else
    {
        feed = [[NSDictionary alloc] initWithContentsOfFile:[self createJSONFile]];
    }

    // Fetching the JSON Data
    NSArray  *entry = [feed objectForKey:@"entry"];
    
    for(NSDictionary *loop in entry)
    {
        NSDictionary *label = loop[@"im:name"];
        NSString *labelString = label[@"label"];
        [applicationNames insertObject:labelString atIndex:[applicationNames count]];
        
        // Fetch small Icon URLS
        NSArray *image = loop[@"im:image"];
        NSDictionary *firstLabel = [image objectAtIndex:0];
        NSString *imageURL = firstLabel[@"label"];
       [applicationIconURLs insertObject:imageURL atIndex:[applicationIconURLs count]];
        
        // download icon images
        [self downloadAppsIcon:imageURL appName:labelString];
        
        // Fetch largeImageURLs
        NSDictionary *largeImageURL = [image objectAtIndex:2];
        NSString *largeImageURLs = largeImageURL[@"label"];
        [applicationImageURLs insertObject:largeImageURLs atIndex:[applicationImageURLs count]];
        
        // Download large Images
        [self downloadApplicationImages:largeImageURLs appName:labelString];
        
        // Fetch artist names
        NSDictionary *artist = loop[@"im:artist"];
        NSString *artistString = artist[@"label"];
        [applicationArtistNames insertObject:artistString atIndex:[applicationArtistNames count]];
        
        // Fetch Category name
        NSDictionary *category = loop[@"category"];
        NSDictionary *attributes = category[@"attributes"];
        NSString *categoryString = attributes[@"label"];
        [applicationCategories insertObject:categoryString atIndex:[applicationCategories count]];

        // Fetch the releasing date
        NSDictionary *releaseDate = loop[@"im:releaseDate"];
        NSDictionary *attributesReleaseDate = releaseDate[@"attributes"];
        NSString *releaseDateString = attributesReleaseDate[@"label"];
        [applicationReleaseDates insertObject:releaseDateString atIndex:[applicationReleaseDates count]];
        
        NSDictionary *price = loop[@"im:price"];
        NSString *priceString = price[@"label"];
        [applicationPrices insertObject:priceString atIndex:[applicationPrices count]];
        
        NSDictionary *link = loop[@"link"];
        NSDictionary *linkAttributes = link[@"attributes"];
        NSString *href = linkAttributes[@"href"];
        [applicationUrlLinks insertObject:href atIndex:[applicationUrlLinks count]];
        
        NSDictionary *rights = loop[@"rights"];
        NSString *rightsString = rights[@"label"];
        [applicationRights insertObject:rightsString atIndex:[applicationRights count]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];

    NSString *labelName = [applicationNames objectAtIndex:indexPath.row];
    
    NSString *imageURL = [applicationImageURLs objectAtIndex:indexPath.row];
    
    NSString *artistName = [applicationArtistNames objectAtIndex:indexPath.row];
    
    NSString *categoryName = [applicationCategories objectAtIndex:indexPath.row];
    
    NSString *releaseDate = [applicationReleaseDates objectAtIndex:indexPath.row];
    
    NSString *price = [applicationPrices objectAtIndex:indexPath.row];
    
    NSString *link = [applicationUrlLinks objectAtIndex:indexPath.row];
    
    NSString *rights = [applicationRights objectAtIndex:indexPath.row];
    
    [detailViewController setText:labelName];
    
    if(appDelegate.hasInternet)
    {
        [detailViewController setImage:imageURL];
    }
    else
    {
        NSString *iconName = [applicationNames objectAtIndex:indexPath.row];
        
        NSString *largeImagePath = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
        
        NSString *modifiedFileName = [self removeSpecialCharactersFromFileName:iconName];
        
        NSString *offlineIconLoadingPath = [largeImagePath stringByAppendingPathComponent:modifiedFileName];
        
        [detailViewController setOfflineImage:[NSURL URLWithString:offlineIconLoadingPath]];
    }
    
    [detailViewController setArtistName:artistName];
    [detailViewController setCategoryName:categoryName];
    [detailViewController setReleaseDate:releaseDate];
    [detailViewController setPrice:price];
    [detailViewController setlink:link];
    [detailViewController setRight:rights];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(NSString *)createJSONFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    fileName = [documentDirectory stringByAppendingPathComponent:@"dataBackup.json"];
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    return fileName;
}

-(void) downloadAppsIcon:(NSString *)url appName:(NSString *)labelName
{
    NSURL *downloadURL = [NSURL URLWithString:url];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    dispatch_async(iTuneBgQueue, ^{
        
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL *location,  NSURLResponse *respone, NSError *error)
            {
                                                          
                    downloadAppIcons = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];

                    NSString *iconName = [location lastPathComponent];
                    NSMutableString *changeIconName = [[NSMutableString alloc] init];
                
                    changeIconName = [iconName mutableCopy];
  
                    NSString *labelNameWithoutWhiteSpace = [self removeSpecialCharactersFromFileName:labelName];
                
                    [changeIconName setString:labelNameWithoutWhiteSpace];
                
                    NSString *appIconDirectory = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
                
                    destinationUrlForAppIcons = [[NSURL URLWithString:appIconDirectory] URLByAppendingPathComponent:changeIconName];
                
                    NSError *error1;
                
                    if([appIconFileManager fileExistsAtPath:[destinationUrlForAppIcons absoluteString]])
                    {
                        [appIconFileManager removeItemAtURL:destinationUrlForAppIcons error:NULL];
                    }
            
                    [appIconFileManager copyItemAtURL:location toURL:destinationUrlForAppIcons error:&error1];
                
            }];
        
        [downloadTask resume];
    });
    
}

-(void)downloadApplicationImages:(NSString *)appImageURL appName:(NSString *)labelName
{
    NSURL *downloadURL = [NSURL URLWithString:appImageURL];

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    dispatch_async(iTuneBgQueue, ^{
        
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL *location,  NSURLResponse *respone, NSError *error)
                {
                    downloadAppImages = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                      
                    NSString *iconName = [location lastPathComponent];
                        
                    NSMutableString *changeIconName = [[NSMutableString alloc] init];
                                                      
                    changeIconName = [iconName mutableCopy];
                        
                    NSString *labelNameWithoutWhiteSpace = [self removeSpecialCharactersFromFileName:labelName];
                                                      
                    [changeIconName setString:labelNameWithoutWhiteSpace];
                        
                    NSString *appIconDirectory = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
                                                      
                    destinationUrlForAppImages = [[NSURL URLWithString:appIconDirectory] URLByAppendingPathComponent:changeIconName];
                    
                    NSError *error1;
                        
                    if([appImageFileManager fileExistsAtPath:[destinationUrlForAppImages absoluteString]])
                    {
                        [appImageFileManager removeItemAtURL:destinationUrlForAppImages error:NULL];
                    }
                        
                    [appImageFileManager copyItemAtURL:location toURL:destinationUrlForAppImages error:&error1];
                    
                }];
        
        [downloadTask resume];
    });
}

-(void)createAppIconsDirectory
{
    NSError *error;
    
    appIconFileManager = [NSFileManager defaultManager];
    
    NSArray *urls = [appIconFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    documentsDirectoryForAppIcons = [urls objectAtIndex:0];
    
    NSString *appIconPath = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
    
    NSURL * appIconURLPath = [NSURL URLWithString:appIconPath];
    
    if(![appIconFileManager createDirectoryAtURL:appIconURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
        NSLog(@"Error1 : %@", error);
    }
}

-(void)createAppImageDirectory
{
    NSError *error;
    appImageFileManager = [NSFileManager defaultManager];
    
    NSArray *urls = [appImageFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    documentDirectoryForAppImages = [urls objectAtIndex:0];
    
    NSString *appImagePath = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
    
    NSURL *appImageURLPath = [NSURL URLWithString:appImagePath];
    
    if(![appImageFileManager createDirectoryAtURL:appImageURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
        NSLog(@"Error 2 : %@", error);
    }
}

-(NSString *)removeSpecialCharactersFromFileName:(NSString *)fileName
{
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    NSString *modifiedFileName = [[fileName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return modifiedFileName;
}

@end
