//
//  TripPost.h
//  ridesharing
//
//  Created by Wei Lu on 8/5/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface TripPost : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D OrigCoord;
@property (nonatomic, readonly) CLLocationCoordinate2D DestCoord;

@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *OrigGeopoint;
@property (nonatomic, readonly, strong) PFGeoPoint *DestGeopoint;
@property (nonatomic, readonly, strong) PFUser *user;

//designated initializer
- (id)initWithOrigCoordinate:(CLLocationCoordinate2D) OCoordinate withDestCoordinate:(CLLocationCoordinate2D) DCoordinate;
- (id)initWithPFObject:(PFObject *)anObject;

@end
