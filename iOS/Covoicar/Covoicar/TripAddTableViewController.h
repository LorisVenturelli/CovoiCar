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

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalField;
@property (weak, nonatomic) IBOutlet UISwitch *highwaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *roundTripSwitch;
@property (weak, nonatomic) IBOutlet UITextField *hourStartField;
@property (weak, nonatomic) IBOutlet UITextField *roundTripField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *placeField;
@property (weak, nonatomic) IBOutlet UITextView *commentField;

- (IBAction)roundTripAction:(id)sender;

- (IBAction)submitAction:(UIButton *)sender;
- (IBAction)submitTabBarAction:(id)sender;

- (void)addTripAction:(NSNotification *)notification;

-(void)updateTextFieldForDate:(UIDatePicker *)sender;

@end
