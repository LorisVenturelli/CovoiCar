//
//  User.m
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSString*)primaryKey {
    return @"id";
}

- (instancetype) initWithId:(int)id
                      token:(NSString *)token
                      email:(NSString *)email
                  firstName:(NSString *)firstname
                   lastName:(NSString *)lastname
                      phone:(NSString *)phone
                        bio:(NSString *)bio
                   birthday:(NSString *)birthday
                     gender:(int)gender
{
    self = [super init];
    if (self != nil) {
        
        firstname = [firstname stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[firstname substringToIndex:1] uppercaseString]];
        lastname = [lastname stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[lastname substringToIndex:1] uppercaseString]];
        
        self.id = id;
        self.token = token;
        
        self.email = email;
        self.firstname = firstname;
        self.lastname = lastname;
        self.phone = phone;
        self.bio = bio;
        self.birthday = birthday;
        self.gender = gender;
        
    }
    return self;
}

+ (User *)userWithId:(int)id
               token:(NSString *)token
               email:(NSString *)email
           firstName:(NSString *)firstname
            lastName:(NSString *)lastname
               phone:(NSString *)phone
                 bio:(NSString *)bio
            birthday:(NSString *)birthday
              gender:(int)gender
{
    return [[User alloc] initWithId:id token:token email:email firstName:firstname lastName:lastname phone:phone bio:bio birthday:birthday gender:gender];
}



@end
RLM_ARRAY_TYPE(User)