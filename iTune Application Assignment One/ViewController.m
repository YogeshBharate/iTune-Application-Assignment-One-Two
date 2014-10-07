#define iTuneBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define iTuneJSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]



//
//  ViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ViewController.h"
#import "appDetailViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

NSMutableArray *arrayOfLabelNames ;
NSMutableArray *arrayOfImageIconURL ;
NSMutableArray *arrayOfLargeImageURL;
NSMutableArray *arrayOfArtistName ;
NSMutableArray *arrayOfPrices;
NSMutableArray *arrayOfReleaseDate;
NSMutableArray *arrayOfCategory;
NSMutableArray *arrayOfLink;
NSMutableArray *arrayOfRights;
NSMutableArray *readArray;

UIImage *largeImage ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Allocated all array variables
    arrayOfLabelNames       = [[NSMutableArray alloc] init];
    arrayOfImageIconURL     = [[NSMutableArray alloc] init];
    arrayOfLargeImageURL    = [[NSMutableArray alloc] init];
    arrayOfArtistName       = [[NSMutableArray alloc] init];
    arrayOfPrices           = [[NSMutableArray alloc] init];
    arrayOfReleaseDate      = [[NSMutableArray alloc] init];
    arrayOfCategory         = [[NSMutableArray alloc] init];
    arrayOfLink             = [[NSMutableArray alloc] init];
    arrayOfRights           = [[NSMutableArray alloc] init];
    readArray               = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleIdentifier"];
  
        NSLog(@"Internet Connection is available");
    dispatch_async(iTuneBgQueue ,^{
        NSData *dataiTune = [NSData dataWithContentsOfURL:iTuneJSONURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchiTuneData:dataiTune];
        });
//        [self performSelectorOnMainThread:@selector(fetchiTuneData:) withObject:dataiTune waitUntilDone:YES];
    });
  
    [self.tableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfLabelNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleIdentifier = @"SimpleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
    
    UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrayOfImageIconURL objectAtIndex:indexPath.row]]]];
    
    cell.imageView.image = image1 ;
    cell.textLabel.text = [arrayOfLabelNames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;

    return cell ;
}

- (void) fetchiTuneData:(NSData *)responseData
{
    NSError *erroriTune;
    NSDictionary *jsoniTune = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&erroriTune];
    
    NSDictionary *feed = [jsoniTune objectForKey:@"feed"];
    
    NSArray  *entry = [feed objectForKey:@"entry"];
    for(NSDictionary *loop in entry)
    {
        NSDictionary *label = loop[@"im:name"];
        NSString *labelString = label[@"label"];
        [arrayOfLabelNames insertObject:labelString atIndex:[arrayOfLabelNames count]];
        
        // Fetch small Icon URLS
        NSArray *image = loop[@"im:image"];
        NSDictionary *firstLabel = [image objectAtIndex:0];
        NSString *imageURL = firstLabel[@"label"];
       [arrayOfImageIconURL insertObject:imageURL atIndex:[arrayOfImageIconURL count]];
 
        // Fetch largeImageURLs
        NSDictionary *largeImageURL = [image objectAtIndex:2];
        NSString *largeImageURLs = largeImageURL[@"label"];
        [arrayOfLargeImageURL insertObject:largeImageURLs atIndex:[arrayOfLargeImageURL count]];
        
        // Fetch artist names
        NSDictionary *artist = loop[@"im:artist"];
        NSString *artistString = artist[@"label"];
        [arrayOfArtistName insertObject:artistString atIndex:[arrayOfArtistName count]];
        
        // Fetch Category name
        NSDictionary *category = loop[@"category"];
        NSDictionary *attributes = category[@"attributes"];
        NSString *categoryString = attributes[@"label"];
        [arrayOfCategory insertObject:categoryString atIndex:[arrayOfCategory count]];

        // Fetch the releasing date
        NSDictionary *releaseDate = loop[@"im:releaseDate"];
        NSDictionary *attributesReleaseDate = releaseDate[@"attributes"];
        NSString *releaseDateString = attributesReleaseDate[@"label"];
        [arrayOfReleaseDate insertObject:releaseDateString atIndex:[arrayOfReleaseDate count]];
        
        NSDictionary *price = loop[@"im:price"];
        NSString *priceString = price[@"label"];
        [arrayOfPrices insertObject:priceString atIndex:[arrayOfPrices count]];
        
        NSDictionary *link = loop[@"link"];
        NSDictionary *linkAttributes = link[@"attributes"];
        NSString *href = linkAttributes[@"href"];
        [arrayOfLink insertObject:href atIndex:[arrayOfLink count]];
        
        NSDictionary *rights = loop[@"rights"];
        NSString *rightsString = rights[@"label"];
        [arrayOfRights insertObject:rightsString atIndex:[arrayOfRights count]];
    }
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];

    NSString *labelName = [arrayOfLabelNames objectAtIndex:indexPath.row];
    
    NSString *imageURL = [arrayOfLargeImageURL objectAtIndex:indexPath.row];
    
    NSString *artistName = [arrayOfArtistName objectAtIndex:indexPath.row];
    
    NSString *categoryName = [arrayOfCategory objectAtIndex:indexPath.row];
    
    NSString *releaseDate = [arrayOfReleaseDate objectAtIndex:indexPath.row];
    
    NSString *price = [arrayOfPrices objectAtIndex:indexPath.row];
    
    NSString *link = [arrayOfLink objectAtIndex:indexPath.row];
    
    NSString *rights = [arrayOfRights objectAtIndex:indexPath.row];
    
    [detailViewController setText:labelName];
    [detailViewController setImage:imageURL];
    [detailViewController setArtistName:artistName];
    [detailViewController setCategoryName:categoryName];
    [detailViewController setReleaseDate:releaseDate];
    [detailViewController setPrice:price];
    [detailViewController setlink:link];
    [detailViewController setRight:rights];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
