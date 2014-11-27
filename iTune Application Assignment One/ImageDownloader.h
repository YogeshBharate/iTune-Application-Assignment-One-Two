//
//  NSObject+ImageDownloader.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 14/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApplicationCell;
@class ApplicationData;

@interface ImageDownloader : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) ApplicationCell *cell;
@property (strong, nonatomic) ApplicationData *appData;
@property (nonatomic, copy) void (^completionHandler)(NSURL *localPath);

- (void)startDownloading:(NSString *)iconURL saveAs:(NSString *)name isIcon:(BOOL)icon;
- (void)stopDownloading;

@end
