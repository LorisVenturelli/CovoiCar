//
//  UserManager.h
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "User.h"

@interface UserManager : NSObject

@property int idUserInstance;

- (void) setUserInstance:(User *)userInstance;
- (User*) getUserInstance;
- (BOOL) userIsInstancied;

+ (UserManager*) sharedInstance;

- (void) addUser:(User*)user;
- (void) removeUser:(User*)user;

- (NSUInteger) count;
- (User*) userAtIndex:(int)index;


@end
