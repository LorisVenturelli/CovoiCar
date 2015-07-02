//
//  TripTableViewController.h
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TripManager.h"

@interface TripTableViewController : UITableViewController

// Property for reserve the trip
@property BOOL canReserve;

// The trip
@property Trip* _trip;

// All field for the trip
@property (weak, nonatomic) IBOutlet UILabel *dateField;
@property (weak, nonatomic) IBOutlet UILabel *startField;
@property (weak, nonatomic) IBOutlet UILabel *arrivalField;
@property (weak, nonatomic) IBOutlet UILabel *placeField;
@property (weak, nonatomic) IBOutlet UILabel *priceField;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (weak, nonatomic) IBOutlet UIImageView *highwayImage;
@property (weak, nonatomic) IBOutlet UILabel *distanceField;

// The user driver
@property User* _user;

// All label for the driver
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *phoneField;
@property (weak, nonatomic) IBOutlet UILabel *emailField;
@property (weak, nonatomic) IBOutlet UITextView *bioField;

// Delete travel element
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *deleteTravelButton;

/**
 * Action for delete the trip or reservation
 * @return IBAction
 */
- (IBAction)deleteTravel:(id)sender;

/**
 * Show and start the activity indicator
 */
- (void)showActivityIndicator;

/**
 * Hide and stop the activity indicator
 */
- (void)hideActivityIndicator;

@end
