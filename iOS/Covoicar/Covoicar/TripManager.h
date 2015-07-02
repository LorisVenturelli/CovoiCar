//
//  TripManager.h
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <MapKit/MapKit.h>
#import "UserManager.h"
#import "Trip.h"
#import "AFNetworking.h"

@interface TripManager : NSObject

+ (TripManager*) sharedInstance;

- (void) addOrUpdateTrip:(Trip*)trip;
- (void) removeTrip:(Trip*)trip;
- (void) removeAllTrips;

- (NSUInteger) count;
- (Trip*) tripAtIndex:(int)index;
- (BOOL) tripExistWithThisId:(int)identifier;
- (Trip*) tripWithThisId:(int)identifier;

- (void) refreshTripsFromApi:(void (^)(void))completionBlock;
- (void) getDistanceForTheTrip:(Trip*)trip completion:(void (^)(float totalDistance))completionBlock;
- (void) sendTripToApiWithParameters:(NSDictionary*)parameters success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;
- (void) searchTripsWithStart:(NSString*)start arrival:(NSString*)arrival hourStart:(NSDate*)hourStart success:(void (^)(NSMutableArray* list))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;
- (void) reserveTheTrip:(Trip*)trip success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;
- (void) deleteTheTripOrTheReservation:(Trip*)trip success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;

@end
