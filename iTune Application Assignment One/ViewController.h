//
//  ViewController.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(NSString *) dataFilePath ;
-(void)readPlist ;
-(void)writePlist ;
-(BOOL)isConnected;
@end
