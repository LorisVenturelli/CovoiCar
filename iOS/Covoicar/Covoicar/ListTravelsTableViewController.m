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
    [self.tableView reloadData];
    
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of sections.
    NSNumber* count = [NSNumber numberWithUnsignedInteger:[[TravelManager sharedInstance] count]];
    if (count == 0) {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
        
    }
    
    return [[TravelManager sharedInstance] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCell" forIndexPath:indexPath];
    
    Travel* travel = [[TravelManager sharedInstance] travelAtIndex:(int)indexPath.row];
    
    NSDate *date         = travel.hourStart;
    NSDateFormatter *heureFormat = [[NSDateFormatter alloc] init];
    [heureFormat setDateFormat:@"hh"];
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
    
    
    
    cell.wayLabel.text = [NSString stringWithFormat:@"%@ - %@", travel.start, travel.arrival];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d €", (int)travel.price];
    cell.driverLabel.text = [NSString stringWithFormat:@"%@ %@", travel.driver.firstname, travel.driver.lastname];
    
    return cell;
}

- (void)refreshTableView
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        self.tableView.scrollEnabled = NO;
        
        [[TravelManager sharedInstance] refreshTravelsFromApi:^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"d MMM, HH:mm"];
            NSString *title = [NSString stringWithFormat:@"Dernière mise à jour: %@", [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            self.tableView.scrollEnabled = YES;
        }];
        
    }
}


@end
