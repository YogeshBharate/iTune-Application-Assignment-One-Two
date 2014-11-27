//
//  appDetailViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 29/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "AppDelegate.h"
#import "ApplicationData.h"
#import "ImageDownloader.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@class ImageDownloader;

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *appImage;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appArtistName;
@property (weak, nonatomic) IBOutlet UILabel *appCategory;
@property (weak, nonatomic) IBOutlet UILabel *appReleaseDate;
@property (weak, nonatomic) IBOutlet UILabel *appPrice;
@property (weak, nonatomic) IBOutlet UILabel *appRights;
@property (weak, nonatomic) IBOutlet UIButton *appURLLink;
@property (strong, nonatomic) ImageDownloader *imageDownloader;

@end

@implementation DetailViewController

// Application Image directory variables
AppDelegate *appDelegate;
UIImageView *animatedImageView;
NSURLSessionDownloadTask *downloadTask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        appDelegate = [[UIApplication sharedApplication] delegate];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDirectoryToStoredAppImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openURL:(id)sender
{
    UIWebView *webview = [[UIWebView alloc] init];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appRecord.link]];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_appRecord.link]]];
}

- (void)setAppRecord:(ApplicationData *)appObject
{
    animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 70, 232, 181)];
    
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"frame_010"],
                                         [UIImage imageNamed:@"frame_011"],
                                         [UIImage imageNamed:@"frame_012"],
                                         [UIImage imageNamed:@"frame_013"],
                                         [UIImage imageNamed:@"frame_014"],
                                         [UIImage imageNamed:@"frame_015"],
                                         [UIImage imageNamed:@"frame_016"],
                                         [UIImage imageNamed:@"frame_017"],
                                         [UIImage imageNamed:@"frame_018"],
                                         [UIImage imageNamed:@"frame_019"],
                                         [UIImage imageNamed:@"frame_020"],
                                         nil];
    
    animatedImageView.animationDuration=1.0f;
    animatedImageView.animationRepeatCount=0;
    
    [animatedImageView startAnimating];
    [self.view addSubview:animatedImageView ];
    
    _appRecord = appObject;
    [self refreshViews];
}

- (void)refreshViews
{
    __weak DetailViewController *weak = self;
    self.appName.text = _appRecord.name;
    self.appArtistName.text = _appRecord.artistName;
    self.appCategory.text = _appRecord.category;
    
    [_appURLLink setTitle:_appRecord.link forState:UIControlStateNormal];
    
    self.appRights.text = _appRecord.rights;
    self.appReleaseDate.text = _appRecord.releaseDate;
    self.appPrice.text = _appRecord.price;
    
    NSString *appIconStoredPath = [appDelegate.imageDictionary valueForKey:_appRecord.detailViewImageURL];
    _appImage.image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    
    if(_appImage.image)
    {
            [animatedImageView stopAnimating];
    }
    else if(!_appImage.image && appDelegate.hasInternetConnection)
    {
        if(self.imageDownloader == nil)
        {
            self.imageDownloader = [[ImageDownloader alloc] init];
            self.imageDownloader.appData = self.appRecord;
        
            self.imageDownloader.completionHandler = ^(NSURL *localPath) {
                UIImage *image = [UIImage imageWithContentsOfFile:localPath.path];
                if(image)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [animatedImageView stopAnimating];
                    weak.appImage.image = image;
                    });
                }
            };
        }
        [self.imageDownloader startDownloading:_appRecord.detailViewImageURL saveAs:_appRecord.name isIcon:NO];
    }
    else if(!appDelegate.hasInternetConnection && !_appImage.image)
    {
        _appImage.image = [UIImage imageNamed:@"no_internet_connection.png"];
        [animatedImageView stopAnimating];
    }
}

- (void)createDirectoryToStoredAppImages
{
    NSError *error;
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectoryForAppImages = [urls objectAtIndex:0];
    
    NSString *appImagePath = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
    
    NSURL *appImageURLPath = [NSURL URLWithString:appImagePath];
    
    if(![[NSFileManager defaultManager] createDirectoryAtURL:appImageURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
//        NSLog(@"Error while creating appImages directory : %@", error);
    }
}

- (void)dealloc
{
    [downloadTask cancel];
}

@end
