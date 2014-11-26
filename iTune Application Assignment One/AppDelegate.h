//
//  AppDelegate.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *iconDictionary;
@property (strong, nonatomic) NSMutableDictionary *imageDictionary;
@property (strong, nonatomic) NSString *documentDirectoryPath;
@property (nonatomic, assign) BOOL hasInternetConnection ;

@end