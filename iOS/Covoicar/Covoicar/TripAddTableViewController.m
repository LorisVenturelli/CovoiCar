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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTripAction:) name:@"addTripAction" object:nil];
    
    self.navigationItem.title = @"Proposer un trajet";
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)roundTripAction:(id)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    
    [cell setHidden:!cell.hidden];
    self.roundTripField.text = @"";
}

- (IBAction)submitAction:(UIButton *)sender {
    [self addTripAction:nil];
}

- (IBAction)submitTabBarAction:(id)sender {
    [self addTripAction:nil];
}


-(void)updateTextFieldForDate:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    if ([self.hourStartField isFirstResponder])
    {
        self.hourStartField.text = [dateFormat stringFromDate:sender.date];
    }
    else if ([self.roundTripField isFirstResponder])
    {
        self.roundTripField.text = [dateFormat stringFromDate:sender.date];
    }
}

- (void)addTripAction:(NSNotification *)notification{
    
    User* user = [[UserManager sharedInstance] getUserInstance];
    
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
    
    if(roundTrip == nil)
        roundTrip = @"";
    
    if(hourStart == nil)
        hourStart = @"";
    
    NSDictionary *parameters = @{@"token":user.token,
                                 @"start":self.startField.text,
                                 @"arrival":self.arrivalField.text,
                                 @"highway":highway,
                                 @"hourStart":hourStart,
                                 @"roundTrip":roundTrip,
                                 @"price":self.priceField.text,
                                 @"place":self.placeField.text,
                                 @"comment":self.commentField.text};
    
    NSLog(@"register action void : %@", parameters);
    
    [self.activityIndicator startAnimating];
    
    [[TripManager sharedInstance] sendTripToApiWithParameters:parameters success:^(NSDictionary* responseJson) {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo !" message:[responseJson valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        // Go to the user's trip list
        [self.tabBarController setSelectedIndex:0];
        
        [self.view endEditing:YES];
        
        self.startField.text = @"";
        self.arrivalField.text = @"";
        [self.highwaySwitch setOn:YES];
        self.hourStartField.text = @"";
        [self.roundTripSwitch setOn:YES];
        self.roundTripField.text = @"";
        self.priceField.text = @"";
        self.placeField.text = @"";
        self.commentField.text = @"";
        
        [self.activityIndicator stopAnimating];
        
    } error:^(NSDictionary* responseJson) {
        
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSError *error) {
        
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
        [self.activityIndicator stopAnimating];
        
    }];
    
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}




@end
