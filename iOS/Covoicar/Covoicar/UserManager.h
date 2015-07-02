//
//  UserManager.h
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "AFNetworking.h"
#import "User.h"
#import "TripManager.h"

@interface UserManager : NSObject

@property NSNumber* idUserInstance;

// Instance of UserManager
+ (UserManager*) sharedInstance;

// Manage user
- (void) setUserInstance:(User *)userInstance;
- (User*) getUserInstance;
- (BOOL) userIsInstancied;

- (void) addOrUpdateUser:(User*)user;
- (void) removeUser:(User*)user;

- (NSUInteger) count;
- (User*) userAtIndex:(int)index;
- (BOOL) userExistWithThisId:(int)identifier;
- (User*) userWithThisId:(int)identifier;

// Methods for API
- (void) getUserFromApiWithId:(int)identifier completion:(void (^)(void))completionBlock;
- (void) registerToApi:(NSDictionary*)parameters success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;
- (void) connectToApiWithEmail:(NSString*)email AndPassword:(NSString*)password success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;

- (void) logoutToApiWithSuccessBlock:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock;

@end
