//
//  AppDelegate.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "AppDelegate.h"
#import "iTuneDataManager.h"

@implementation AppDelegate

Reachability *reachability;
NSString *iconDictionaryPath;
NSString *detailViewImageDictionaryPath;
NSString *availableNetwork;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpReachability];
    
    _documentDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    iconDictionaryPath = [_documentDirectoryPath stringByAppendingPathComponent:@"IconDictionary.plist"];
    _iconDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:iconDictionaryPath];
    
    detailViewImageDictionaryPath = [_documentDirectoryPath stringByAppendingPathComponent:@"ImageDictionary.plist"];
    _imageDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:detailViewImageDictionaryPath];
   
    if(!_iconDictionary)
    {
        _iconDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if(!_imageDictionary)
    {
        _imageDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_iconDictionary writeToFile:iconDictionaryPath atomically:YES];
    [_imageDictionary writeToFile:detailViewImageDictionaryPath atomically:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_iconDictionary writeToFile:iconDictionaryPath atomically:YES];
    [_imageDictionary writeToFile:detailViewImageDictionaryPath atomically:YES];
}

- (void)setUpReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        self.hasInternetConnection = NO;
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        self.hasInternetConnection = YES;
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        self.hasInternetConnection = YES;
    }
    
    if(!self.hasInternetConnection)
    {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"No network" message:@"Loading data offline..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [networkAlert show];
    }
}

- (void)handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    NSString *availableNetwork ;
    
    if(remoteHostStatus == NotReachable)
    {
        self.hasInternetConnection = NO;
        availableNetwork = @"No network";
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        self.hasInternetConnection = YES;
        availableNetwork = @"Wifi";
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
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