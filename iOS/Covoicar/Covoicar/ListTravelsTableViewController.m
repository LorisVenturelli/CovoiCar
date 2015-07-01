//
//  ListTravelsTableViewController.m
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "ListTravelsTableViewController.h"

@interface ListTravelsTableViewController ()

@end

@implementation ListTravelsTableViewController

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
    return [[TravelManager sharedInstance] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCell" forIndexPath:indexPath];
    
    Travel* travel = [[TravelManager sharedInstance] travelAtIndex:(int)indexPath.row];
    
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
    
    [[TravelManager sharedInstance] refreshTravelsFromApi:^{
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        self.tableView.scrollEnabled = YES;
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}


@end
