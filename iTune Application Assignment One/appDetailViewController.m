//
//  appDetailViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 29/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "appDetailViewController.h"
#import "ViewController.h"

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
    
    // Set the image here
    _bigImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageDetails]]];
    
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
