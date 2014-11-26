//
//  iTuneStoreObject.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterViewController.h"

@interface iTuneDataManager : NSObject

- (NSMutableArray *)populateApplicationInformationFromData:(NSData *)iTuneData;

@end
