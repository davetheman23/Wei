//
//  QueryManager.m
//  ridesharing
//
//  Created by Wei Lu on 8/2/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "QueryManager.h"
#import "PostBuilder.h"

@implementation QueryManager

- (void)queryForAllPostsOfUser:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:kRSParseTripPostsClassKey];
    //PFUser *user = [PFUser user];
    //user.objectId = userID;
    //user.username = userID;
    [query whereKey:kRSParseTripPostsOwnerKey equalTo:user];
    //[query whereKey:<#(NSString *)#> nearGeoPoint:<#(PFGeoPoint *)#> withinKilometers:<#(double)#>]
    [query includeKey:kRSParseTripPostsDestKey];
    [query includeKey:kRSParseTripPostsOwnerKey];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSLog(@"Succesfully retrieved %lu ride posts.", objects.count);
            
            NSArray *posts = [PostBuilder postsFromQueryResults:objects];
            
            /* Pass the built posts to self.delegate (the corresponding ViewController) */
            [self.delegate didReceivePosts:posts];
            
        }
        else {
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self.delegate fetchingPostsFailedWithError:error];
        }
    }];
}

- (void)queryForAllPostsWithOrigNearLocation:(CLLocation *)location withNearbyDistance:(CLLocationAccuracy)nearbyDistance
{
    PFQuery *tripPostQuery = [PFQuery queryWithClassName:kRSParseTripPostsClassKey];
    if (location == nil) {
        NSLog(@"got a nil location!");
    }
    
    PFQuery *geoPointQuery = [PFQuery queryWithClassName:kRSParseCustomGeoPointKey];
    // Query for posts near a location
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:location];
    [geoPointQuery whereKey:kRSParseCustomGeoPointParseGeoPointKey nearGeoPoint:point withinMiles:nearbyDistance];
    [geoPointQuery whereKey:kRSParseCustomGeoPointType equalTo:@1];
    
    // Query origin withinNearbyRegion
    [tripPostQuery whereKey:kRSParseTripPostsOrigKey matchesQuery:geoPointQuery];
    [tripPostQuery includeKey:kRSParseTripPostsOrigKey];
    [tripPostQuery includeKey:kRSParseTripPostsDestKey];
    [tripPostQuery includeKey:kRSParseTripPostsOwnerKey];
    
    
    [tripPostQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSLog(@"Succesfully retrieved %lu ride posts.", objects.count);
            
            //NSArray *posts = [PostBuilder postsFromQueryResults:objects];
            NSArray *posts = [PostBuilder origAnnotationFromQueryResults:objects];
            
            /* Pass the built posts to self.delegate (the corresponding ViewController) */
            [self.delegate didReceivePosts:posts];
            
        }
        else {
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self.delegate fetchingPostsFailedWithError:error];
        }
    }];
}

- (void)queryForAllPostsNearLocation:(CLLocation *)location withNearbyDistance:(CLLocationAccuracy)nearbyDistance withAnnotationOption:(NSInteger)annotationOption
{
    
}

@end
