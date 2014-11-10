




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
#import "ApplicationObject.h"
#import "ApplicationCell.h"
#import "iTuneStoreObject.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define iTuneJSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]




@interface ViewController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) iTuneStoreObject *storeObject;
@property(nonatomic, strong) NSMutableDictionary *appIconsPath;
@end

@implementation ViewController

NSData *iTuneApplicationData;
bool fileExists;
NSString *fileName;
NSString *dictSavedFilePath;
AppDelegate *appDelegate;

UIImage *largeImage ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    
    _appIconsPath = [[NSMutableDictionary alloc] init];
    
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
    
    [self.view addSubview:_loadingView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [_dataLoadingIndicator startAnimating];
    
    _storeObject = [[iTuneStoreObject alloc] initWithJsonData: nil];
    [_dataLoadingIndicator stopAnimating];
    [_loadingView setHidden:YES];
    
    if (_storeObject.applicationObjects.count == 0)
    {
        // code for online fetch
        dispatch_async(queue ,^{
            iTuneApplicationData = [NSData dataWithContentsOfURL:iTuneJSONURL];
            [self parseJSONData:iTuneApplicationData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_dataLoadingIndicator stopAnimating];
                [_loadingView setHidden:YES];
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
    return [_storeObject.applicationObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    ApplicationCell * cell = [[ApplicationCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                                    reuseIdentifier: cellIdentifier];
    cell.imageView.image = [UIImage imageNamed:@"icon_placeholder.png"];
    
    ApplicationObject *appObject = _storeObject.applicationObjects[indexPath.row];
    cell.applicationObject = appObject;
    
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];
    
    ApplicationObject *appObject = _storeObject.applicationObjects[indexPath.row];
    detailViewController.applicationObject = appObject;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

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
            _storeObject = [[iTuneStoreObject alloc] initWithJsonData:jsonData];
        }
    }
}

@end
