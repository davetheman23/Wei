//
//  RSPost.m
//  ridesharing
//
//  Created by Wei Lu on 7/12/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "RSPostDestAnnotation.h"

@interface RSPostDestAnnotation ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end



@implementation RSPostDestAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title=title;
        self.subtitle=subtitle;
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)anObject
{
    self.object = anObject;
    self.geopoint = [[anObject objectForKey:kRSParseTripPostsDestKey] objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    self.user = [anObject objectForKey:kRSParseTripPostsOwnerKey];
    //self.geopoint = [geopointObject objectForKey:kRSParseCustomGeoPointParseGeoPointKey];
    //self.user = [tripPostObject objectForKey:kRSParseTripPostsOwnerKey];
    
    [anObject fetchIfNeeded];
    //[geopointObject fetchIfNeeded];
    CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    
    NSDate *date = [anObject objectForKey:kRSParseTripPostsDepartTimeKey];
    NSString *aTitle = @"Leave Time";
    
    NSString *aSubtitle = [[anObject objectForKey:kRSParseTripPostsOwnerKey] objectForKey:kRSParseUserFBNameKey];
    
    
    //return [self initWithCoordinate:aCoordinate];
    return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}

@end
