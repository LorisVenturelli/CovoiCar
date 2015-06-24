//
//  UserManager.m
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager {
    RLMResults* _users;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _users = [User allObjects];
    }
    return self;
}

+ (UserManager*) sharedInstance {
    static UserManager* instance = nil;
    
    if (instance == nil) {
        instance = [[UserManager alloc] init];
    }
    
    return instance;
}


- (void) setUserInstance:(User *)userInstance{
    [[UserManager sharedInstance] addUser:userInstance];
    self.idUserInstance = userInstance.id;
}

- (User*) getUserInstance{
    return [[UserManager sharedInstance] userWithThisId:self.idUserInstance];
}


- (void) addUser:(User*)user {
    
    if([self userExistWithThisId:user.id] == false){
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:user];
        [realm commitWriteTransaction];
        
        _users = [User allObjects];
    
    }
    
}

- (void) removeUser:(User *)user {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:user];
    [realm commitWriteTransaction];
    
    _users = [User allObjects];
}

- (NSUInteger) count {
    if(_users == nil)
        return 0;
    
    return _users.count;
}

- (User*) userAtIndex:(int)index {
    _users = [User allObjects];
    
    NSUInteger nb = (NSUInteger)index;
    
    return [_users objectAtIndex:nb];
}


- (BOOL) userExistWithThisId:(int)identifier {
    _users = [User allObjects];
    
    for(User* user in _users) {
        if (user.id == identifier) {
            return true;
        }
    }
    
    return false;
}


- (User*) userWithThisId:(int)identifier {
    _users = [User allObjects];
    
    for(User* user in _users) {
        if (user.id == identifier) {
            return user;
        }
    }
    
    return nil;
}

@end
