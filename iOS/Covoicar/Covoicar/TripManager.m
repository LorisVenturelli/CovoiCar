//
//  TripManager.m
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TripManager.h"

#define STRING_CONSTANT @"MacrosCanBeEvil";

@implementation TripManager {
    RLMResults* _trips;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _trips = [[Trip allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
    }
    return self;
}

+ (TripManager*) sharedInstance {
    static TripManager* instance = nil;
    
    if (instance == nil) {
        instance = [[TripManager alloc] init];
    }
    
    return instance;
}

- (void) addOrUpdateTrip:(Trip *)trip {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:trip];
    [realm commitWriteTransaction];
    
    _trips = [[Trip allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
    
}

- (void) removeTrip:(Trip *)trip {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:trip];
    [realm commitWriteTransaction];
    
    _trips = [[Trip allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
}

- (void) removeAllTrips {
    _trips = [Trip allObjects];
    
    for (int i = 0; i < _trips.count; i++)
    {
        Trip* trip = [self tripAtIndex:i];
        [self removeTrip:trip];
    }
    
    _trips = [Trip allObjects];
}

- (NSUInteger) count {
    if(_trips == nil)
        return 0;
    
    return _trips.count;
}

- (Trip*) tripAtIndex:(int)index {
    _trips = [[Trip allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
    
    NSUInteger nb = (NSUInteger)index;
    
    return [_trips objectAtIndex:nb];
}

- (BOOL) tripExistWithThisId:(int)identifier {
    _trips = [[Trip allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
    
    for(Trip* trip in _trips) {
        if (trip.id == identifier) {
            return true;
        }
    }
    
    return false;
}


- (Trip*) tripWithThisId:(int)identifier {
    _trips = [[Trip allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
    
    for(Trip* trip in _trips) {
        return trip;
    }
    
    return nil;
}


- (void) sendTripToApiWithParameters:(NSDictionary*)parameters success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    UserManager* usermanager = [UserManager sharedInstance];
    User* user = [usermanager getUserInstance];
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/trip/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            NSArray *dataNewTrip = [jsonResponse objectForKey:@"data"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            bool highway = ([[parameters valueForKey:@"highway"] isEqualToString:@"1"]) ? true : false;
            
            Trip* newTrip = [Trip tripWithId:[[dataNewTrip valueForKey:@"id"] intValue]
                                      driver:user.id
                                       start:[parameters valueForKey:@"start"]
                                     arrival:[parameters valueForKey:@"arrival"]
                                     highway:highway
                                   hourStart:[format dateFromString:[parameters valueForKey:@"hourStart"]]
                                       price:[[parameters valueForKey:@"price"] integerValue]
                                       place:[[parameters valueForKey:@"place"] integerValue]
                              placeAvailable:[[parameters valueForKey:@"place"] integerValue]
                                     comment:[parameters valueForKey:@"comment"]];
            
            [self addOrUpdateTrip:newTrip];
            
            successBlock(jsonResponse);
        }
        else{
            errorBlock(jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}


- (void) refreshTripsFromApi:(void (^)(void))completionBlock {
    
    UserManager* usermanager = [UserManager sharedInstance];
    User* user = [usermanager getUserInstance];
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token":user.token};
    [manager POST:@"http://172.31.1.36:8888/covoicar/travel/list" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            NSLog(@"travels from api = %@", jsonResponse);
            
            //[[TripManager sharedInstance] removeAllTrips];
            
            NSArray *allTrips = [jsonResponse objectForKey:@"data"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
            for (int i = 0; i < allTrips.count; i++) {
                NSDictionary *trip=[allTrips objectAtIndex:i];
                
                bool highway = ([[trip valueForKey:@"highway"] isEqualToString:@"1"]) ? true : false;
                
                [usermanager getUserFromApiWithId:[[trip valueForKey:@"driver"] intValue] completion:^{
                    Trip* newTrip = [Trip tripWithId:[[trip valueForKey:@"id"] intValue]
                                                      driver:[[trip valueForKey:@"driver"] intValue]
                                                       start:[trip valueForKey:@"start"]
                                                     arrival:[trip valueForKey:@"arrival"]
                                                     highway:highway
                                                   hourStart:[format dateFromString:[trip valueForKey:@"hourStart"]]
                                                       price:[[trip valueForKey:@"price"] integerValue]
                                                       place:[[trip valueForKey:@"place"] integerValue]
                                              placeAvailable:[[trip valueForKey:@"placeAvailable"] integerValue]
                                                     comment:[trip valueForKey:@"comment"]];
                    
                    [self addOrUpdateTrip:newTrip];
                }];
            }
            
            completionBlock();
            
        }
        else{
            NSLog(@"travels from api error = %@", jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"travels from api timeout = %@", error);
    }];
    
}

- (void) getDistanceForTheTrip:(Trip*)trip completion:(void (^)(float totalDistance))completionBlock {
    
    User* user = [[UserManager sharedInstance] getUserInstance];
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token":user.token, @"start":trip.start, @"arrival":trip.arrival};
    
    [manager POST:@"http://172.31.1.36:8888/covoicar/coordinate" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        NSLog(@"reponse getDistanceForTheTrip: %@", jsonResponse);
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            __block float total = 0.0;
            
            NSDictionary* data = [jsonResponse objectForKey:@"data"];
            
            MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
            
            // Make the source
            NSDictionary* start = [data objectForKey:@"start"];
            CLLocationDegrees startLatitude = [[start valueForKey:@"latitude"] doubleValue];
            CLLocationDegrees startLongitude = [[start valueForKey:@"longitude"] doubleValue];
            
            CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(startLatitude, startLongitude);
            MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
            MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
            
            
            // Make the destination
            NSDictionary* arrival = [data objectForKey:@"arrival"];
            CLLocationDegrees arrivalLatitude = [[arrival valueForKey:@"latitude"] doubleValue];
            CLLocationDegrees arrivalLongitude = [[arrival valueForKey:@"longitude"] doubleValue];
            CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(arrivalLatitude, arrivalLongitude);
            MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
            
            
            // Set the source and destination on the request
            [directionsRequest setSource:source];
            [directionsRequest setDestination:destination];
            MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
            
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                
                NSArray *arrRoutes = [response routes];
                
                [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    MKRoute *rout = obj;
                    NSArray *steps = [rout steps];
                    
                    [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        total = total + [obj distance];
                    }];
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    trip.start = [start valueForKey:@"name"];
                    trip.arrival = [arrival valueForKey:@"name"];
                    trip.distanceMeter = total;
                    [realm commitWriteTransaction];
                    
                    completionBlock(total);
                    
                }];
            }];
            
        }
        else{
            NSLog(@"getDistanceForTheTrip from api error = %@", jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getDistanceForTheTrip from api timeout = %@", error);
    }];
    
}

- (void) searchTripsWithStart:(NSString*)start arrival:(NSString*)arrival hourStart:(NSDate*)hourStart success:(void (^)(NSMutableArray* list))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    UserManager* usermanager = [UserManager sharedInstance];
    User* user = [usermanager getUserInstance];
    
    NSMutableArray* listTrips = [[NSMutableArray alloc] init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString* time = [format stringFromDate:hourStart];
    
    if(time == nil)
        time = @"";
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token":user.token, @"start":start, @"arrival":arrival, @"time":time};
    [manager POST:@"http://172.31.1.36:8888/covoicar/trip/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            
            NSArray *allTrips = [jsonResponse objectForKey:@"data"];
            
            for (int i = 0; i < allTrips.count; i++) {
                NSDictionary *trip=[allTrips objectAtIndex:i];
                
                bool highway = ([[trip valueForKey:@"highway"] isEqualToString:@"1"]) ? true : false;
                
                [usermanager getUserFromApiWithId:[[trip valueForKey:@"driver"] intValue] completion:^{
                    
                }];
                
                Trip* newTrip = [Trip tripWithId:[[trip valueForKey:@"id"] intValue]
                                                  driver:[[trip valueForKey:@"driver"] intValue]
                                                   start:[trip valueForKey:@"start"]
                                                 arrival:[trip valueForKey:@"arrival"]
                                                 highway:highway
                                               hourStart:[format dateFromString:[trip valueForKey:@"hourStart"]]
                                                   price:[[trip valueForKey:@"price"] integerValue]
                                                   place:[[trip valueForKey:@"place"] integerValue]
                                          placeAvailable:[[trip valueForKey:@"placeAvailable"] integerValue]
                                                 comment:[trip valueForKey:@"comment"]];
                
                [listTrips addObject:newTrip];
            }
            
            successBlock(listTrips);
        }
        else{
            errorBlock(jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}


- (void) reserveTheTrip:(Trip*)trip success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    UserManager* usermanager = [UserManager sharedInstance];
    User* user = [usermanager getUserInstance];
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token":user.token, @"id_trip":[NSString stringWithFormat:@"%d", trip.id]};
    [manager POST:@"http://172.31.1.36:8888/covoicar/travel/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            trip.placeAvailable -= 1;
            
            [self addOrUpdateTrip:trip];
            
            successBlock(jsonResponse);
        }
        else{
            errorBlock(jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}


- (void) deleteTheTripOrTheReservation:(Trip*)trip success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    UserManager* usermanager = [UserManager sharedInstance];
    User* user = [usermanager getUserInstance];
    
    NSString* url = @"http://172.31.1.36:8888/covoicar/travel/delete";
    
    if((int)trip.driver == user.id)
        url = @"http://172.31.1.36:8888/covoicar/trip/delete";
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token":user.token, @"id_trip":[NSString stringWithFormat:@"%d", trip.id]};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            [self removeTrip:trip];
            
            successBlock(jsonResponse);
        }
        else{
            errorBlock(jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}

@end
