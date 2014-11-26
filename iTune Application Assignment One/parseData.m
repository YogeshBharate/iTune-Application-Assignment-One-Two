//
//  iTuneStoreObject.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "parseData.h"
#import "ApplicationData.h"
#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation parseData

-(instancetype) initWithJsonData:(NSDictionary *)jsonData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    self = [super init];
    
    if(self)
    {
        if(jsonData)
        {
            NSDictionary * feed = jsonData[@"feed"];
            NSArray * itemsArray = feed[@"entry"];
            
            _applicationObjects = [NSMutableArray array];
            for (NSDictionary * itemDict in itemsArray)
            {
                ApplicationData * appObject = [[ApplicationData alloc] initWithJsonData: itemDict];
                [_applicationObjects addObject: appObject];
            }
            
            NSString *storedAppObjectInFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
            BOOL status = [NSKeyedArchiver archiveRootObject:_applicationObjects toFile:storedAppObjectInFile];
            if(!status)
            {
                NSLog(@"Failured to Archive");
            }
        }
        else
        {
            NSString *loadApplicationObjectFromFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
            
            _applicationObjects = [NSKeyedUnarchiver unarchiveObjectWithFile:loadApplicationObjectFromFile];
        }
    }
    return self;
}



@end
