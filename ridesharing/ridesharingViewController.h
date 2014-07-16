//
//  ridesharingViewController.h
//  ridesharing
//
//  Created by WEI LU on 10/9/13.
//  Copyright (c) 2013 WEI LU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RSPost.h"

@interface ridesharingViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    MKPointAnnotation *pickupRequestAnnotation;  //? what for, 10/19/13
} 

//@property (strong, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//@interface ridesharingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

//center pin trick, 10/19/13
//use strong here, otherwise no center pin will display!
@property (strong, nonatomic) UIImageView *pinView;

//update user location
@property BOOL userLocationUpdated;

//property for pick up request annotation
@property (nonatomic, retain) MKPointAnnotation *pickupRequestAnnotation;

//@property (strong, nonatomic) UITextField *addressOutlet;
@property (weak, nonatomic) IBOutlet UITextField *testText;
//@property (weak, nonatomic) IBOutlet UITextField *addressOutlet;
//@property (weak, nonatomic) IBOutlet UILabel *addressOutlet;
//@property (weak, nonatomic) IBOutlet UITextField *addressOutlet;
//@property (weak, nonatomic) IBOutlet UIButton *addressOutlet;
//@property (weak, nonatomic) IBOutlet UIButton *addressOutlet;
@property (weak, nonatomic) IBOutlet UITextField *addressOutlet;
@property (weak, nonatomic) IBOutlet UIButton *dummyButton;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;

@property (weak, nonatomic) IBOutlet UIView *postView;

@property (weak, nonatomic) IBOutlet UITextField *pickupLabel;

@property (weak, nonatomic) IBOutlet UITextField *dropoffLabel;

@property (weak, nonatomic) IBOutlet UIButton *closePostViewButton;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ridePreferenceControl;


- (IBAction)backgroundTap:(id)sender;


- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;

- (void)queryForAllPostsOfUser:(PFUser *)user;


//11/8/13, UISearchBar
//@property (strong, nonatomic) UISearchBar *addressBar;

//@property (strong, nonatomic) UIButton *requestButton;
//store the location when map is dragged, 10/20/13
//@property (strong, nonatomic) CLLocation *pickupLocation;
//@property (strong, nonatomic) NSMutableDictionary *placeDictionary;



@end
