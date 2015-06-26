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
    
    self.navigationItem.title = @"Proposer un trajet";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)roundTripAction:(id)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    
    [cell setHidden:!cell.hidden];
    self.roundTripField.text = @"";
}

- (IBAction)submitAction:(UIButton *)sender {
    [self addTripAction:nil];
}

- (IBAction)submitTabBarAction:(id)sender {
    [self addTripAction:nil];
}

- (void)addTripAction:(NSNotification *)notification{
    
    User* user = [[UserManager sharedInstance] getUserInstance];
    
    NSString* highway = @"0";
    
    if(self.highwaySwitch.isOn)
        highway = @"1";
    
    NSDictionary *parameters = @{@"token":user.token,
                                 @"start":self.startField.text,
                                 @"arrival":self.arrivalField.text,
                                 @"highway":highway,
                                 @"hourStart":self.hourStartField.text,
                                 @"roundTrip":self.roundTripField.text,
                                 @"price":self.priceField.text,
                                 @"place":self.placeField.text,
                                 @"comment":self.commentField.text};
    
    NSLog(@"register action void : %@", parameters);
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/trip/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo !" message:[jsonResponse valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            /*// Next UIView
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            
            // Transition UIView
            arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:arrivee animated:YES completion:nil];*/
        }
        else{
            // Error login
            [self ShowAlertErrorWithMessage:[jsonResponse valueForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
    }];

}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

-(IBAction)datePickerBtnAction:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *) sender;
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0,10, 50)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
    self.navigationItem.rightBarButtonItem=rightBtn;
}
-(void)LabelTitle:(id)sender
{
    NSLog(@"label title");
}

-(void)save:(id)sender
{
    NSLog(@"Save");
}



@end
