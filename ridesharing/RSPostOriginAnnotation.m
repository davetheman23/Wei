//
//  RSPostOriginAnnotation.m
//  ridesharing
//
//  Created by Wei Lu on 7/26/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "RSPostOriginAnnotation.h"

@interface RSPostOriginAnnotation ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;

@end

@implementation RSPostOriginAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)anObject
{
    self.object = anObject;
    self.geopoint = [[anObject objectForKey:kRSParseTripPostsOrigKey] objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    self.user = [anObject objectForKey:kRSParseTripPostsOwnerKey];
    //self.geopoint = [geopointObject objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    //self.user = [tripPostObject objectForKey:kRSParseTripPostsOwnerKey];
    
    [anObject fetchIfNeeded];
    //[geopointObject fetchIfNeeded];
    CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    
    return [self initWithCoordinate:aCoordinate];
}

@end
