//
//  User.h
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

@interface User : RLMObject

// Identifier of user
@property int id;
// Token for API
@property NSString* token;

@property NSString* email;
@property NSString* firstname;
@property NSString* lastname;
@property NSString* phone;
@property NSString* bio;
@property NSString* birthday;
@property int gender;

// Instance
- (instancetype) initWithId:(int)id token:(NSString*)token email:(NSString *)email firstName:(NSString *)firstname lastName:(NSString *)lastname phone:(NSString *)phone bio:(NSString *)bio birthday:(NSString *)birthday gender:(int)gender;

// Construct
+ (User*) userWithId:(int)id token:(NSString*)token email:(NSString *)email firstName:(NSString *)firstname lastName:(NSString *)lastname phone:(NSString *)phone bio:(NSString *)bio birthday:(NSString *)birthday gender:(int)gender;


@end