//
//  TripTableViewCell.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
