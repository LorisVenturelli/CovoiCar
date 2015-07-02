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
    
    if(!self.canReserve) {
        [self.reserveView removeFromSuperview];
        
        NSArray * contraintBottom = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bottomLayoutGuide]-0-[containerView]|" options:0 metrics:nil views:@{@"containerView": self.containerView, @"bottomLayoutGuide":self.bottomLayoutGuide}];
        [self.view addConstraints:contraintBottom];
    }
    
    [self hideActivityIndicator];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EmbedSegue"]) {
        TripTableViewController *embed = segue.destinationViewController;
        embed._trip = self._trip;
        embed._user = self._user;
        embed.canReserve = self.canReserve;
    }
}

- (IBAction)reserveAction:(id)sender {
    
    [self showActivityIndicator];
    
    [[TripManager sharedInstance] reserveTheTrip:self._trip success:^(NSDictionary *responseJson) {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo !" message:[NSString stringWithFormat:@"Vous avez rejoint le voyage de %@ à %@ !", self._trip.start , self._trip.arrival] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        // Go to the user's trip list
        [self.tabBarController setSelectedIndex:0];
        
        [self hideActivityIndicator];
        
    } error:^(NSDictionary *responseJson) {
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        [self hideActivityIndicator];
    } failure:^(NSError *error) {
        [self ShowAlertErrorWithMessage:@"Le serveur ne répond pas .."];
        [self hideActivityIndicator];
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
