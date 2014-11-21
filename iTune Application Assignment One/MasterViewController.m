
//
//  ViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "ApplicationData.h"
#import "ApplicationCell.h"
#import "parseData.h"
#import "ImageDownloader.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define iTuneJSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]



@class ApplicationCell;
@interface MasterViewController () 
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) parseData *storeObject;
@property(nonatomic, strong) NSMutableDictionary *appIconsPath;
@property(nonatomic, strong) ApplicationCell *cell;
@end

@implementation MasterViewController

NSData *iTuneApplicationData;
bool fileExists;
NSString *fileName;
NSString *dictSavedFilePath;
AppDelegate *appDelegate;
BOOL isScroll = NO;

UIImage *largeImage ;
static NSString *cellIdentifier = @"CellIdentifier";





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    _appIconsPath = [[NSMutableDictionary alloc] init];
    

    
    [self.view addSubview:_loadingView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [_dataLoadingIndicator startAnimating];
    
//    _storeObject = [[iTuneStoreObject alloc] initWithJsonData: nil];
    [_dataLoadingIndicator stopAnimating];
    [_loadingView setHidden:YES];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"TestNotification" object:nil];
    
    
//    if (_storeObject.applicationObjects.count == 0)
    {
        // code for online fetch
        dispatch_async(queue ,^{
            iTuneApplicationData = [NSData dataWithContentsOfURL:iTuneJSONURL];
            [self parseJSONData:iTuneApplicationData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self terminatePendingDownloading];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_storeObject.applicationObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApplicationCell * cell = [[ApplicationCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                                    reuseIdentifier: cellIdentifier];
    
    NSUInteger nodeCount = [_storeObject.applicationObjects count];
    if(nodeCount == 0 && indexPath.row == 0)
    {
        [self showLoadingView];
    }
    else
    {
        [_dataLoadingIndicator stopAnimating];
        [_loadingView setHidden:YES];
     
        ApplicationData *appObject = _storeObject.applicationObjects[indexPath.row];
        cell.textLabel.text = appObject.name;
        cell.detailTextLabel.text = appObject.artistName;
        if(nodeCount > 0)
        {
            if(self.tableView.decelerating == NO && self.tableView.dragging == NO)
            {
            
                [cell setApplicationData:appObject forIndexPath:indexPath];
            }
            cell.isScrolling = isScroll;
            cell.imageView.image = [UIImage imageNamed:@"icon_placeholder.png"];
        }
    }
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];
    
    ApplicationData *appObject = _storeObject.applicationObjects[indexPath.row];
    detailViewController.applicationObject = appObject;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)loadIconForOnScreenRows
{
    [self.tableView reloadData];
}



#pragma mark - ScrollingDelegates
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        isScroll = YES;
        [self loadIconForOnScreenRows];
        NSLog(@"scrollViewDidEndDragging");
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isScroll = YES;
    [self loadIconForOnScreenRows];
    NSLog(@"scrollViewDidEndDecelerating");
}

-(void)terminatePendingDownloading
{
    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopDownloadingIcon" object:imageDownloader];
}

-(void)showLoadingView
{
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _loadingView.clipsToBounds = YES;
    _loadingView.layer.cornerRadius = 10.0;
    
    _dataLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _dataLoadingIndicator.frame = CGRectMake(65, 40, _dataLoadingIndicator.bounds.size.width, _dataLoadingIndicator.bounds.size.height);
    _dataLoadingIndicator.hidesWhenStopped = YES;
    [_loadingView addSubview:_dataLoadingIndicator];
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.adjustsFontSizeToFitWidth = YES;
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.text = @"Loading ...";
    [_loadingView addSubview:_loadingLabel];
}

#pragma mark - ParseDelegate
- (void)parseJSONData:(NSData *)responseData
{
    NSDictionary *feed;
    
    if(appDelegate.hasInternetConnection)
    {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        feed = [jsonData objectForKey:@"feed"];
        
        if(!error)
        {
            _storeObject = [[parseData alloc] initWithJsonData:jsonData];
        }
    }
}

-(void)dealloc
{
    [self terminatePendingDownloading];
}

//-(void)receiveTestNotification:(NSNotification *) notification
//{
//    ApplicationCell* cell = (ApplicationCell*) notification.object;
//    _storeObject = [[iTuneStoreObject alloc] initWithJsonData:nil];
//    
//    if ([self.tableView.visibleCells containsObject:cell]) {
//        NSIndexPath* idx = [self.tableView indexPathForCell:cell];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:idx] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}

@end
