//
//  appDetailViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 29/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "appDetailViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"


@interface appDetailViewController ()

@end

@implementation appDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIImageView *animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 70, 232, 181)];
    
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"frame_010"],
                                         [UIImage imageNamed:@"frame_011"],
                                         [UIImage imageNamed:@"frame_012"],
                                         [UIImage imageNamed:@"frame_013"],
                                         [UIImage imageNamed:@"frame_014"],
                                         [UIImage imageNamed:@"frame_015"],
                                         [UIImage imageNamed:@"frame_016"],
                                         [UIImage imageNamed:@"frame_017"],
                                         [UIImage imageNamed:@"frame_018"],
                                         [UIImage imageNamed:@"frame_019"],
                                         [UIImage imageNamed:@"frame_020"],
                                         nil];
    
    animatedImageView.animationDuration=1.0f;
    animatedImageView.animationRepeatCount=0;
    [animatedImageView startAnimating];
    [self.view addSubview:animatedImageView ];

    // Set the image here
    if(appDelegate.hasInternet)
    {
        // Load the online images
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *appImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageDetails]]];
        dispatch_async(dispatch_get_main_queue(),^{
            [animatedImageView stopAnimating];
            _bigImage.image = appImage;
            });
        });
    }
    else
    {
        // Load the offline image
        [animatedImageView stopAnimating];
        _bigImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:offlineImage]];
        NSLog(@"Path2 : %@",offlineImage);
    }
    
    _bigLabel.text  = labelDetails ;
    
    _artistLabel.text = artistDetails ;
    
    _categoryLabel.text = categoryDetails ;
    
    _releaseDateLabel.text = releaseDateDetails ;
    
    _priceLabel.text = priceDetails ;
    
    _linkLabel.text = linkDetails ;
    
    [_linkButton setTitle:linkDetails forState:UIControlStateNormal];
    
    _rightsLabel.text = rightsDetails ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openURL:(id)sender
{
    UIWebView *webview = [[UIWebView alloc] init];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkDetails]];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkDetails]]];  
}

-(void)setText:(NSString *)labelText
{
    labelDetails = labelText;
}

-(void) setImage:(NSString *)imageIcon
{
    imageDetails = imageIcon;
    
}

-(void) setArtistName:(NSString *)artistLabel
{
    artistDetails = artistLabel ;
}

-(void)setCategoryName:(NSString *)categoryLabel
{
    categoryDetails = categoryLabel ;
}

-(void)setReleaseDate:(NSString *)releaseDateLabel
{
    releaseDateDetails = releaseDateLabel ;
}

-(void)setPrice:(NSString *)priceLabel
{
    priceDetails = priceLabel ;
}

-(void)setRight:(NSString *)rightLabel
{
    rightsDetails = rightLabel ;
}

-(void)setlink:(NSString *)linkLabel
{
    linkDetails = linkLabel ;
}

-(void)setOfflineImage:(NSURL *)imageURL
{
    offlineImage = imageURL;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
