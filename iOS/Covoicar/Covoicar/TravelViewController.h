//
//  TravelViewController.h
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TravelManager.h"
#import "TravelTableViewController.h"

@interface TravelViewController : UIViewController

@property BOOL canReserve;

@property User* _user;
@property Travel* _travel;

@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIView *reserveView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)reserveAction:(id)sender;

@end
