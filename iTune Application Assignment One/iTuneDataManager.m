//
//  iTuneStoreObject.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "iTuneDataManager.h"
#import "ApplicationData.h"
#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation iTuneDataManager

- (NSMutableArray *)populateApplicationInformationFromData:(NSData *)iTuneData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *applicationRecords = [NSMutableArray array];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:iTuneData options:kNilOptions error:nil];

    if(iTuneData)
    {
        NSDictionary * feed = jsonData[@"feed"];
        NSArray * entries = feed[@"entry"];
        
        for (NSDictionary *entry in entries)
        {
            ApplicationData * appObject = [[ApplicationData alloc] initWithJsonData:entry];
            [applicationRecords addObject: appObject];
        }
        
        NSString *storedAppObjectInFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
        
        BOOL status = [NSKeyedArchiver archiveRootObject:applicationRecords toFile:storedAppObjectInFile];
        
        if(!status)
        {
            NSLog(@"Failured to Archive");
        }
    }
    else
    {
        NSString *loadApplicationObjectFromFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
        
        applicationRecords = [NSKeyedUnarchiver unarchiveObjectWithFile:loadApplicationObjectFromFile];
    }
    
    return applicationRecords;
}

@end
