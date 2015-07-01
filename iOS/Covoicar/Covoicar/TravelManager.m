//
//  TravelManager.m
//  Covoicar
//
//  Created by Loris on 29/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "TravelManager.h"

#define STRING_CONSTANT @"MacrosCanBeEvil";

@implementation TravelManager {
    RLMResults* _travels;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _travels = [[Travel allObjects] sortedResultsUsingProperty:@"hourStart" ascending:YES];
    }
    return self;
}

+ (TravelManager*) sharedInstance {
    static TravelManager* instance = nil;
    
    if (instance == nil) {
        instance = [[TravelManager alloc] init];
    }
    
    return instance;
}

- (void) addOrUpdateTravel:(Travel *)travel {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:travel];
    [realm commitWriteTransaction];
    
    _travels = [Travel allObjects];
    
}

- (void) removeTravel:(Travel *)travel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:travel];
    [realm commitWriteTransaction];
    
    _travels = [Travel allObjects];
}

- (void) removeAllTravels {
    
    for (int i = 0; i < [self count]; i++)
    {
        Travel* travel = [self travelAtIndex:i];
        [self removeTravel:travel];
    }
    
    _travels = [Travel allObjects];
}

- (NSUInteger) count {
    if(_travels == nil)
        return 0;
    
    return _travels.count;
}

- (Travel*) travelAtIndex:(int)index {
    _travels = [Travel allObjects];
    
    NSUInteger nb = (NSUInteger)index;
    
    return [_travels objectAtIndex:nb];
}

- (BOOL) travelExistWithThisId:(int)identifier {
    _travels = [Travel allObjects];
    
    for(Travel* travel in _travels) {
        if (travel.id == identifier) {
            return true;
        }
    }
    
    return false;
}


- (Travel*) travelWithThisId:(int)identifier {
    _travels = [Travel allObjects];
    
    for(Travel* travel in _travels) {
        return travel;
    }
    
    return nil;
}


- (void) sendTravelToApiWithParameters:(NSDictionary*)parameters success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/trip/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            successBlock(jsonResponse);
        }
        else{
            errorBlock(jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}


- (void) refreshTravelsFromApi:(void (^)(void))completionBlock {
    
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
            
            //[[TravelManager sharedInstance] removeAllTravels];
            
            NSArray *allTravels = [jsonResponse objectForKey:@"data"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
            for (int i = 0; i < allTravels.count; i++) {
                NSDictionary *travel=[allTravels objectAtIndex:i];
                
                bool highway = ([[travel valueForKey:@"highway"] isEqualToString:@"1"]) ? true : false;
                
                [usermanager getUserFromApiWithId:[[travel valueForKey:@"driver"] intValue] completion:^{
                    Travel* newTravel = [Travel travelWithId:[[travel valueForKey:@"id"] intValue]
                                                      driver:[[travel valueForKey:@"driver"] intValue]
                                                       start:[travel valueForKey:@"start"]
                                                     arrival:[travel valueForKey:@"arrival"]
                                                     highway:highway
                                                   hourStart:[format dateFromString:[travel valueForKey:@"hourStart"]]
                                                       price:[[travel valueForKey:@"price"] integerValue]
                                                       place:[[travel valueForKey:@"place"] integerValue]
                                              placeAvailable:[[travel valueForKey:@"placeAvailable"] integerValue]
                                                     comment:[travel valueForKey:@"comment"]];
                    
                    [self addOrUpdateTravel:newTravel];
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

- (void) getDistanceForTheTravel:(Travel*)travel completion:(void (^)(float totalDistance))completionBlock {
    
    User* user = [[UserManager sharedInstance] getUserInstance];
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token":user.token, @"start":travel.start, @"arrival":travel.arrival};
    
    [manager POST:@"http://172.31.1.36:8888/covoicar/coordinate" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        NSLog(@"reponse getDistanceForTheTravel: %@", jsonResponse);
        
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
                    travel.distanceMeter = total;
                    [realm commitWriteTransaction];
                    
                    completionBlock(total);
                    
                }];
            }];
            
        }
        else{
            NSLog(@"getDistanceForTheTravel from api error = %@", jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getDistanceForTheTravel from api timeout = %@", error);
    }];
    
}

- (void) searchTravelsWithStart:(NSString*)start arrival:(NSString*)arrival hourStart:(NSDate*)hourStart completion:(void (^)(NSMutableArray* list))completionBlock {
    
    UserManager* usermanager = [UserManager sharedInstance];
    User* user = [usermanager getUserInstance];
    
    NSMutableArray* listTravels = [[NSMutableArray alloc] init];
    
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
            
            NSArray *allTravels = [jsonResponse objectForKey:@"data"];
            
            for (int i = 0; i < allTravels.count; i++) {
                NSDictionary *travel=[allTravels objectAtIndex:i];
                
                bool highway = ([[travel valueForKey:@"highway"] isEqualToString:@"1"]) ? true : false;
                
                [usermanager getUserFromApiWithId:[[travel valueForKey:@"driver"] intValue] completion:^{
                    
                }];
                
                Travel* newTravel = [Travel travelWithId:[[travel valueForKey:@"id"] intValue]
                                                  driver:[[travel valueForKey:@"driver"] intValue]
                                                   start:[travel valueForKey:@"start"]
                                                 arrival:[travel valueForKey:@"arrival"]
                                                 highway:highway
                                               hourStart:[format dateFromString:[travel valueForKey:@"hourStart"]]
                                                   price:[[travel valueForKey:@"price"] integerValue]
                                                   place:[[travel valueForKey:@"place"] integerValue]
                                          placeAvailable:[[travel valueForKey:@"placeAvailable"] integerValue]
                                                 comment:[travel valueForKey:@"comment"]];
                
                [listTravels addObject:newTravel];
            }
            
            completionBlock(listTravels);
            
        }
        else{
            NSLog(@"search travels from api error = %@", jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"search travels from api timeout = %@", error);
    }];
    
}

@end
