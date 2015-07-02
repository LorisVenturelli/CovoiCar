//
//  TripAddTableViewController.m
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TripAddTableViewController.h"

@interface TripAddTableViewController ()

@end

@implementation TripAddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add an interactive action for hide it
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // Date picker for dates
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateTextFieldForDate:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.minimumDate = [[NSDate alloc] init];
    [self.hourStartField setInputView:datePicker];
    [self.roundTripField setInputView:datePicker];
    
    // Initialize Activity indactor on Navigation Bar
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
    
}

// Action on switch the roundTrip
- (IBAction)roundTripAction:(id)sender {
    
    // Toggle the cell on switch change
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    
    [cell setHidden:!cell.hidden];
    self.roundTripField.text = @"";
}

- (IBAction)submitAction:(UIButton *)sender {
    // Get user instance
    User* user = [[UserManager sharedInstance] getUserInstance];
    
    // Convert the switch highway for the API
    NSString* highway = @"0";
    if(self.highwaySwitch.isOn)
        highway = @"1";
    
    // Conversion string to date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate* hourStartDate = [dateFormat dateFromString:self.hourStartField.text];
    NSDate* roundTripDate = [dateFormat dateFromString:self.roundTripField.text];
    
    // Conversion date to string with other format for API
    NSDateFormatter *otherDateFormat = [[NSDateFormatter alloc] init];
    [otherDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* hourStart = [otherDateFormat stringFromDate:hourStartDate];
    NSString* roundTrip = [otherDateFormat stringFromDate:roundTripDate];
    
    // Convert 2 dates to string if there are null
    if(roundTrip == nil)
        roundTrip = @"";
    
    if(hourStart == nil)
        hourStart = @"";
    
    // Params for API
    NSDictionary *parameters = @{@"token":user.token,
                                 @"start":self.startField.text,
                                 @"arrival":self.arrivalField.text,
                                 @"highway":highway,
                                 @"hourStart":hourStart,
                                 @"roundTrip":roundTrip,
                                 @"price":self.priceField.text,
                                 @"place":self.placeField.text,
                                 @"comment":self.commentField.text};
    
    // Start acitivityIndicator
    [self.activityIndicator startAnimating];
    
    // Request to send the trip to API
    [[TripManager sharedInstance] sendTripToApiWithParameters:parameters success:^(NSDictionary* responseJson) {
        
        // If success, show an alert message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo !" message:[responseJson valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        // Hide the keyboard
        [self.view endEditing:YES];
        
        // Go to the user's trip list
        [self.tabBarController setSelectedIndex:0];
        
        // Empty the form
        self.startField.text = @"";
        self.arrivalField.text = @"";
        [self.highwaySwitch setOn:YES];
        self.hourStartField.text = @"";
        [self.roundTripSwitch setOn:YES];
        self.roundTripField.text = @"";
        self.priceField.text = @"";
        self.placeField.text = @"";
        self.commentField.text = @"";
        
        // Stop the activity indicator
        [self.activityIndicator stopAnimating];
        
    } error:^(NSDictionary* responseJson) {
        // API return an error
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSError *error) {
        // Server don't respond
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
        [self.activityIndicator stopAnimating];
        
    }];
}

// Method for update the textfield when the datepicker change
-(void)updateTextFieldForDate:(UIDatePicker *)sender
{
    // Date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    // For hour start field
    if ([self.hourStartField isFirstResponder])
    {
        self.hourStartField.text = [dateFormat stringFromDate:sender.date];
    }
    // For round trip field
    else if ([self.roundTripField isFirstResponder])
    {
        self.roundTripField.text = [dateFormat stringFromDate:sender.date];
    }
}

// Function for show an alert with error message
- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
