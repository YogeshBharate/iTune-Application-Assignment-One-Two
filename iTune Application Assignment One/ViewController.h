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

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *dataLoadingIndicator;
@property (strong, nonatomic) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;

-(NSString *)createJSONFile;
-(void)downloadAppsIcon:(NSString *)url appName:(NSString *)labelName;
-(void)downloadApplicationImages:(NSString*)appImageURL appName:(NSString *)labelName;
-(void)createAppIconsDirectory;
-(void)createAppImageDirectory;
-(NSString *)removeSpecialCharactersFromFileName:(NSString *) fileName;

@end
