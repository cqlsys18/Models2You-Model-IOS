//
//  WebServiceClient.h
//  project-luan-ludan
//
//  Created by user on 7/30/15.
//  Copyright (c) 2015 Toptal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Config.h"
#import "Booking.h"

@interface WebServiceClient : NSObject

+ (WebServiceClient*)sharedClient;

@property (nonatomic, strong) NSMutableDictionary *baseParams;

- (void)initBaseParams;

#pragma mark - User

- (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
                    photo:(NSData *)photo
             photoOption1:(NSData *)photoOption1
             photoOption2:(NSData *)photoOption2
             photoOption3:(NSData *)photoOption3
                     name:(NSString *)name
                     rate:(float)rate
                  address:(NSString *)address
                     city:(NSString *)city
                    state:(NSString *)state
                  zipcode:(NSString *)zipcode
                    phone:(NSString *)phone
                      dob:(NSString *)dob
                 eyeColor:(NSString *)eyeColor
                hairColor:(NSString *)hairColor
               heightFoot:(int)heightFoot
               heightInch:(int)heightInch
                favorites:(NSString *)favorites
              instagramId:(NSString *)instagramId
               facebookId:(NSString *)facebookId
                    pdf:(NSData *)myPdf
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(id responseObject)) success
               failure:(void (^)(NSError *error)) failure;

- (void)updateProfileWithName:(NSString *)name
                         rate:(float)rate
                    hairColor:(NSString *)hairColor
                    favorites:(NSString *)favorites
                   heightFoot:(int)heightFoot
                   heightInch:(int)heightInch
                     eyeColor:(NSString *)eyeColor
                        photo:(NSString *)photo
                      success:(void (^)(id responseObject)) success
                      failure:(void (^)(NSError *error)) failure;

//- (void)setAvailability:(BOOL)availability
//                success:(void (^)(id responseObject)) success
//                failure:(void (^)(NSError *error)) failure;

- (void)setAvailability:(BOOL)availability
checkAvailabilityDateTime:(NSString *)availabilityDateTime
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure;

- (void)updateLocationWithLat:(double)lat
                          lon:(double)lon
                      success:(void (^)(id responseObject)) success
                      failure:(void (^)(NSError *error)) failure;

- (void)updateDeviceTokenToToken:(NSString *)token
                         success:(void (^)(id responseObject)) success
                         failure:(void (^)(NSError *error)) failure;

- (void)getTotalEarningsWithSuccess:(void (^)(id responseObject)) success
                            failure:(void (^)(NSError *error)) failure;

- (void)sendNewPasswordToEmail:(NSString *)strEmail
                       success:(void (^)(id responseObject)) success
                       failure:(void (^)(NSError *error)) failure;

- (void)getAllPhotosWithSuccess:(void (^)(id responseObject)) success
                        failure:(void (^)(NSError *error)) failure;

- (void)addPhoto:(NSData *)photo
         success:(void (^)(id responseObject)) success
         failure:(void (^)(NSError *error)) failure;

- (void)removePhoto:(long long)photoId
            success:(void (^)(id responseObject)) success
            failure:(void (^)(NSError *error)) failure;

#pragma mark - Booking

- (void)countBookingsOfStatus:(NSArray *)status
         withCurrentDateTimer:(NSString *)cureentDateTime
                      success:(void (^)(id responseObject)) success
                      failure:(void (^)(NSError *error)) failure;

- (void)listBookingsOfStatus:(NSArray *)status
                     success:(void (^)(id responseObject)) success
                     failure:(void (^)(NSError *error)) failure;

- (void)setStatusOfBooking:(long long)bookingId
                    status:(BOOKING_STATUS)status
          additionalParams:(NSDictionary *)additionalParams
                   success:(void (^)(id responseObject)) success
                   failure:(void (^)(NSError *error)) failure;

- (void)setNotifyStatusOfBooking:(long long)bookingId
                          status:(NOTIFY_STATUS)status
                additionalParams:(NSDictionary *)additionalParams
                         success:(void (^)(id responseObject)) success
                         failure:(void (^)(NSError *error)) failure;

- (void)callInitiateWithCallerPhoneNumber:(NSString *)callerId
                    withCalleePhoneNumber:(NSString *)calleeId
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure;

- (void)getBookingInfo:(long long)bookingId
               success:(void (^)(id responseObject)) success
               failure:(void (^)(NSError *error)) failure;

#pragma mark - Renew Token
-(void) renewTokenExpiryWithSuccess:(void (^)(id))success
                            failure:(void (^)(NSError *))failure;

#pragma mark - Update password
-(void) updatePasswordInfo:(NSString *)password
               success:(void (^)(id responseObject)) success
               failure:(void (^)(NSError *error)) failure;

@end
