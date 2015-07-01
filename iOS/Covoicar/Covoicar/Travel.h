//
//  Travels.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "User.h"

@interface Travel : RLMObject

@property int id;

@property NSInteger driver;
@property NSString* start;
@property NSString* arrival;
@property float distanceMeter;

@property bool highway;
@property NSDate* hourStart;
@property NSInteger price;
@property NSInteger place;
@property NSInteger placeAvailable;
@property NSString* comment;

+ (Travel*) travelWithId:(int)id driver:(NSInteger)driver start:(NSString *)start arrival:(NSString *)arrival highway:(bool)highway hourStart:(NSDate *)hourStart price:(NSInteger)price place:(NSInteger)place placeAvailable:(NSInteger)placeAvailable comment:(NSString *)comment;

- (instancetype) initWithId:(int)id driver:(NSInteger)driver start:(NSString *)start arrival:(NSString *)arrival highway:(bool)highway hourStart:(NSDate *)hourStart price:(NSInteger)price place:(NSInteger)place placeAvailable:(NSInteger)placeAvailable comment:(NSString *)comment;

@end
