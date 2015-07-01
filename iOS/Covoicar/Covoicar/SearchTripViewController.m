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
    
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateTextFieldForDate:)
         forControlEvents:UIControlEventValueChanged];
    [self.hourStartField setInputView:datePicker];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    
    [[TripManager sharedInstance] searchTripsWithStart:self.startField.text arrival:self.arrivalField.text hourStart:hourStartDate completion:^(NSMutableArray *list) {
        
        self._trips = list;
        
        [self refreshTableView];
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

@end
