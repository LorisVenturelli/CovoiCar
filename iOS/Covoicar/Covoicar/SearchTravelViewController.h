//
//  SearchTravelViewController.h
//  Covoicar
//
//  Created by Loris on 30/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TravelManager.h"
#import "TravelTableViewCell.h"
#import "TravelViewController.h"

@interface SearchTravelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong) NSMutableArray* _travels;

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalField;
@property (weak, nonatomic) IBOutlet UITextField *hourStartField;

- (IBAction)submitAction:(id)sender;

- (void)refreshTableView;

@end
