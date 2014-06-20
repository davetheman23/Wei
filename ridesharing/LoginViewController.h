//
//  LoginViewController.h
//  ridesharing
//
//  Created by Wei Lu on 5/27/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

//@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;


@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end
