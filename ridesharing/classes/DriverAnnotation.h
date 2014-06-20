//
//  DriverAnnotation.h
//  ridesharing
//
//  Created by WEI LU on 10/19/13.
//  Copyright (c) 2013 WEI LU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DriverAnnotation : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordinate;


@end
