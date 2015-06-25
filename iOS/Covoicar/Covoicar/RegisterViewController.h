//
//  RegisterViewController.h
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

-(void)registerAction:(NSNotification *)notification;
- (IBAction)registerButton:(id)sender;

@end