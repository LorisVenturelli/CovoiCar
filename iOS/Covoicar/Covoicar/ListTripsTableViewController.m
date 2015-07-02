//
//  ListTripsTableViewController.m
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "ListTripsTableViewController.h"

@interface ListTripsTableViewController ()

@end

@implementation ListTripsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init tableView
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // Init and add the refresh control to the view
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // Refresh the tableView
    [self refreshTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Reload data of the tableView
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // If the trip's list is empty, show a simple message
    if ([[TripManager sharedInstance] count] == 0) {
        
        // Init the message
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"Vous n'avez aucun voyage";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        // Add the message on the tableview
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
    return [[TripManager sharedInstance] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    
    // Get the trip for this cell
    Trip* trip = [[TripManager sharedInstance] tripAtIndex:(int)indexPath.row];
    
    // Format the date
    NSDate *date = trip.hourStart;
    NSDateFormatter *heureFormat = [[NSDateFormatter alloc] init];
    [heureFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:@"dd/MM"];
    
    // If the distance is not informed, start the function for get it
    if(trip.distanceMeter == 0.0){
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@h%@ (%@)",[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], @"Calcul ..."];
        
        // Function for get the distance between the start city and arrival city
        [[TripManager sharedInstance] getDistanceForTheTrip:trip completion:^(float totalDistance) {
            
            // Add distance response to the label
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@ (%1.0fkm)", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], trip.distanceMeter/1000];
        
        }];
    }
    else {
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@ (%1.0fkm)", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], trip.distanceMeter/1000];
    }
    
    // Get the driver of this trip
    User* driver = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
    
    // Add driver's data to this labels
    cell.wayLabel.text = [NSString stringWithFormat:@"%@ - %@", trip.start, trip.arrival];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d €", (int)trip.price];
    cell.driverLabel.text = [NSString stringWithFormat:@"%@ %@", driver.firstname, driver.lastname];
    cell.placeLabel.text = [NSString stringWithFormat:@"%d pl.", (int)trip.placeAvailable];
    
    return cell;
}

// Logout action
- (IBAction)logoutAction:(id)sender {
    
    // Request to API for disconnect the user
    [[UserManager sharedInstance] logoutToApiWithSuccessBlock:^(NSDictionary *responseJson) {
        
        // Next UIView
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"first"];
        
        // Transition UIView
        arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:arrivee animated:YES completion:nil];
        
    } error:^(NSDictionary *responseJson) {
        // API return an error
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
    } failure:^(NSError *error) {
        // Server don't respond
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
    }];
    
}

// Method for refresh the tableview with API
- (void)refreshTableView
{
    // Disable the scroller
    self.tableView.scrollEnabled = NO;
    
    // if this method has been execute with the RefreshControl
    if(self.refreshControl){
        
        // Format the date of last refresh
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMM, HH:mm"];
        NSString *title = [NSString stringWithFormat:@"Dernière mise à jour: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
    
    // Refresh trips with API
    [[TripManager sharedInstance] refreshTripsFromApi:^{
        
        // Reload data
        [self.tableView reloadData];
        // Stop refreshControl
        [self.refreshControl endRefreshing];
        // Enable the scroller
        self.tableView.scrollEnabled = YES;
    }];
    
}

// Function for show an alert with error message
- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

// On click on a cell, send data of the trip for show it on TripViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewTrip"]) {
        TripViewController *dest = segue.destinationViewController;
        
        // Get the cell clicked
        NSInteger cell = self.tableView.indexPathForSelectedRow.row;
        // Get the trip
        Trip* trip = [[TripManager sharedInstance] tripAtIndex:(int)cell];
        
        // Send data to the next view controller
        dest._trip = trip;
        dest._user = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
        dest.canReserve = NO;
    }
}


@end
