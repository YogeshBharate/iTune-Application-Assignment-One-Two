
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
#import "iTuneDataManager.h"
#import "ImageDownloader.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define JSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]

@class ApplicationCell;

@interface MasterViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) ApplicationCell *cell;

@end

@implementation MasterViewController

AppDelegate *appDelegate;
//UIImage *largeImage ;

static NSString *cellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.applicationRecords = [[NSMutableArray alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self.view addSubview:_loadingView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [_dataLoadingIndicator startAnimating];
    
    [_loadingView setHidden:YES];
    [self.tableView reloadData];

    // Parse json
    [self parseJSONData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self terminatePendingDownloading];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.applicationRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationCell * cell = [[ApplicationCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                                    reuseIdentifier: cellIdentifier];
    NSUInteger nodeCount = [self.applicationRecords count];
    
    if(nodeCount == 0 && indexPath.row == 0)
    {
     cell.textLabel.text = @"Loading...";
    }
    else
    {
       ApplicationData *appObject = self.applicationRecords[indexPath.row];
      
        if(nodeCount > 0)
        {
            cell.isDecelerating = self.tableView.decelerating;
            cell.isDragging = self.tableView.dragging;
            [cell setApplicationData:appObject forIndexPath:indexPath];
        }
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];
    
    ApplicationData *appObject = self.applicationRecords[indexPath.row];
    detailViewController.appRecord = appObject;
    
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
        [self loadIconForOnScreenRows];
        NSLog(@"scrollViewDidEndDragging");
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadIconForOnScreenRows];
}

-(void)terminatePendingDownloading
{
    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopDownloadingIcon" object:imageDownloader];
}

#pragma mark - ParseDelegate
- (void)parseJSONData
{
    if(appDelegate.hasInternetConnection)
    {
        dispatch_async(queue ,^{
            NSData *iTuneApplicationData = [NSData dataWithContentsOfURL:JSONURL];
            _applicationRecords = [[iTuneDataManager alloc] populateApplicationInformationFromData:iTuneApplicationData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
        
    }
}

-(void)dealloc
{
    [self terminatePendingDownloading];
}

@end
