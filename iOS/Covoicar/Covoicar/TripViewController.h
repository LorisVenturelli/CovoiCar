//
//  TripViewController.h
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TripManager.h"
#import "TripTableViewController.h"

@interface TripViewController : UIViewController

@property BOOL canReserve;

@property User* _user;
@property Trip* _trip;

@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIView *reserveView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)reserveAction:(id)sender;

@end
