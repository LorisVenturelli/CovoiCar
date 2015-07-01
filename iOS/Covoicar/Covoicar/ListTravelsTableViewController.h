//
//  ListTravelsTableViewController.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelTableViewCell.h"
#import "TravelViewController.h"
#import "UserManager.h"
#import "TravelManager.h"

@interface ListTravelsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, UITabBarDelegate>

@property UIRefreshControl* refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)logoutAction:(id)sender;

- (void)refreshTableView;

@end

