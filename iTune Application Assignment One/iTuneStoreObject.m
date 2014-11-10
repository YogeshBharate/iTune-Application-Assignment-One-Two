//
//  iTuneStoreObject.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "iTuneStoreObject.h"
#import "ApplicationObject.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation iTuneStoreObject

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
                ApplicationObject * appObject = [[ApplicationObject alloc] initWithJsonData: itemDict];
                [_applicationObjects addObject: appObject];
            }
            
            NSString *storedAppObjectInFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"storedApplicationObjects.plist"];
            BOOL status = [NSKeyedArchiver archiveRootObject:_applicationObjects toFile:storedAppObjectInFile];
            if(!status)
            {
                NSLog(@"Failured to Archive");
            }
        }
        else
        {
            NSString *loadApplicationObjectFromFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"storedApplicationObjects.plist"];
            
            _applicationObjects = [NSKeyedUnarchiver unarchiveObjectWithFile:loadApplicationObjectFromFile];
            NSLog(@"load : %@", _applicationObjects);
        }
    }
    return self;
}



@end
