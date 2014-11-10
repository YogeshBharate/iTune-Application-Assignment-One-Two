//
//  ApplicationCell.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#ifndef iTune_Application_Assignment_One_ApplicationCell_h
#define iTune_Application_Assignment_One_ApplicationCell_h
#import "ApplicationObject.h"

@class ApplicationObject;
@interface ApplicationCell : UITableViewCell
@property (nonatomic, strong) ApplicationObject * applicationObject;

@end
#endif
