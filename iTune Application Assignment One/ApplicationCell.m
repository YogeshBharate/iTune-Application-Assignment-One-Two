//
//  ApplicationCell.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ApplicationCell.h"
#import "ApplicationObject.h"
#import "AppDelegate.h"

#define kAppNameLabel_Font         [UIFont fontWithName: @"HelveticaNeue" size: 14.0]

#define kAppIcon_Margin_L          10.0
#define kAppNameLabel_Margin_L     10.0
#define queueForSavingAppIcons dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)



@interface ApplicationCell()
@property(nonatomic, strong) UILabel *appLabelName;
@property(nonatomic, strong) IBOutlet UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *appIcon;


@end


@implementation ApplicationCell

// Application icon directory variables
NSURL *documentsDirectoryForAppIcons;
NSFileManager *appIconFileManager;
NSURL *destinationUrlForAppIcons;
UIImage *downloadAppIcons;
AppDelegate *appDelgate;
NSURLSessionDownloadTask *downloadTask;

- (id)initWithStyle: (UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    appDelgate = [[UIApplication sharedApplication] delegate];
    [self createDirectoryToStoredAppIcons];
    
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
        
        _appLabelName = [[UILabel alloc] initWithFrame: CGRectZero];
        _appLabelName.numberOfLines = 0;
        [_appLabelName setFont: kAppNameLabel_Font];
        [self.contentView addSubview: _appLabelName];
        
        _detailLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        [self.contentView addSubview:_detailLabel];
        
        _appIcon = [[UIImageView alloc] initWithFrame: CGRectZero];
        [_appIcon setBackgroundColor: [UIColor lightGrayColor]];
        [self.contentView addSubview: _appIcon];
    }
    return self;
}

-(void)refreshViews
{
    self.appLabelName.text = _applicationObject.name;
    self.appLabelName.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    self.detailTextLabel.text = _applicationObject.artistName;
    self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    
    NSString *appIconStoredPath = [appDelgate.saveAppIconURLAndPathInFile valueForKey:_applicationObject.iconURL];
    _appIcon.image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    
    if(!_appIcon.image && appDelgate.hasInternetConnection)
    {
        [self downloadAppIcons];
    }
}

-(void)setApplicationObject:(ApplicationObject *)appObject
{
    _applicationObject = appObject;
    [self refreshViews];
}

-(void)layoutSubviews
{
    
    CGRect contentViewFrame = self.contentView.frame;
    CGFloat imageHeight = 52;
    CGRect appIconFrame = _appIcon.frame;
    appIconFrame.origin.x = kAppIcon_Margin_L;
    appIconFrame.origin.y = (CGRectGetHeight(contentViewFrame) - imageHeight)/2;
    appIconFrame.size = CGSizeMake(50, 50);
    _appIcon.frame = appIconFrame;
    
    CGRect appNameLabelFrame = _appLabelName.frame;
    appNameLabelFrame.origin.x = CGRectGetMaxX(appIconFrame) + kAppNameLabel_Margin_L;
    appNameLabelFrame.origin.y = 10;
    appNameLabelFrame.size.width = CGRectGetWidth(contentViewFrame) - CGRectGetMaxX(appIconFrame) - (2*kAppNameLabel_Margin_L);
    appNameLabelFrame.size.height = CGRectGetHeight(contentViewFrame)/2 - 10;
    _appLabelName.frame = appNameLabelFrame;
    
    CGRect appDetailLabelFrame = _detailLabel.frame;
    appDetailLabelFrame.origin.x=CGRectGetMaxX(appIconFrame) + kAppNameLabel_Margin_L;
    appDetailLabelFrame.origin.y=CGRectGetHeight(appNameLabelFrame)+10;
    appDetailLabelFrame.size.width = CGRectGetWidth(contentViewFrame) - CGRectGetMaxX(appIconFrame) - (2*kAppNameLabel_Margin_L);
    appDetailLabelFrame.size.height = CGRectGetHeight(contentViewFrame)/2-10;
    _detailLabel.frame = appDetailLabelFrame;
    
}

-(UILabel *)detailTextLabel
{
    return self.detailLabel;
}

-(void)downloadAppIcons
{
    NSURL *downloadURL = [NSURL URLWithString:_applicationObject.iconURL];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    __weak  ApplicationCell* weakSelf = self;
    
    dispatch_async(queueForSavingAppIcons, ^{
        
        downloadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL *location,  NSURLResponse *respone, NSError *error)
              {
                  NSString *iconName = [location lastPathComponent];
                  NSMutableString *changeIconName = [[NSMutableString alloc] init];
                  
                  changeIconName = [iconName mutableCopy];
                  
                  NSLog(@"change Icon : %@", changeIconName);
                  
                  [changeIconName setString:_applicationObject.bundleId];
                  
                  NSString *appIconDirectory = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
                
                  destinationUrlForAppIcons = [[NSURL URLWithString:appIconDirectory] URLByAppendingPathComponent:changeIconName];
                  
                  NSError *error1;
                  
                  if([appIconFileManager fileExistsAtPath:[destinationUrlForAppIcons absoluteString]])
                  {
                      [appIconFileManager removeItemAtPath:[destinationUrlForAppIcons absoluteString] error:NULL];
                  }

                  BOOL status = [appIconFileManager copyItemAtURL:location toURL:destinationUrlForAppIcons error:&error1];
                  if (status && !error1)
                      {
                          [appDelgate.saveAppIconURLAndPathInFile setValue:destinationUrlForAppIcons.path forKey:_applicationObject.iconURL];
                          dispatch_async(dispatch_get_main_queue(), ^{
                          [weakSelf refreshViews];
                          });
                          NSString *dictSavedFilePath = [appDelgate.documentDirectoryPath stringByAppendingPathComponent:@"IconURLsAndPaths.plist"];
                          
                          dispatch_async(queueForSavingAppIcons, ^{
                          [appDelgate.saveAppIconURLAndPathInFile writeToFile:dictSavedFilePath atomically:YES];
                          });
                          NSLog(@"dictionary : %@", appDelgate.saveAppIconURLAndPathInFile);
                      }
                  
              }];
        [downloadTask resume];
    });
}

-(void)createDirectoryToStoredAppIcons
{
    NSError *error;
    
    appIconFileManager = [NSFileManager defaultManager];
    
    NSArray *urls = [appIconFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    documentsDirectoryForAppIcons = [urls objectAtIndex:0];
    
    NSString *appIconPath = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
    
    NSURL * appIconURLPath = [NSURL URLWithString:appIconPath];
    
    if(![appIconFileManager createDirectoryAtURL:appIconURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
        NSLog(@"AppIconDirectory Creating error : %@", error);
    }
}

//-(void)dealloc
//{
//    [downloadTask cancel];
//}

@end
