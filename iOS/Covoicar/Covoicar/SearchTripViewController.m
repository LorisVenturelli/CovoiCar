//
//  SearchTripViewController.m
//  Covoicar
//
//  Created by Loris on 30/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "SearchTripViewController.h"

@interface SearchTripViewController ()

@end

@implementation SearchTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init list for search's results
    if(self._trips == nil)
        self._trips = [[NSMutableArray alloc] init];
    
    // Initialize the table view
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // Init datepicker for the date
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateTextFieldForDate:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.minimumDate = [[NSDate alloc] init];
    [self.hourStartField setInputView:datePicker];
    
    // Initialize Activity indicator on Navigation Bar
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // If the list trip is empty, show a label with a simple message on tableView
    if (self._trips.count == 0) {
        
        // Init the message
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        // Custom the label
        messageLabel.text = @"Aucun résultat";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        // Send the label to the tableView
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
        
    }
    else {
        
        // Config tableView to the params initials
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self._trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the cell design
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    
    // Get the trip
    Trip* trip = [self._trips objectAtIndex:indexPath.row];
    
    // Format the date
    NSDate *date = trip.hourStart;
    NSDateFormatter *heureFormat = [[NSDateFormatter alloc] init];
    [heureFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:@"dd/MM"];
    
    // Get the driver
    User* driver = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
    
    // Show informations
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date]];
    
    cell.wayLabel.text = [NSString stringWithFormat:@"%@ - %@", trip.start, trip.arrival];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d €", (int)trip.price];
    cell.driverLabel.text = [NSString stringWithFormat:@"%@ %@", driver.firstname, driver.lastname];
    cell.placeLabel.text = [NSString stringWithFormat:@"%d pl.", (int)trip.placeAvailable];
    
    return cell;
}

// Research action
- (IBAction)submitAction:(id)sender {
    
    // Hide the keyboard
    [self.view endEditing:YES];
    
    // Conversion string to date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate* hourStartDate = [dateFormat dateFromString:self.hourStartField.text];
    
    // Start activity indicator
    [self.activityIndicator startAnimating];
    
    // Send the research to API
    [[TripManager sharedInstance] searchTripsWithStart:self.startField.text arrival:self.arrivalField.text hourStart:hourStartDate success:^(NSMutableArray *list) {
        
        // Get all results
        self._trips = list;
        
        // Refresh the tableView
        [self refreshTableView];
        
        // Stop acitivityIndicator
        [self.activityIndicator stopAnimating];
        
    } error:^(NSDictionary *responseJson) {
        
        // API return an error
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSError *error) {
        
        // The server don't respond
        [self ShowAlertErrorWithMessage:@"Le serveur ne répond pas .."];
        [self.activityIndicator stopAnimating];
        
    }];
    
}

// Method for update the textfield when the datepicker change
-(void)updateTextFieldForDate:(UIDatePicker *)sender
{
    // Format the date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    // To hourStartField
    if ([self.hourStartField isFirstResponder])
    {
        self.hourStartField.text = [dateFormat stringFromDate:sender.date];
    }
}

// Method for refresh the tableView
- (void)refreshTableView
{
    // Disable the scroller
    self.tableView.scrollEnabled = NO;
    
    // refresh data on tableView
    [self.tableView reloadData];
    
    // Enable the scroller
    self.tableView.scrollEnabled = YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Send data to the TripViewController for view the trip
    if ([[segue identifier] isEqualToString:@"viewTrip"]) {
        TripViewController *dest = segue.destinationViewController;
        
        NSInteger cell = self.tableView.indexPathForSelectedRow.row;
        Trip* trip = [self._trips objectAtIndex:cell];
        
        // Send data
        dest._trip = trip;
        dest._user = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
        dest.canReserve = YES;
    }
}

// Function for show an alert with error message
- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
