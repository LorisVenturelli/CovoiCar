//
//  ListTravelsTableViewController.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelTableViewCell.h"
#import "User.h"
#import "UserManager.h"
#import "Travel.h"
#import "TravelManager.h"

@interface ListTravelsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property UIRefreshControl* refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)refreshTableView;

@end

