//
//  Trips.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "User.h"

@interface Trip : RLMObject

// Identifier of trip
@property int id;

// Id driver of the trip
@property NSInteger driver;
// City start
@property NSString* start;
// City arrival
@property NSString* arrival;
// Total distance on meter
@property float distanceMeter;

// Trip by highway
@property bool highway;
// Date to start the trip
@property NSDate* hourStart;
// Price per place
@property NSInteger price;
// Max of place on the car
@property NSInteger place;
// Place's number available
@property NSInteger placeAvailable;
// Comment of the trip
@property NSString* comment;

// Instance the trip
- (instancetype) initWithId:(int)id driver:(NSInteger)driver start:(NSString *)start arrival:(NSString *)arrival highway:(bool)highway hourStart:(NSDate *)hourStart price:(NSInteger)price place:(NSInteger)place placeAvailable:(NSInteger)placeAvailable comment:(NSString *)comment;

// Construct the trip
+ (Trip*) tripWithId:(int)id driver:(NSInteger)driver start:(NSString *)start arrival:(NSString *)arrival highway:(bool)highway hourStart:(NSDate *)hourStart price:(NSInteger)price place:(NSInteger)place placeAvailable:(NSInteger)placeAvailable comment:(NSString *)comment;

@end
