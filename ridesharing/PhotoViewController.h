//
//  PhotoViewController.h
//  ridesharing
//
//  Created by WEI LU on 10/18/13.
//  Copyright (c) 2013 WEI LU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) NSString *photoFilename;
@end
