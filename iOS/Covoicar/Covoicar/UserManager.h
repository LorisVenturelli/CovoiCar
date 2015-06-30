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

@interface UserManager : NSObject

@property int idUserInstance;

+ (UserManager*) sharedInstance;

- (void) setUserInstance:(User *)userInstance;
- (User*) getUserInstance;
- (BOOL) userIsInstancied;

- (void) addOrUpdateUser:(User*)user;
- (void) removeUser:(User*)user;

- (NSUInteger) count;
- (User*) userAtIndex:(int)index;
- (BOOL) userExistWithThisId:(int)identifier;
- (User*) userWithThisId:(int)identifier;
- (void) getUserFromApiWithId:(int)identifier completion:(void (^)(void))completionBlock;

@end
