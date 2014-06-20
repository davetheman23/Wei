//
//  ridesharingViewController.m
//  ridesharing
//
//  Created by WEI LU on 10/9/13.
//  Copyright (c) 2013 WEI LU. All rights reserved.
//

#import "ridesharingViewController.h"
#import "SWRevealViewController.h"

#import "DriverAnnotation.h"

//11/17/13, for rounded corner of button
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@interface ridesharingViewController ()
//@property (strong, nonatomic) IBOutlet UITextField *addressOutlet;

//store the location when map is dragged, 10/20/13
@property (strong, nonatomic) CLLocation *pickupLocation;
@property (strong, nonatomic) NSMutableDictionary *placeDictionary;

@end

@implementation ridesharingViewController

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
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    //set the side bar button actin, when it's tapped, it'll show up the sidebar.
    
    _sidebarButton.target=self.revealViewController;
    //_sidebarButton.target = self.revealViewController
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    if (!self.userLocationUpdated) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
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
    //[self performSelector:@selector(del)]
    //[self performSelector:@selector(reverseg)]
    
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
    [geocoder reverseGeocodeLocation:self.pickupLocation completionHandler:^(NSArray *placemarks, NSError *error){
        
        if (placemarks.count) {
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            [self.addressOutlet setText:[dictionary valueForKey:@"Street"]];
            //[self.addressOutlet setTitle:[dictionary valueForKey:@"Street"] forState:UIControlStateNormal];
        }
    }];
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

@end
