//
//  QueryManager.h
//  ridesharing
//
//  Created by Wei Lu on 8/2/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryManagerDelegate.h"

@interface QueryManager : NSObject

@property (weak, nonatomic) id<QueryManagerDelegate> delegate;

- (void)queryForAllPostsOfUser:(PFUser *)user;
- (void)queryForAllPostsNearLocation:(CLLocation *)location withNearbyDistance:(CLLocationAccuracy)nearbyDistance withAnnotationOption:(NSInteger)annotationOption;

- (void)queryForAllPostsWithOrigNearLocation:(CLLocation *)location withNearbyDistance:(CLLocationAccuracy)nearbyDistance;

@end
