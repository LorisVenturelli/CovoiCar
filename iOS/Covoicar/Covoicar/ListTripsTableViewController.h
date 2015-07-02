//
//  ListTripsTableViewController.m
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripTableViewCell.h"
#import "TripViewController.h"
#import "UserManager.h"
#import "TripManager.h"

@interface ListTripsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, UITabBarDelegate>

// Refresh control for the tableView
@property UIRefreshControl* refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Logout action
- (IBAction)logoutAction:(id)sender;

@end

