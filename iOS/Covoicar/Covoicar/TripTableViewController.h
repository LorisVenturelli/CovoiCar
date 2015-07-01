//
//  TripTableViewController.h
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TripManager.h"

@interface TripTableViewController : UITableViewController


@property Trip* _trip;

@property (weak, nonatomic) IBOutlet UILabel *dateField;
@property (weak, nonatomic) IBOutlet UILabel *startField;
@property (weak, nonatomic) IBOutlet UILabel *arrivalField;
@property (weak, nonatomic) IBOutlet UILabel *placeField;
@property (weak, nonatomic) IBOutlet UILabel *priceField;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (weak, nonatomic) IBOutlet UIImageView *highwayImage;

@property User* _user;

@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *phoneField;
@property (weak, nonatomic) IBOutlet UILabel *emailField;
@property (weak, nonatomic) IBOutlet UITextView *bioField;


@end
