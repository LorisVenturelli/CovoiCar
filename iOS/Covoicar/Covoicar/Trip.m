//
//  Trip.m
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "Trip.h"

@implementation Trip

+ (NSString*)primaryKey {
    return @"id";
}

- (instancetype) initWithId:(int)id driver:(NSInteger)driver start:(NSString *)start arrival:(NSString *)arrival highway:(bool)highway hourStart:(NSDate *)hourStart price:(NSInteger)price place:(NSInteger)place placeAvailable:(NSInteger)placeAvailable comment:(NSString *)comment
{
    self = [super init];
    if (self != nil) {
        
        self.id = id;
        
        if(hourStart == nil)
            hourStart = [[NSDate alloc] init];
        
        self.driver = driver;
        self.start = start;
        self.arrival = arrival;
        self.highway = highway;
        self.hourStart = hourStart;
        self.price = *(&(price));
        self.place = *(&(place));
        self.placeAvailable = placeAvailable;
        self.comment = comment;
        
    }
    return self;
}

+ (Trip*) tripWithId:(int)id driver:(NSInteger)driver start:(NSString *)start arrival:(NSString *)arrival highway:(bool)highway hourStart:(NSDate *)hourStart price:(NSInteger)price place:(NSInteger)place placeAvailable:(NSInteger)placeAvailable comment:(NSString *)comment {
    
    return [[Trip alloc] initWithId:id driver:driver start:start arrival:arrival highway:highway hourStart:hourStart price:price place:place placeAvailable:placeAvailable comment:comment];
}

@end
RLM_ARRAY_TYPE(Trip)