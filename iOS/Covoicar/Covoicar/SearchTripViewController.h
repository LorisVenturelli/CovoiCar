//
//  SearchTripViewController.h
//  Covoicar
//
//  Created by Loris on 30/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TripManager.h"
#import "TripTableViewCell.h"
#import "TripViewController.h"

@interface SearchTripViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// TableView for the search's results
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIActivityIndicatorView* activityIndicator;

// All trips of the research
@property NSMutableArray* _trips;

// Field for the research
@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalField;
@property (weak, nonatomic) IBOutlet UITextField *hourStartField;

/**
 * Research action
 * @return IBAction
 */
- (IBAction)submitAction:(id)sender;


- (void)ShowAlertErrorWithMessage:(NSString *)message;

@end
