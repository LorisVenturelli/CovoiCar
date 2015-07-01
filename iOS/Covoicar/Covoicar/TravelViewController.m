//
//  TravelViewController.m
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TravelViewController.h"

@interface TravelViewController ()

@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.canReserve) {
        [self.reserveView removeFromSuperview];
        
        NSArray * contraintBottom = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bottomLayoutGuide]-0-[containerView]|" options:0 metrics:nil views:@{@"containerView": self.containerView, @"bottomLayoutGuide":self.bottomLayoutGuide}];
        [self.view addConstraints:contraintBottom];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EmbedSegue"]) {
        TravelTableViewController *embed = segue.destinationViewController;
        embed._travel = self._travel;
        embed._user = self._user;
    }
}

- (IBAction)reserveAction:(id)sender {
    
}

@end
