//
//  TripViewController.m
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TripViewController.h"

@interface TripViewController ()

@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If the user show one of this trip
    if(!self.canReserve) {
        
        // Delete the UIView with the button to reserve
        [self.reserveView removeFromSuperview];
        
        // Add a contraint for the containerView to bottomLayoutGuide
        NSArray * contraintBottom = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bottomLayoutGuide]-0-[containerView]|" options:0 metrics:nil views:@{@"containerView": self.containerView, @"bottomLayoutGuide":self.bottomLayoutGuide}];
        [self.view addConstraints:contraintBottom];
    }
    
    // Init the activityIndicator to hidden
    [self hideActivityIndicator];
}

// Send the data to the containerView
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EmbedSegue"]) {
        TripTableViewController *embed = segue.destinationViewController;
        
        // Send data
        embed._trip = self._trip;
        embed._user = self._user;
        embed.canReserve = self.canReserve;
    }
}

- (IBAction)reserveAction:(id)sender {
    
    // Show the activityIndicator
    [self showActivityIndicator];
    
    // Send to API the question for reserve this trip
    [[TripManager sharedInstance] reserveTheTrip:self._trip success:^(NSDictionary *responseJson) {
        
        // Show a alertView for confirm the successfully of the demand if the server return "success"
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo !" message:[NSString stringWithFormat:@"Vous avez rejoint le voyage de %@ à %@ !", self._trip.start , self._trip.arrival] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        // Go to the user's trip list
        [self.tabBarController setSelectedIndex:0];
        
        // Hide de the activityIndicator
        [self hideActivityIndicator];
        
    } error:^(NSDictionary *responseJson) {
        // API return an error
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        [self hideActivityIndicator];
    } failure:^(NSError *error) {
        // The server don't responding
        [self ShowAlertErrorWithMessage:@"Le serveur ne répond pas .."];
        [self hideActivityIndicator];
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

// Method for show and start ActivityIndicator
- (void)showActivityIndicator{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

// Method for hide and stop ActivityIndicator
- (void)hideActivityIndicator{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}

@end
