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
    
    if(self._trips == nil)
        self._trips = [[NSMutableArray alloc] init];
    
    // Initialize table view
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // Datepicker for date
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateTextFieldForDate:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.minimumDate = [[NSDate alloc] init];
    [self.hourStartField setInputView:datePicker];
    
    // Initialize Activity indactor on Navigation Bar
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self._trips.count == 0) {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"Aucun résultat";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.backgroundColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
        
    }
    else {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self._trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    
    Trip* trip = [self._trips objectAtIndex:indexPath.row];
    
    NSDate *date = trip.hourStart;
    NSDateFormatter *heureFormat = [[NSDateFormatter alloc] init];
    [heureFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:@"dd/MM"];
    
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date]];
    
    User* driver = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
    
    cell.wayLabel.text = [NSString stringWithFormat:@"%@ - %@", trip.start, trip.arrival];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d €", (int)trip.price];
    cell.driverLabel.text = [NSString stringWithFormat:@"%@ %@", driver.firstname, driver.lastname];
    cell.placeLabel.text = [NSString stringWithFormat:@"%d pl.", (int)trip.placeAvailable];
    
    return cell;
}

- (IBAction)submitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    // Conversion string to date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate* hourStartDate = [dateFormat dateFromString:self.hourStartField.text];
    
    
    [self.activityIndicator startAnimating];
    
    [[TripManager sharedInstance] searchTripsWithStart:self.startField.text arrival:self.arrivalField.text hourStart:hourStartDate success:^(NSMutableArray *list) {
        
        self._trips = list;
        
        [self refreshTableView];
        
        [self.activityIndicator stopAnimating];
        
    } error:^(NSDictionary *responseJson) {
        
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSError *error) {
        
        [self ShowAlertErrorWithMessage:@"Le serveur ne répond pas .."];
        [self.activityIndicator stopAnimating];
        
    }];
    
}

-(void)updateTextFieldForDate:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    if ([self.hourStartField isFirstResponder])
    {
        self.hourStartField.text = [dateFormat stringFromDate:sender.date];
    }
}

- (void)refreshTableView
{
    self.tableView.scrollEnabled = NO;
    
    [self.tableView reloadData];
    
    self.tableView.scrollEnabled = YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewTrip"]) {
        TripViewController *dest = segue.destinationViewController;
        
        NSInteger cell = self.tableView.indexPathForSelectedRow.row;
        Trip* trip = [self._trips objectAtIndex:cell];
        
        dest._trip = trip;
        dest._user = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
        dest.canReserve = YES;
    }
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
