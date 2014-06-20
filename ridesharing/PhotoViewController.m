//
//  PhotoViewController.m
//  ridesharing
//
//  Created by WEI LU on 10/18/13.
//  Copyright (c) 2013 WEI LU. All rights reserved.
//

#import "PhotoViewController.h"
#import "SWRevealViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

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
    // Load image
    self.photoImageView.image = [UIImage imageNamed:self.photoFilename];
    
    //change button color
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    //set the side bar button actin, when it's tapped, it'll show up the sidebar.
    
    _sidebarButton.target=self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
