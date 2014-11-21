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

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DetailViewController ()

@end

@implementation DetailViewController

// Application Image directory variables
NSURL *documentDirectoryForAppImages;
NSFileManager * appImageFileManager;
NSURL *destinationUrlForAppImages;
UIImage *downloadAppImages;
AppDelegate *appDelegate;
UIImageView *animatedImageView;
NSURLSessionDownloadTask *downloadTask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (self) {
        // Custom initialization
    }
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)openURL:(id)sender
{
    UIWebView *webview = [[UIWebView alloc] init];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_applicationObject.URLLink]];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_applicationObject.URLLink]]];
}

-(void)setApplicationObject:(ApplicationData *)appObject
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
    _applicationObject = appObject;
    [self refreshViews];
}

-(void)refreshViews
{
    self.appName.text = _applicationObject.name;
    self.appArtistName.text = _applicationObject.artistName;
    self.appCategory.text = _applicationObject.category;
    
     [_appURLLink setTitle:_applicationObject.URLLink forState:UIControlStateNormal];
    
    self.appRights.text = _applicationObject.rights;
    self.appReleaseDate.text = _applicationObject.releaseDate;
    self.appPrice.text = _applicationObject.price;
    
    
    NSString *appIconStoredPath = [appDelegate.saveAppImageURLAndPathInFile valueForKey:_applicationObject.imageURL];
    _appImage.image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    
    if(_appImage.image)
    {
            [animatedImageView stopAnimating];
    }
    else if(!_appImage.image && appDelegate.hasInternetConnection)
    {
        [self downloadAppImages];
    }
    else if(!appDelegate.hasInternetConnection && !_appImage.image)
    {
        _appImage.image = [UIImage imageNamed:@"no_internet_connection.png"];
        [animatedImageView stopAnimating];
    }
}



-(void)downloadAppImages
{
    NSURL *downloadURL = [NSURL URLWithString:_applicationObject.imageURL];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    __weak  DetailViewController* weakSelf = self;
    
    dispatch_async(queue, ^{
        
        downloadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL *location,  NSURLResponse *respone, NSError *error)
              {
                  NSString *iconName = [location lastPathComponent];
                  NSMutableString *changeIconName = [[NSMutableString alloc] init];
                  
                  changeIconName = [iconName mutableCopy];
                  
                  [changeIconName setString:_applicationObject.bundleId];
                  
                  NSString *appIconDirectory = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
                  
                  destinationUrlForAppImages = [[NSURL URLWithString:appIconDirectory] URLByAppendingPathComponent:changeIconName];
                  
                  NSError *error1;
                  
                  if([appImageFileManager fileExistsAtPath:[destinationUrlForAppImages absoluteString]])
                  {
                      [appImageFileManager removeItemAtURL:destinationUrlForAppImages error:NULL];
                  }
                  
                  BOOL status = [appImageFileManager copyItemAtURL:location toURL:destinationUrlForAppImages error:&error1];
                  if (status && !error1) {
                      [appDelegate.saveAppImageURLAndPathInFile setValue:destinationUrlForAppImages.path forKey:_applicationObject.imageURL];
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [weakSelf refreshViews];
                                  [animatedImageView stopAnimating];
                      });
                      
                      dispatch_async(queue, ^{
                          NSString *imageDictionaryStoredFilePath = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ImageDictionary.plist"];
                          
                          [appDelegate.saveAppImageURLAndPathInFile writeToFile:imageDictionaryStoredFilePath atomically:YES];
                      });
                  }
                  
              }];
        [downloadTask resume];
    });
}

-(void)createDirectoryToStoredAppImages
{
    NSError *error;
    appImageFileManager = [NSFileManager defaultManager];
    
    NSArray *urls = [appImageFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    documentDirectoryForAppImages = [urls objectAtIndex:0];
    
    NSString *appImagePath = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
    
    NSURL *appImageURLPath = [NSURL URLWithString:appImagePath];
    
    if(![appImageFileManager createDirectoryAtURL:appImageURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
        NSLog(@"Error while creating appImages directory : %@", error);
    }
}

-(void)dealloc
{
    [downloadTask cancel];
}

@end
