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
    
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self refreshTableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[TripManager sharedInstance] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    
    Trip* trip = [[TripManager sharedInstance] tripAtIndex:(int)indexPath.row];
    
    NSDate *date = trip.hourStart;
    NSDateFormatter *heureFormat = [[NSDateFormatter alloc] init];
    [heureFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:@"dd/MM"];
    
    
    if(trip.distanceMeter == 0.0){
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@h%@ (%@)",[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], @"Calcul ..."];
        
        [[TripManager sharedInstance] getDistanceForTheTrip:trip completion:^(float totalDistance) {
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@ (%1.0fkm)", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], trip.distanceMeter/1000];
        }];
    }
    else {
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@h%@ (%1.0fkm)", [dayFormat stringFromDate:date],[heureFormat stringFromDate:date], [minuteFormat stringFromDate:date], trip.distanceMeter/1000];
    }
    
    User* driver = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
    
    cell.wayLabel.text = [NSString stringWithFormat:@"%@ - %@", trip.start, trip.arrival];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d €", (int)trip.price];
    cell.driverLabel.text = [NSString stringWithFormat:@"%@ %@", driver.firstname, driver.lastname];
    cell.placeLabel.text = [NSString stringWithFormat:@"%d pl.", (int)trip.placeAvailable];
    
    return cell;
}

- (IBAction)logoutAction:(id)sender {
    
    [[UserManager sharedInstance] logoutToApiWithSuccessBlock:^(NSDictionary *responseJson) {
        
        // Next UIView
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"first"];
        
        // Transition UIView
        arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:arrivee animated:YES completion:nil];
        
    } error:^(NSDictionary *responseJson) {
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
    } failure:^(NSError *error) {
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
    }];
    
}

- (void)refreshTableView
{
    self.tableView.scrollEnabled = NO;
    
    if(self.refreshControl){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMM, HH:mm"];
        NSString *title = [NSString stringWithFormat:@"Dernière mise à jour: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
    
    [[TripManager sharedInstance] refreshTripsFromApi:^{
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        self.tableView.scrollEnabled = YES;
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewTrip"]) {
        TripViewController *dest = segue.destinationViewController;
        
        NSInteger cell = self.tableView.indexPathForSelectedRow.row;
        Trip* trip = [[TripManager sharedInstance] tripAtIndex:(int)cell];
        
        dest._trip = trip;
        dest._user = [[UserManager sharedInstance] userWithThisId:(int)trip.driver];
        dest.canReserve = NO;
    }
}


@end
