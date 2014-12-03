//
//  ApplicationCell.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ApplicationCell.h"
//#import "ApplicationData.h"
#import "AppDelegate.h"
#import "ImageDownloader.h"

@class ImageDownloader;
@interface ApplicationCell()

@property(copy) void (^sessionCompletionHandler)();
@property(nonatomic, strong) ImageDownloader *imageDownloader;
@property(nonatomic, strong) ApplicationData *appData;
@property(nonatomic, strong) UITableView *parentTableView;
@property(nonatomic, strong) NSMutableDictionary *downloadInProgress;
@property(strong) NSIndexPath *indexPath;
@property(nonatomic, strong) NSURL *destinationUrlForAppIcons;

@end

@implementation ApplicationCell

AppDelegate *appDelegate;
   
- (UITableView *)findParentTableView
{
    UITableView *tableView = nil;
    UIView *view = self;
    while (view!=nil)
    {
        if([view isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView *)view;
        }
        view = [view superview];
    }
    return  tableView;
}

- (void)refreshViews
{
    __weak ApplicationCell *weak = self;
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *iconLocalPath = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"appIcons"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:iconLocalPath])
    {
        [self createDirectoryToStoreAppIcons];
    }
    
    self.appLabelName.text = _appData.name;
    self.detailLabel.text = _appData.artistName;
    self.appIcon.image = [UIImage imageNamed:@"placeholder_image.png"];

    NSString *appIconStoredPath = [appDelegate.iconDictionary valueForKey:_appData.iconURL];
    UIImage *image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    
    if(!image && appDelegate.hasInternetConnection )
    {
            if(_isDecelerating == NO && _isDragging == NO)
            {
                if(_imageDownloader == nil)
                {
                    _imageDownloader = [[ImageDownloader alloc] init];
                    _imageDownloader.appData = self.appData;
                    
                    _imageDownloader.completionHandler = ^(NSURL *localPath){
                        dispatch_async(dispatch_get_main_queue(), ^{
                        weak.appIcon.image = [UIImage imageWithContentsOfFile:localPath.path];
                        [weak.parentTableView reloadData];
                        });
                    };
                }
                [_imageDownloader startDownloading:_appData.iconURL saveAs:_appData.name isIcon:YES];
            }
    }
    else if(image)
    {
        self.appIcon.image = image;
    }
    else if(!appDelegate.hasInternetConnection)
    {
        self.appIcon.image = [UIImage imageNamed:@"image_loading.png"];
    }
}

- (void)didMoveToSuperview
{
    if(self.superview)
    {
        self.parentTableView = [self findParentTableView];
    }
}

- (void)setApplicationData:(ApplicationData *)applicationData forIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.appData = applicationData;
    [self refreshViews];
}

- (void)createDirectoryToStoreAppIcons
{
    NSError *error;
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentsDirectoryForAppIcons = [urls objectAtIndex:0];
    
    NSString *appIconPath = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
    
    NSURL * appIconURLPath = [NSURL URLWithString:appIconPath];
    
    if(![[NSFileManager defaultManager] createDirectoryAtURL:appIconURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
//        NSLog(@"AppIconDirectory Creating error : %@", error);
    }
}

@end

