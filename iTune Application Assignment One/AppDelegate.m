//
//  AppDelegate.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
Reachability *reachability;

NSString *saveAppIconDictionaryPath;
NSString *saveAppImageDictionaryPath;

NSString *availableNetwork;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpReachability];
    
    _documentDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    saveAppIconDictionaryPath = [_documentDirectoryPath stringByAppendingPathComponent:@"IconDictionary.plist"];
    _downloadedIcons = [[NSMutableDictionary alloc] initWithContentsOfFile:saveAppIconDictionaryPath];
    
    saveAppImageDictionaryPath = [_documentDirectoryPath stringByAppendingPathComponent:@"ImageDictionary.plist"];
    _saveAppImageURLAndPathInFile = [[NSMutableDictionary alloc] initWithContentsOfFile:saveAppImageDictionaryPath];
    
    if(!_downloadedIcons)
    {
        _downloadedIcons = [[NSMutableDictionary alloc] init];
    }
    
    if(!_saveAppImageURLAndPathInFile)
    {
        _saveAppImageURLAndPathInFile = [[NSMutableDictionary alloc] init];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSString *dictSavedFilePath = [_documentDirectoryPath stringByAppendingPathComponent:@"IconDictionary.plist"];
    [_downloadedIcons writeToFile:dictSavedFilePath atomically:YES];
    NSLog(@"dictionary : %@", _downloadedIcons);
    
    NSString *imageDictSaveFilePath = [_documentDirectoryPath stringByAppendingPathComponent:@"ImageDictionary.plist"];
    [_saveAppImageURLAndPathInFile writeToFile:imageDictSaveFilePath atomically:YES];
    NSLog(@"dictionary 2: %@", _saveAppImageURLAndPathInFile);
    
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSString *imageDictSaveFilePath = [_documentDirectoryPath stringByAppendingPathComponent:@"ImageDictionary.plist"];
    [_saveAppImageURLAndPathInFile writeToFile:imageDictSaveFilePath atomically:YES];
    NSLog(@"dictionary 2: %@", _saveAppImageURLAndPathInFile);
    
}

-(void) setUpReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
        self.hasInternetConnection = NO;
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
        self.hasInternetConnection = YES;
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        self.hasInternetConnection = YES;
    }
    
    
    if(!self.hasInternetConnection)
    {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"No network" message:@"Loading data offline..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [networkAlert show];
    }
}

-(void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    NSString *availableNetwork ;
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
        self.hasInternetConnection = NO;
        availableNetwork = @"No network";
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
        self.hasInternetConnection = YES;
        availableNetwork = @"Wifi";
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        self.hasInternetConnection = YES;
        availableNetwork = @"WAN";
    }
    
    if(self.hasInternetConnection)
    {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Available Network" message:[NSString stringWithFormat:@"%@ is available", availableNetwork] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [networkAlert show];
    }
}

@end
