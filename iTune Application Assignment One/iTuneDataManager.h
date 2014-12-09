//
//  iTuneStoreObject.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iTuneDataManager : NSObject <NSKeyedArchiverDelegate, NSKeyedUnarchiverDelegate>

@property (nonatomic, strong) NSMutableArray *appNames;

- (NSMutableArray *)populateApplicationInformationFromData:(NSData *)iTuneData;
- (NSMutableArray *)loadApplicationRecordsFromFile:(NSString *)fileName;
- (NSMutableArray *)applicationNames;

@end
