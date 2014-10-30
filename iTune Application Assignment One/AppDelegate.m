//
//  AppDelegate.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
Reachability *reachability ;
NSString *availableNetwork ;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpReachability];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        self.hasInternet = NO;
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
        self.hasInternet = YES;
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        self.hasInternet = YES;
    }
    
    
    if(!self.hasInternet)
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
        self.hasInternet = NO;
        availableNetwork = @"No network";
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
        self.hasInternet = YES;
        availableNetwork = @"Wifi";
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        self.hasInternet = YES;
        availableNetwork = @"WAN";
    }
    
    if(self.hasInternet)
    {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Available Network" message:[NSString stringWithFormat:@"%@ is available", availableNetwork] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [networkAlert show];
    }
}

@end

@implementation ApplicationData

//struct appData
//{
//    NSMutableArray *applicationNames ;
//    NSMutableArray *applicationIconURLs ;
//    NSMutableArray *applicationImageURLs;
//    NSMutableArray *applicationArtistNames ;
//    NSMutableArray *applicationPrices;
//    NSMutableArray *applicationReleaseDates;
//    NSMutableArray *applicationCategories;
//    NSMutableArray *applicationUrlLinks;
//    NSMutableArray *applicationRights;
//};

@end
