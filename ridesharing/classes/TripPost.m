//
//  TripPost.m
//  ridesharing
//
//  Created by Wei Lu on 8/5/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "TripPost.h"

@interface TripPost ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D OrigCoord;
@property (nonatomic, assign) CLLocationCoordinate2D DestCoord;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *OrigGeopoint;
@property (nonatomic, strong) PFGeoPoint *DestGeopoint;
@property (nonatomic, strong) PFUser *user;

@end

@implementation TripPost

- (id)initWithOrigCoordinate:(CLLocationCoordinate2D)OCoordinate withDestCoordinate:(CLLocationCoordinate2D)DCoordinate
{
    self = [super init];
    if (self) {
        self.OrigCoord = OCoordinate;
        self.DestCoord = DCoordinate;
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)anObject
{
    self.object = anObject;
    self.OrigGeopoint = [[anObject objectForKey:kRSParseTripPostsOrigKey] objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    self.DestGeopoint = [[anObject objectForKey:kRSParseTripPostsDestKey] objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    self.user = [anObject objectForKey:kRSParseTripPostsOwnerKey];
    //self.geopoint = [geopointObject objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    //self.user = [tripPostObject objectForKey:kRSParseTripPostsOwnerKey];
    
    [anObject fetchIfNeeded];
    //[geopointObject fetchIfNeeded];
    CLLocationCoordinate2D OrigCoordinate = CLLocationCoordinate2DMake(self.OrigGeopoint.latitude, self.OrigGeopoint.longitude);
    CLLocationCoordinate2D DestCoordinate = CLLocationCoordinate2DMake(self.DestGeopoint.latitude, self.DestGeopoint.longitude);
    
    return [self initWithOrigCoordinate:OrigCoordinate withDestCoordinate:DestCoordinate];
}

@end
