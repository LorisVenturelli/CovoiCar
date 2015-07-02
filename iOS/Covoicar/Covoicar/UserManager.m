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

- (void)loadNSUserDefaultsForUserInstance {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences objectForKey:@"idUserInstance"] != nil)
    {
        self.idUserInstance = [preferences objectForKey:@"idUserInstance"];
    }
}


- (void) setUserInstance:(User *)userInstance {
    [self addOrUpdateUser:userInstance];
    self.idUserInstance = [NSNumber numberWithInt:userInstance.id];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:self.idUserInstance forKey:@"idUserInstance"];
    //  Save to disk
    BOOL didSave = [preferences synchronize];
    
    if (!didSave)
        NSLog(@"NSUserDefaults not save with id %@", self.idUserInstance);
    else
        NSLog(@"NSUserDefaults has save with id %@", self.idUserInstance);
}

- (User*) getUserInstance{
    
    [self loadNSUserDefaultsForUserInstance];
    
    if(self.idUserInstance != nil)
        return [self userWithThisId:[self.idUserInstance intValue]];
    
    return nil;
}

- (BOOL) userIsInstancied{
    
    [self loadNSUserDefaultsForUserInstance];
    
    bool ret = (self.idUserInstance != nil && [self userExistWithThisId:[self.idUserInstance intValue]] == true);
    
    if(ret)
        NSLog(@"User is instancied !");
    else
        NSLog(@"User is not instancied : %@", self.idUserInstance);
    
    return ret;
}

- (void)deleteUserInstance {
    self.idUserInstance = nil;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:nil forKey:@"idUserInstance"];
    [preferences synchronize];
}

- (void) addOrUpdateUser:(User*)user {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:user];
    [realm commitWriteTransaction];
    
    _users = [User allObjects];
    
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

- (void) getUserFromApiWithId:(int)identifier completion:(void (^)(void))completionBlock {
    
    User* user = [self getUserInstance];
    
    // HTTP POST
    NSDictionary *parameters = @{@"token":user.token, @"userid":[NSString stringWithFormat:@"%d", identifier]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/user/getbyid" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        NSArray *dataUser = [jsonResponse objectForKey:@"data"];
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            int gender = 1;
            if([[dataUser valueForKey:@"gender"] isEqualToString:@"0"])
                gender = 0;
            
            User* newUser = [User userWithId:identifier
                                    token:[dataUser valueForKey:@"token"]
                                    email:[dataUser valueForKey:@"email"]
                                firstName:[dataUser valueForKey:@"firstname"]
                                 lastName:[dataUser valueForKey:@"lastname"]
                                    phone:[dataUser valueForKey:@"phone"]
                                      bio:[dataUser valueForKey:@"bio"]
                                 birthday:[dataUser valueForKey:@"birthday"]
                                   gender:gender];
            
            [self addOrUpdateUser:newUser];
            
            completionBlock();
            
        }
        else{
            NSLog(@"getuserbyid from api error = %@", jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getuserbyid from api timeout = %@", error);
    }];
    
}



- (void) connectToApiWithEmail:(NSString*)email AndPassword:(NSString*)password success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email":email,@"password":password};
    [manager POST:@"http://172.31.1.36:8888/covoicar/user/connect" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            
            NSDictionary *data = [jsonResponse objectForKey:@"data"];
            
            User *user = [User userWithId:[[data valueForKey:@"id"] intValue]
                                    token:[data valueForKey:@"token"]
                                    email:[data valueForKey:@"email"]
                                firstName:[data valueForKey:@"firstname"]
                                 lastName:[data valueForKey:@"lastname"]
                                    phone:[data valueForKey:@"phone"]
                                      bio:[data valueForKey:@"bio"]
                                 birthday:[data valueForKey:@"birthday"]
                                   gender:[[data valueForKey:@"gender"] intValue]];
            
            [[UserManager sharedInstance] setUserInstance:user];
            
            [[TripManager sharedInstance] refreshTripsFromApi:^{
                successBlock(jsonResponse);
            }];
        }
        else{
            errorBlock(jsonResponse);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}

- (void) registerToApi:(NSDictionary*)parameters success:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/user/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
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


- (void) logoutToApiWithSuccessBlock:(void (^)(NSDictionary* responseJson))successBlock error:(void (^)(NSDictionary* responseJson))errorBlock failure:(void (^)(NSError* error))failureBlock {
    
    User* userInstance = [[UserManager sharedInstance] getUserInstance];
    
    NSDictionary* parameters = @{@"token": userInstance.token};
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/user/logout" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            [self deleteUserInstance];
            
            [[TripManager sharedInstance] removeAllTrips];
            
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
