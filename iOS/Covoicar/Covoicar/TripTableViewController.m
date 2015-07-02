//
//  TripTableViewController.m
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TripTableViewController.h"

@interface TripTableViewController () {
    User* _userInstance;
}

@end

@implementation TripTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide Activity Indicator
    [self hideActivityIndicator];
    
    // Get and init the user instance
    _userInstance = [[UserManager sharedInstance] getUserInstance];
    
    // Change text on button if the userInstance is not the driver
    if((int)self._trip.driver != _userInstance.id)
        [self.deleteTravelButton setTitle:@"Annuler la réservation" forState:UIControlStateNormal];
    
    // Trip's date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy HH:mm"];
    self.dateField.text = [formatter stringFromDate:__trip.hourStart];
    
    // Start and arrival field
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
    
    // Distance between city start and city arrival
    if(__trip.distanceMeter == 0.0){
        
        self.distanceField.text = @"Calcul ...";
        
        [[TripManager sharedInstance] getDistanceForTheTrip:__trip completion:^(float totalDistance) {
            self.distanceField.text = [NSString stringWithFormat:@"%1.0fkm", totalDistance/1000];
        }];
    }
    else {
        self.distanceField.text = [NSString stringWithFormat:@"%1.0fkm", self._trip.distanceMeter/1000];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.canReserve)
        return 3;
    
    return 4;
}

- (IBAction)deleteTravel:(id)sender {
    
    [self showActivityIndicator];
    
    [[TripManager sharedInstance] deleteTheTripOrTheReservation:self._trip success:^(NSDictionary *responseJson) {
        
        [self hideActivityIndicator];
        
        [[self navigationController] popViewControllerAnimated:YES];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo" message:[responseJson valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];

        
    } error:^(NSDictionary *responseJson) {
        
        [self hideActivityIndicator];
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        
    } failure:^(NSError *error) {
        
        [self hideActivityIndicator];
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
        
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}
- (void)showActivityIndicator{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}
- (void)hideActivityIndicator{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}

@end
