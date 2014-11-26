
#import "ApplicationData.h"
#import "MasterViewController.h"
#import "AppDelegate.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation ApplicationData

- (instancetype)initWithJsonData:(NSDictionary *)jsonData
{
    self = [super init];
    if(self)
    {
        NSDictionary *label = jsonData[@"im:name"];
        _name = label[@"label"];
        
        // Fetch small Icon URLS
        NSArray *image = jsonData[@"im:image"];
        NSDictionary *firstLabel = [image objectAtIndex:0];
        _iconURL = firstLabel[@"label"];
        
        // Fetch largeImageURLs
        NSDictionary *largeImageURL = [image objectAtIndex:2];
        _detailViewImageURL = largeImageURL[@"label"];
        
        // Fetch artist names
        NSDictionary *artist = jsonData[@"im:artist"];
        _artistName = artist[@"label"];
        
        // Fetch Category name
        NSDictionary *category = jsonData[@"category"];
        NSDictionary *attributes = category[@"attributes"];
        _category = attributes[@"label"];
        
        // Fetch the releasing date
        NSDictionary *releaseDate = jsonData[@"im:releaseDate"];
        NSDictionary *attributesReleaseDate = releaseDate[@"attributes"];
        _releaseDate = attributesReleaseDate[@"label"];
        
        // Fetch app Price
        NSDictionary *price = jsonData[@"im:price"];
        _price = price[@"label"];
        
        //Fetch the app URL link
        NSDictionary *link = jsonData[@"link"];
        NSDictionary *linkAttributes = link[@"attributes"];
        _link = linkAttributes[@"href"];
        
        // Fetch the app rights
        NSDictionary *rights = jsonData[@"rights"];
        _rights = rights[@"label"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:@"appName"];
    [encoder encodeObject:_iconURL forKey:@"appIconUrl"];
    [encoder encodeObject:_detailViewImageURL forKey:@"appImageUrl"];
    [encoder encodeObject:_artistName forKey:@"appArtistName"];
    [encoder encodeObject:_price forKey:@"appPrice"];
    [encoder encodeObject:_releaseDate forKey:@"appReleaseDate"];
    [encoder encodeObject:_link forKey:@"appLink"];
    [encoder encodeObject:_rights forKey:@"appRights"];
    [encoder encodeObject:_category forKey:@"appCategory"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    _name           = [decoder decodeObjectForKey:@"appName"];
    _iconURL        = [decoder decodeObjectForKey:@"appIconUrl"];
    _detailViewImageURL       = [decoder decodeObjectForKey:@"appImageUrl"];
    _artistName     = [decoder decodeObjectForKey:@"appArtistName"];
    _price          = [decoder decodeObjectForKey:@"appPrice"];
    _releaseDate    = [decoder decodeObjectForKey:@"appReleaseDate"];
    _link           = [decoder decodeObjectForKey:@"appLink"];
    _rights         = [decoder decodeObjectForKey:@"appRights"];
    _category       = [decoder decodeObjectForKey:@"appCategory"];
    
    return self;
}

@end