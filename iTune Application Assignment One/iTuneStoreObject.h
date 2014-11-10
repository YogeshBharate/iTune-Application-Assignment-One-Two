//
//  iTuneStoreObject.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface iTuneStoreObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) NSMutableArray *applicationObjects;

-(instancetype)initWithJsonData:(NSDictionary *)jsonData;

@end
