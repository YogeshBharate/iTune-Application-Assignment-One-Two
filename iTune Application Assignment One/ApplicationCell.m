//
//  ApplicationCell.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ApplicationCell.h"
#import "ApplicationData.h"
#import "AppDelegate.h"
#import "ImageDownloader.h"

#define kAppNameLabel_Font         [UIFont fontWithName: @"Helvetica-Bold" size: 17.0]
#define kAppNameSubtitle_Font         [UIFont fontWithName: @"Helvetica" size: 14.0]
#define kAppIcon_Margin_L          10.0
#define kAppNameLabel_Margin_L     10.0
#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@class ImageDownloader;
@interface ApplicationCell()

@property(nonatomic, strong) UILabel *appLabelName;
@property(nonatomic, strong) IBOutlet UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *appIcon;
@property(copy) void (^sessionCompletionHandler)();
@property(nonatomic, strong) ImageDownloader *imageDownloader;
@property(nonatomic, strong) ApplicationData *appData;
@property(nonatomic, strong) UITableView *parentTableView;
@property(nonatomic, strong) NSMutableDictionary *downloadInProgress;
@property(strong) NSIndexPath *indexPath;
@property(nonatomic, strong) NSURL *destinationUrlForAppIcons;

@end

@implementation ApplicationCell

AppDelegate *appDelgate;

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
        [_detailLabel setFont: kAppNameSubtitle_Font];
        [self.contentView addSubview:_detailLabel];
        
        _appIcon = [[UIImageView alloc] initWithFrame: CGRectZero];
        [_appIcon setBackgroundColor: [UIColor lightGrayColor]];
        [self.contentView addSubview: _appIcon];
    }
    return self;
}

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

-(void)refreshViews
{
    __weak ApplicationCell *weak = self;
    
    self.appLabelName.text = _appData.name;
    self.detailTextLabel.text = _appData.artistName;
    
    NSString *appIconStoredPath = [appDelgate.iconDictionary valueForKey:_appData.iconURL];
    UIImage *image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    
    if(!image && appDelgate.hasInternetConnection )
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
                [_imageDownloader startDownloadingIcon:_appData.iconURL saveAs:_appData.name isIcon:YES];
            }
    }
    else if(image)
    {
        self.appIcon.image = image;
    }
    else if(!appDelgate.hasInternetConnection)
    {
        self.appIcon.image = [UIImage imageNamed:@"image_loading.png"];
    }
}

-(void)didMoveToSuperview
{
    if(self.superview)
    {
        self.parentTableView = [self findParentTableView];
    }
}

-(void)setApplicationData:(ApplicationData *)applicationData forIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.appData = applicationData;
    [self refreshViews];
}

-(void)layoutSubviews
{
    CGRect contentViewFrame = self.contentView.frame;
    CGFloat imageHeight = 44;
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

-(void)createDirectoryToStoredAppIcons
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

