//
//  ApplicationCell.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#ifndef iTune_Application_Assignment_One_ApplicationCell_h
#define iTune_Application_Assignment_One_ApplicationCell_h
#import "ApplicationData.h"

@class ApplicationData;
@interface ApplicationCell : UITableViewCell
@property (nonatomic, strong) ApplicationData * applicationData;
@property (nonatomic) BOOL isScrolling;
@property (nonatomic) BOOL isDecelerating;
@property (nonatomic) BOOL isDragging;

-(void)setApplicationData:(ApplicationData *)applicationData forIndexPath:(NSIndexPath *)indexPath;
@end
#endif
