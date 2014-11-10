//
//  ApplicationObject.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#ifndef iTune_Application_Assignment_One_ApplicationObject_h
#define iTune_Application_Assignment_One_ApplicationObject_h

@interface  ApplicationObject : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *URLLink;
@property (nonatomic, strong) NSString *rights;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *bundleId;



-(instancetype)initWithJsonData:(NSDictionary *)jsonData;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

@end


#endif
