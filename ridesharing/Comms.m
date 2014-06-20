//
//  Comms.m
//  ridesharing
//
//  Created by Wei Lu on 6/14/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "Comms.h"

@implementation Comms

+ (void) login:(id<CommsDelegate>)delegate
{
    // Basic User information and your friends are part of the standard permissions
	// so there is no reason to ask for additional permissions
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        //Was login succesful?
        if (!user) {
            if (!error) {
                NSLog(@"the user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occured: %@", error.localizedDescription);
            }
            
            //callback - login failed
            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                [delegate commsDidLogin:NO];
            }
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
            
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                    // Store the Facebook Id
                    [[PFUser currentUser] setObject:me.objectID forKey:@"fbId"];
                    [[PFUser currentUser] setObject:me.name forKey:@"fbName"];
                    [[PFUser currentUser] saveInBackground];
                }
                //Callback - login successful
                if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                    [delegate commsDidLogin:YES];
                }
            
            
            }];
        }
    }];
}

@end
