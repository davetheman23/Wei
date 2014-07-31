//
//  RSPost.h
//  ridesharing
//
//  Created by Wei Lu on 7/12/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface RSPostDestAnnotation : NSObject <MKAnnotation>

//required by MKAnnotation protocol
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;
@property (nonatomic, readonly, strong) PFUser *user;

//designated initializer
- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (id)initWithPFObject:(PFObject *)anObject;

@end
