//
//  NSObject+ImageDownloader.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 14/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ImageDownloader.h"
#import "ApplicationData.h"
#import "AppDelegate.h"

@class ApplicationData;
@class ApplicationCell;

@interface ImageDownloader()
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) NSMutableArray *downloadTasks;
@property (strong ,nonatomic) NSURLSession *session;
@end

@implementation ImageDownloader : NSObject

// Application icon directory variables
NSURL *documentsDirectoryForAppIcons;
NSFileManager *appIconFileManager;
NSURL *destinationUrlForAppIcons;
UIImage *downloadAppIcons;
AppDelegate *appDelgate;

-(void)startDownloadingIcon:(NSString *)iconURL saveAs:(NSString *)name
{
    self.fileName = name;
    self.iconURL = iconURL;
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = NO;
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    self.downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:iconURL]];

    [_downloadTask resume];
}

-(void)stopDownloadingIcon:(NSNotification *) notification
{
    [self.downloadTask cancel];
    [self.session invalidateAndCancel];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *trimmedString = [_fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *appIconDirectory = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
    NSURL* destinationUrlForAppIcon = [[NSURL URLWithString:appIconDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",trimmedString, @".png"]];
    
    NSError *error1;
    
    if([appIconFileManager fileExistsAtPath:[destinationUrlForAppIcon absoluteString]])
    {
        [appIconFileManager removeItemAtPath:[destinationUrlForAppIcon absoluteString] error:NULL];
    }
    
    BOOL status = [appIconFileManager copyItemAtURL:location toURL:destinationUrlForAppIcon error:&error1];
    if (status && !error1)
    {
        
        [appDelgate.downloadedIcons setValue:destinationUrlForAppIcon.path forKey:self.iconURL];
        
        if(self.completionHandler)
        {
            self.completionHandler(destinationUrlForAppIcon);
        }
    }
    else
    {
        NSLog(@"File copy failed: %@", [error1 localizedDescription]);
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        NSLog(@"Task %@ completed successfully", task);
    }
    else
    {
        NSLog(@"Task %@ completed with error : %@", task, [error localizedDescription]);
    }
    _downloadTask = nil;
}

-(void)dealloc
{
    [self.downloadTask cancel];
}

@end
