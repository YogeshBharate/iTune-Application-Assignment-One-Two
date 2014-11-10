//
//  ApplicationObject.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ApplicationObject.h"
#import "ViewController.h"
#import "AppDelegate.h"
#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation ApplicationObject

-(instancetype)initWithJsonData:(NSDictionary *) jsonData
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
        _imageURL = largeImageURL[@"label"];

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
        _URLLink = linkAttributes[@"href"];

        
        // fetch the app bundle id
        NSDictionary *bundleId = jsonData[@"id"];
        NSDictionary *attributeId = bundleId[@"attributes"];
        _bundleId = attributeId[@"im:bundleId"];
        
        // Fetch the app rights
        NSDictionary *rights = jsonData[@"rights"];
        _rights = rights[@"label"];
}
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:@"appName"];
    [encoder encodeObject:_iconURL forKey:@"appIconUrl"];
    [encoder encodeObject:_imageURL forKey:@"appImageUrl"];
    [encoder encodeObject:_artistName forKey:@"appArtistName"];
    [encoder encodeObject:_price forKey:@"appPrice"];
    [encoder encodeObject:_releaseDate forKey:@"appReleaseDate"];
    [encoder encodeObject:_URLLink forKey:@"appUrlLink"];
    [encoder encodeObject:_rights forKey:@"appRights"];
    [encoder encodeObject:_category forKey:@"appCategory"];
    [encoder encodeObject:_bundleId forKey:@"appBundleId"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    _name           = [decoder decodeObjectForKey:@"appName"];
    _iconURL        = [decoder decodeObjectForKey:@"appIconUrl"];
    _imageURL       = [decoder decodeObjectForKey:@"appImageUrl"];
    _artistName     = [decoder decodeObjectForKey:@"appArtistName"];
    _price          = [decoder decodeObjectForKey:@"appPrice"];
    _releaseDate    = [decoder decodeObjectForKey:@"appReleaseDate"];
    _URLLink        = [decoder decodeObjectForKey:@"appUrlLink"];
    _rights         = [decoder decodeObjectForKey:@"appRights"];
    _category       = [decoder decodeObjectForKey:@"appCategory"];
    _bundleId       = [decoder decodeObjectForKey:@"appBundleId"];
    
    return self;
}

@end
