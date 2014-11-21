//
//  appDetailViewController.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 29/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationData;
@interface DetailViewController : UIViewController

@property (nonatomic, strong) ApplicationData * applicationObject;
@property (weak, nonatomic) IBOutlet UIImageView *appImage;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appArtistName;
@property (weak, nonatomic) IBOutlet UILabel *appCategory;
@property (weak, nonatomic) IBOutlet UILabel *appReleaseDate;
@property (weak, nonatomic) IBOutlet UILabel *appPrice;
@property (weak, nonatomic) IBOutlet UILabel *appRights;
@property (weak, nonatomic) IBOutlet UIButton *appURLLink;


- (IBAction)openURL:(id)sender;

@end
