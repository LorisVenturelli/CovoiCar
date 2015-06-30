//
//  TravelManager.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <MapKit/MapKit.h>
#import "UserManager.h"
#import "Travel.h"
#import "AFNetworking.h"

@interface TravelManager : NSObject

+ (TravelManager*) sharedInstance;

- (void) addOrUpdateTravel:(Travel*)travel;
- (void) removeTravel:(Travel*)travel;
- (void) removeAllTravels;

- (NSUInteger) count;
- (Travel*) travelAtIndex:(int)index;
- (BOOL) travelExistWithThisId:(int)identifier;
- (Travel*) travelWithThisId:(int)identifier;

- (void) refreshTravelsFromApi:(void (^)(void))completionBlock;
- (void) getDistanceForTheTravel:(Travel*)travel completion:(void (^)(float totalDistance))completionBlock;
- (void) sendTravelToApiWithParameters:(NSDictionary*)parameters success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;
- (void) searchTravelsWithStart:(NSString*)start arrival:(NSString*)arrival hourStart:(NSDate*)hourStart completion:(void (^)(NSMutableArray* list))completionBlock;

@end
