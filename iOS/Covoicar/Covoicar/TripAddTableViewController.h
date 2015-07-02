//
//  TripAddTableViewController.h
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UserManager.h"
#import "TripManager.h"

@interface TripAddTableViewController : UITableViewController <UITabBarControllerDelegate, UITabBarDelegate>

// Activity indicator
@property UIActivityIndicatorView* activityIndicator;

// All labels of the form
@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalField;
@property (weak, nonatomic) IBOutlet UISwitch *highwaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *roundTripSwitch;
@property (weak, nonatomic) IBOutlet UITextField *hourStartField;
@property (weak, nonatomic) IBOutlet UITextField *roundTripField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *placeField;
@property (weak, nonatomic) IBOutlet UITextView *commentField;

// Switch roundTrip
- (IBAction)roundTripAction:(id)sender;

// Add trip with API
- (IBAction)submitAction:(id)sender;

// Method for update the textfield when the datepicker change
- (void)updateTextFieldForDate:(UIDatePicker *)sender;

@end
