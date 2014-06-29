//
//  ridesharingViewController.m
//  ridesharing
//
//  Created by WEI LU on 10/9/13.
//  Copyright (c) 2013 WEI LU. All rights reserved.
//

#import "ridesharingViewController.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "DriverAnnotation.h"

//11/17/13, for rounded corner of button
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#define METERS_PER_MILE 1609.344

@interface ridesharingViewController () <CLLocationManagerDelegate>
//@property (strong, nonatomic) IBOutlet UITextField *addressOutlet;

//store the location when map is dragged, 10/20/13
@property (strong, nonatomic) CLLocation *pickupLocation;
@property (strong, nonatomic) CLLocation *dropoffLocation;
@property (strong, nonatomic) NSMutableDictionary *placeDictionary;

@end

@implementation ridesharingViewController {
    CLLocationManager *manager;
    //CLGeocoder *geocoder;
}

@synthesize pickupRequestAnnotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //11/16, use storyboard instead. 
    //self.mapView = [[MKMapView alloc] init];
    //self.mapView.frame=CGRectMake(0,
    //                              0,
    //                              self.view.bounds.size.width,
    //                              self.view.bounds.size.height);
    self.mapView.delegate=self;
    
    //[self.view addSubview:self.mapView];
    
    self.pinView = [[UIImageView alloc] init];
    //self.pinView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.pinView.frame = CGRectMake(self.view.bounds.size.width/2-10, self.view.bounds.size.height/2-40, 40, 40);
    
    self.pinView.image = [UIImage imageNamed:@"pin_icon.png"];
    [self.view addSubview:self.pinView];
    
    CLLocationCoordinate2D startCenter = CLLocationCoordinate2DMake(30.619046, -96.338865);
    CLLocationDistance regionWidth = 1500;
    CLLocationDistance regionHeight = 1500;
    
    MKCoordinateRegion startRegion =
        MKCoordinateRegionMakeWithDistance(startCenter, regionWidth, regionHeight);
    
    [self.mapView setRegion:startRegion animated:YES];
    
    self.mapView.showsUserLocation = YES;
    

    
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    CLLocationCoordinate2D annotatinCoordinate = CLLocationCoordinate2DMake(30.620166, -96.339945);
    
    DriverAnnotation *annotation = [[DriverAnnotation alloc] init];
    annotation.coordinate = annotatinCoordinate;
    [self.mapView addAnnotation:annotation];
    
    
    //set center drop pin. 10/19/13
    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = self.mapView.centerCoordinate;
    pa.title = @"Pick Up";
    pa.subtitle = [NSString stringWithFormat:@"%f, %f", pa.coordinate.latitude, pa.coordinate.longitude];
    //no show
    [self.mapView addAnnotation:pa];
    self.pickupRequestAnnotation = pa;
    //[pa release];
    
    //set textfield, 10/20/13
    //11/16, use storyboard instead.
    //self.addressOutlet = [[UITextField alloc] init];
    //self.addressOutlet.frame = CGRectMake(10, 320, 300, 40);
    //self.addressOutlet.backgroundColor = [UIColor whiteColor];
    //self.addressOutlet.borderStyle = UITextBorderStyleRoundedRect;
    //self.addressOutlet.keyboardType = UIKeyboardTypeDefault;
    
    
    self.addressOutlet.delegate = self;
    self.dropoffLabel.delegate = self;
    self.pickupLabel.delegate = self;
    //11/17/13, add input view for addressOutlet
    //self.addressOutlet.inputView = self.searchDisplayController;
    self.placeDictionary = [[NSMutableDictionary alloc] init];
    //self.dummyButton.alpha = 0.05;
    //[self.view addSubview:self.addressOutlet];
    //11/17/13, set rounded corner for request button
    CALayer *btnLayer = self.requestButton.layer; //layer;
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:6.0f];
    
    //11/8/13, set searchbar
    //self.addressBar = [[UISearchBar alloc] init];
    //self.addressBar.frame = CGRectMake(10, 100, 300, 40);
    //self.addressBar.backgroundColor = [UIColor whiteColor];
    //self.addressBar.keyboardType = UIKeyboardTypeDefault;
    
    //self.addressBar.delegate = self;
    //[self.view addSubview:self.addressBar];
    
    //smooth annotation move. 10/19/13
    //UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(<#selector#>);
    
    //self.title=@"Sherry";
    //change button color
    
    //hide the postView when map loads.
    //[UIView animateWithDuration:0.3 animations:^() {
    self.postView.alpha = 0.0;
    //}];
    
    //get current location.
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    //set the side bar button actin, when it's tapped, it'll show up the sidebar.
    
    _sidebarButton.target=self.revealViewController;
    //_sidebarButton.target = self.revealViewController
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (IBAction)requestPressed:(id)sender {
    //PFObject *point = [PFObject objectWithClassName:@"LocationPoint"];
    //PFObject *point = [PFObject objectWithClassName:@"CustomGeoPoints"];
    //PFGeoPoint *pGeoPoint = [[PFGeoPoint alloc] init];//self.pickupLocation.coordinate;
    //pGeoPoint.latitude = self.pickupLocation.coordinate.latitude;
    //pGeoPoint.longitude = self.pickupLocation.coordinate.longitude;
    //point[@"ParseGeoPoint"] = pGeoPoint;
    //[point saveInBackground];
    
    //NSArray *points = [NSArray arrayWithObjects:point, nil];
    //[PFObject saveAllInBackground:points];
    
    //bring postView to front, 6/24/14.
    // default ride preference == nil, let user select.
    self.ridePreferenceControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    [self.postView.superview bringSubviewToFront:self.postView];
    [UIView animateWithDuration:0.3 animations:^() {
        self.postView.alpha = 1.0;
    }];
    //[points saveAllInBackground];
    //[points saveAllInBackground];
    //[points s]
}

- (IBAction)postPressed:(id)sender {
    // .selected poorly implemented?
    if (self.ridePreferenceControl.selectedSegmentIndex == UISegmentedControlNoSegment) {
        NSLog(self.ridePreferenceControl.selected ? @"yes" : @"no");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select your ride preference" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = 1; //need to input ride preference alert
        [alert show];
        //break;
    }
    
    else {
    PFObject *origPoint = [PFObject objectWithClassName:@"CustomGeoPoints"];
    PFObject *destPoint = [PFObject objectWithClassName:@"CustomGeoPoints"];
    PFGeoPoint *origGeoPoint = [[PFGeoPoint alloc] init];
    PFGeoPoint *destGeoPoint = [[PFGeoPoint alloc] init];
    origGeoPoint.latitude = self.pickupLocation.coordinate.latitude;
    origGeoPoint.longitude = self.pickupLocation.coordinate.longitude;
    destGeoPoint.latitude = self.dropoffLocation.coordinate.latitude;
    destGeoPoint.longitude = self.dropoffLocation.coordinate.longitude;
    origPoint[@"parseGeoPoint"] = origGeoPoint;
    destPoint[@"parseGeoPoint"] = destGeoPoint;

    NSInteger ridePreference = self.ridePreferenceControl.selectedSegmentIndex;
        //NSInteger ridePreferenceToPost;
    NSNumber *ridePreferenceToPost;
    
        switch (ridePreference) {
            case 0:
                ridePreferenceToPost = @0;
                break;
            case 1:
                ridePreferenceToPost = @5;
                break;
            case 2:
                ridePreferenceToPost = @10;
            default:
                break;
        }
        
    PFObject *ridePost = [PFObject objectWithClassName:@"ModelRidePosts"];
    ridePost[@"orig"] = origPoint;
    ridePost[@"dest"] = destPoint;
    ridePost[@"ridePref"] = ridePreferenceToPost;
    ridePost[@"user"] = [PFUser currentUser];
        
    [ridePost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trip Posted!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 2; //trip posted alert
            [alert show];
        }
    }];
    }
}

- (IBAction)closePostViewPressed:(id)sender {
    [UIView animateWithDuration:0.3 animations:^() {
        self.postView.alpha = 0.0;
    }];
}



- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    //destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    //if ([segue.identifier isEqualToString:@"showPhoto"]) {
    //    PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
    //    NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [_menuItems objectAtIndex:indexPath.row]];
    //    photoController.photoFilename = photoFilename;
    //}
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)testText {
//    return NO;  // Hide both keyboard and blinking cursor.
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"hahahahaha");
    if (!self.userLocationUpdated) {
        NSLog(@"userlocationupdated!");
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
        //reverse geocode currentlocation(userLocation)
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSLog(@"user location==>%@", self.mapView.userLocation.location);
        [geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error){
            if (error == nil && placemarks.count) {
                NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
                [self.pickupLabel setText:[dictionary valueForKey:@"Street"]];
            }
        }];
        self.userLocationUpdated=YES;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"annoView"];
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annoView"];
    }
    view.image = [UIImage imageNamed:@"driver_icon_small.png"];
    
    
    return view;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //dynamically show the center annotation. 10/20/13
    //pickupRequestAnnotation.coordinate = self.mapView.centerCoordinate;
    //pickupRequestAnnotation.subtitle = [NSString stringWithFormat:@"%f, %f", pickupRequestAnnotation.coordinate.latitude, pickupRequestAnnotation.coordinate.longitude];
    
    //get the center coordinate of the mapview. 10/20/13
    self.pickupLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    
    //get the center coordinate of the mapview as dropoff location. 6/24/14
    self.dropoffLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    
    //[self performSelector:@selector(del)]
    //[self performSelector:@selector(reverseg)]
    
    NSLog(@"lat==>%f; long==>%f", self.pickupLocation.coordinate.latitude, self.pickupLocation.coordinate.longitude);
    NSLog(@"dropoff LAT==>%f; lONG==>%f", self.dropoffLocation.coordinate.latitude, self.dropoffLocation.coordinate.longitude);
    //11/8/13, show addressoutlet when NOT dragging map
    [UIView animateWithDuration:0.3 animations:^() {
        self.addressOutlet.alpha = 1.0;
    }];
    [self performSelector:@selector(delayedReverseGeocodeLocation)
               withObject:nil afterDelay:0.3];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    //11/8/13, hide addressoutlet when dragging map
    [UIView animateWithDuration:0.3 animations:^() {
        self.addressOutlet.alpha =0.0;
    }];
}

//cancel previous request if within 0.3s delay
- (void)delayedReverseGeocodeLocation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self reverseGeocodeLocation];
}

- (void)reverseGeocodeLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.dropoffLocation completionHandler:^(NSArray *placemarks, NSError *error){
        
        if (placemarks.count) {
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            CLPlacemark *placemark = [[CLPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
            NSLog(@"street address==>%@ %@", placemark.subThoroughfare, placemark.thoroughfare);
            
            [self.addressOutlet setText:[dictionary valueForKey:@"Street"]];
            [self.dropoffLabel setText:[dictionary valueForKey:@"Street"]];
            //[self.addressOutlet setTitle:[dictionary valueForKey:@"Street"] forState:UIControlStateNormal];
        }
    }];
    /*
    [geocoder reverseGeocodeLocation:self.dropoffLocation completionHandler:^(NSArray *placemarks, NSError *error){
        if (placemarks.count) {
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            [self.dropoffLabel setText:[dictionary valueForKey:@"Street"]];
        }
    }];
    */
}
//- (void)dealloc {
//    [pickupRequestAnnotation release];
//    [super dealloc];
//}


//- (void)viewWillAppear:(BOOL)animated {
    // 1
    //CLLocationCoordinate2D zoomLocation;
    //zoomLocation.latitude = 39.281516;
    //zoomLocation.longitude= -76.580806;
    
    // 2
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    //[_mapView setRegion:viewRegion animated:YES];
//}

- (IBAction)backgroundTap:(id)sender {
    //hide postView when tap background
    [UIView animateWithDuration:0.3 animations:^() {
        self.postView.alpha = 0.0;
    }];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //[UIView animateWithDuration:0.1 animations:^() {
    //dismiss postview if trip posted.
    if (alertView.tag == 2) {
        self.postView.alpha = 0.0;
    }
    //}];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location!");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"New Location==>%@", locations.lastObject);
    //CLLocation *currentLocation = locations.lastObject;
    
    /*
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error){
        
        if (error == nil && placemarks.count) {
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            NSLog(@"street address from location manager==>%@", [dictionary valueForKey:@"Street"]);
            [self.pickupLabel setText:[dictionary valueForKey:@"Street"]];
        }
        
    }];
    */
}

@end
