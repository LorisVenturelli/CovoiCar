//
//  SearchTravelViewController.m
//  Covoicar
//
//  Created by Loris on 30/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "SearchTravelViewController.h"

@interface SearchTravelViewController ()

@end

@implementation SearchTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self._travels == nil)
        self._travels = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateTextFieldForDate:)
         forControlEvents:UIControlEventValueChanged];
    [self.hourStartField setInputView:datePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self._travels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCell" forIndexPath:indexPath];
    
    Travel* travel = [self._travels objectAtIndex:indexPath.row];
    
    NSDate *date = travel.hourStart;
    NSDateFormatter *heureFormat = [[NSDateFormatter alloc] init];
    [heureFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:@"dd/MM"];
    
    
    if(travel.distanceMeter == 0.0){
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@h%@ (%@)",[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], @"Calcul ..."];
        
        [[TravelManager sharedInstance] getDistanceForTheTravel:travel completion:^(float totalDistance) {
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@ (%1.0fkm)", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], travel.distanceMeter/1000];
        }];
    }
    else {
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@ (%1.0fkm)", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], travel.distanceMeter/1000];
    }
    
    User* driver = [[UserManager sharedInstance] userWithThisId:(int)travel.driver];
    
    cell.wayLabel.text = [NSString stringWithFormat:@"%@ - %@", travel.start, travel.arrival];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d €", (int)travel.price];
    cell.driverLabel.text = [NSString stringWithFormat:@"%@ %@", driver.firstname, driver.lastname];
    cell.placeLabel.text = [NSString stringWithFormat:@"%d pl.", (int)travel.placeAvailable];
    
    return cell;
}

- (IBAction)submitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    // Conversion string to date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate* hourStartDate = [dateFormat dateFromString:self.hourStartField.text];
    
    [[TravelManager sharedInstance] searchTravelsWithStart:self.startField.text arrival:self.arrivalField.text hourStart:hourStartDate completion:^(NSMutableArray *list) {
        
        self._travels = list;
        
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
    if ([[segue identifier] isEqualToString:@"viewTravel"]) {
        TravelViewController *dest = segue.destinationViewController;
        
        NSInteger cell = self.tableView.indexPathForSelectedRow.row;
        Travel* travel = [[TravelManager sharedInstance] travelAtIndex:(int)cell];
        
        dest._travel = travel;
        dest._user = [[UserManager sharedInstance] userWithThisId:(int)travel.driver];
        dest.canReserve = YES;
    }
}

@end
