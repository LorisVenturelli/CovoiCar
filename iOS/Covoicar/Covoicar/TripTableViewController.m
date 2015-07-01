//
//  TripTableViewController.m
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TripTableViewController.h"

@interface TripTableViewController ()

@end

@implementation TripTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentField.editable = NO;
    self.bioField.editable = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM HH:mm"];
    self.dateField.text = [formatter stringFromDate:__trip.hourStart];
    
    self.startField.text = __trip.start;
    self.arrivalField.text = __trip.arrival;
    
    // Highway
    if(!__trip.highway)
        self.highwayImage.hidden = YES;
    
    self.placeField.text = [NSString stringWithFormat:@"%ld", (long)__trip.placeAvailable];
    self.priceField.text = [NSString stringWithFormat:@"%ld€", (long)__trip.price];
    
    // Trip comment
    self.commentField.text = __trip.comment;
    if([self.commentField.text isEqualToString:@""])
        self.commentField.text = @"Aucune description sur ce voyage.";
    
    // Driver's name
    self.nameField.text = [NSString stringWithFormat:@"%@ %@", __user.firstname, __user.lastname];
    
    // Driver's phone
    self.phoneField.text = __user.phone;
    if([self.phoneField.text isEqualToString:@""])
        self.phoneField.text = @"Pas de téléphone";
    
    // Driver's mail
    self.emailField.text = __user.email;
    
    // Biography of driver
    self.bioField.text = __user.bio;
    if([self.bioField.text isEqualToString:@""])
        self.bioField.text = @"Aucune biographie.";
    
}



@end
