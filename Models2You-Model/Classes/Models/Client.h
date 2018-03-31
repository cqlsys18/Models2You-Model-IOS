//
//  Client.h
//  Models2You-Model
//
//  Created by user on 10/3/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

@property (nonatomic) long long clientId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;

@end
