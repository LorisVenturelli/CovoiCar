//
//  RegisterTableViewController.m
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "RegisterTableViewController.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitRegister:) name:@"sendRegister" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)submitRegister:(NSNotification *)notification{
    NSDictionary *parameters = @{@"email":self.emailField.text,
                                 @"password":self.passwordField.text,
                                 @"repassword":self.rePasswordField.text,
                                 @"lastname":self.lastNameField.text,
                                 @"firstname":self.firstNameField.text,
                                 @"gender":@"1",
                                 @"birthday":self.birthdayField.text};
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerAction" object:self userInfo:parameters];
}

- (IBAction)submitAction:(id)sender {
    
    NSLog(@"submit register click");
    
    [self submitRegister:nil];
}

@end
