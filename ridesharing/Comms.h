//
//  Comms.h
//  ridesharing
//
//  Created by Wei Lu on 6/14/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface Comms : NSObject
+ (void) login:(id<CommsDelegate>)delegate;
@end
