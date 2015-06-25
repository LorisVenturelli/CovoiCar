//
//  TravelAddTableViewController.m
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TravelAddTableViewController.h"

@interface TravelAddTableViewController ()

@end

@implementation TravelAddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTripAction:) name:@"addTripAction" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)submitAction:(UIButton *)sender {
    [self addTripAction:nil];
}

- (void)addTripAction:(NSNotification *)notification{
    
    NSString* highway = @"0";
    
    if(self.highwaySwitch.isOn)
        highway = @"1";
    
    NSDictionary *parameters = @{@"start":self.startField.text,
                                 @"arrival":self.arrivalField.text,
                                 @"highway":highway,
                                 @"hourStart":self.hourStartField.text,
                                 @"roundTrip":self.roundTripField.text};
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerAction" object:self userInfo:parameters];
}

@end
