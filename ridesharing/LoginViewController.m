//
//  LoginViewController.m
//  ridesharing
//
//  Created by Wei Lu on 5/27/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController () <CommsDelegate>

-(void)toggleHiddenState:(BOOL)shouldHide;

@end

@implementation LoginViewController

-(void)toggleHiddenState:(BOOL)shouldHide {
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.loginButton.delegate = self;
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"";
    //self.loginButton.readPermissions = @[@"public_profile", @"email"];
    
    //[PFFacebookUtils logInWithPermissions: block:<#^(PFUser *user, NSError *error)block#>]
    /*
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
    */
    
    // Ensure the User is Logged out when loading this View Controller
    // Going forward, we would check the state of the current user and bypass the Login Screen
    // but here, the Login screen is an important part of the tutorial
    
    [PFUser logOut];
    
}
- (IBAction)loginPressed:(id)sender {
    // Disable the Login button to prevent multiple touches
    [_loginButton setEnabled:NO];
    
    // Show an activity indicator
    
    // Do the login
    [Comms login:self];
    
}

- (void) commsDidLogin:(BOOL)loggedIn {
    //Re-enable the login button
    [_loginButton setEnabled:YES];
    
    //Stop the activity indicator
    
    //Check login status
    if (loggedIn) {
        // Seque to the next viewController
        //NSLog(@"inn");
        [self performSegueWithIdentifier:@"login_success" sender:self];
    } else {
        // Show error alert
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Facebook login failed, please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
}

//no need to write this method? 6/21/14
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"%@", user);
    self.profilePicture.profileID = user.objectID;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
    [self performSegueWithIdentifier:@"login_success" sender:self];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.lblLoginStatus.text = @"You are logged out";
    
    [self toggleHiddenState:YES];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
