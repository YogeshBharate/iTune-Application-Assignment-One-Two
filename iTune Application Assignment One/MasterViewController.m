
//
//  ViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ApplicationCell.h"
#import "iTuneDataManager.h"
#import "ImageDownloader.h"
#import "AppDelegate.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define JSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]

@class ApplicationCell;

@interface MasterViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) ApplicationCell *cell;
@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *dataLoadingIndicator;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic) NSMutableArray *applicationRecords;

@end

@implementation MasterViewController

static NSString *cellIdentifier = @"MyApplicationCell";
AppDelegate *appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.applicationRecords = [[NSMutableArray alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self.view addSubview:_loadingView];
    
    [_dataLoadingIndicator startAnimating];
    
    [_loadingView setHidden:YES];
    [self.tableView reloadData];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _loadingView.clipsToBounds = YES;
    _loadingView.layer.cornerRadius = 10.0;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = CGRectMake(65, 40, _activityView.bounds.size.width, _activityView.bounds.size.height);
    [_loadingView addSubview:_activityView];
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.adjustsFontSizeToFitWidth = YES;
    _loadingLabel.textAlignment= NSTextAlignmentCenter;
    _loadingLabel.text = @"Loading...";
    [_loadingView addSubview:_loadingLabel];
    
    [self.view addSubview:_loadingView];
    [_activityView startAnimating];
    
    // Load the old application Objects from file
    NSString *fileName = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        [self loadOldData:fileName];
    }
    
    // Refresh the new objects
    [self parseJSONData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self terminatePendingDownloading];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger node = [self.applicationRecords count];
    if(node == 0)
    {
        return  1;
    }
    return node;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationCell *cell = nil;
    NSUInteger nodeCount = [self.applicationRecords count];
    
    if(indexPath.row == 0 && nodeCount == 0)
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.appLabelName.text = @" ";
        cell.detailLabel.text = @"";
    }
    else
    {
        [_activityView stopAnimating];
        [_loadingView removeFromSuperview];
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        ApplicationData *appObject = self.applicationRecords[indexPath.row];
        cell.isDecelerating = self.tableView.decelerating;
        cell.isDragging = self.tableView.dragging;
        [cell setApplicationData:appObject forIndexPath:indexPath];
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];
    
    ApplicationData *appObject = self.applicationRecords[indexPath.row];
    detailViewController.appRecord = appObject;
    detailViewController.appRecords = self.applicationRecords;
    detailViewController.currentIndex = indexPath;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)loadIconForOnScreenRows
{
    [self.tableView reloadData];
}

#pragma mark - ScrollingDelegates
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self loadIconForOnScreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadIconForOnScreenRows];
}

- (void)terminatePendingDownloading
{
    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopDownloading" object:imageDownloader];
}

#pragma mark - ParseDelegate
- (void)parseJSONData
{
    dispatch_async(queue ,^{
        NSData *iTuneApplicationData = [NSData dataWithContentsOfURL:JSONURL];
        _applicationRecords = [[iTuneDataManager alloc] populateApplicationInformationFromData:iTuneApplicationData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - load old application records
- (void)loadOldData:(NSString *)fileName
{
    dispatch_async(queue, ^{
        _applicationRecords = [[iTuneDataManager alloc] loadApplicationRecordsFromFile:fileName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)dealloc
{
    [self terminatePendingDownloading];
}

@end
