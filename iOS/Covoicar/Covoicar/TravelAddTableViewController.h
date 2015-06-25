//
//  TravelAddTableViewController.h
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelAddTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalField;
@property (weak, nonatomic) IBOutlet UISwitch *highwaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *roundTripSwitch;
@property (weak, nonatomic) IBOutlet UITextField *hourStartField;
@property (weak, nonatomic) IBOutlet UITextField *roundTripField;

- (IBAction)submitAction:(UIButton *)sender;

- (void)addTripAction:(NSNotification *)notification;

@end
