//
//  appDetailViewController.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 29/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appDetailViewController : UIViewController
{
    NSString *imageDetails  ;
    NSString *labelDetails  ;
    NSString *artistDetails ;
    NSString *categoryDetails ;
    NSString *releaseDateDetails;
    NSString *priceDetails  ;
    NSString *rightsDetails ;
    NSString *linkDetails ;
}
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightsLabel;

@property IBOutlet UIButton *linkButton ;


- (IBAction)openURL:(id)sender;

-(void)setText:(NSString *)labelText ;
-(void)setImage:(NSString *)imageIcon ;
-(void)setArtistName:(NSString *)artistLabel;
-(void)setCategoryName:(NSString *)categoryLabel;
-(void)setReleaseDate:(NSString *)releaseDateLabel;
-(void)setPrice:(NSString *)priceLabel;
-(void)setRight:(NSString *)rightLabel;
-(void)setlink:(NSString *)linkLabel ;



@end
