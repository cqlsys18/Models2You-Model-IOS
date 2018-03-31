//
//  WebServiceClient.m
//  project-luan-ludan
//
//  Created by user on 7/30/15.
//  Copyright (c) 2015 Toptal. All rights reserved.
//

#import "WebServiceClient.h"

#import "NetAPIClient.h"
#import "AccountManager.h"

@implementation WebServiceClient

+ (WebServiceClient *)sharedClient
{
    static WebServiceClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
        [_sharedClient initBaseParams];
    });
    return _sharedClient;
}

- (void)initBaseParams {
    _baseParams = [NSMutableDictionary dictionary];
    
    AccountManager *manager = [AccountManager sharedManager];
    
    [_baseParams setValue:[NSString stringWithFormat:@"%lld", manager.userId] forKey:PARAM_ID];
    [_baseParams setValue:manager.sessToken forKey:PARAM_TOKEN];
}

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
                  failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:email forKey:PARAM_EMAIL];
    [params setObject:password forKey:PARAM_PASSWORD];
    [params setObject:name forKey:PARAM_NAME];
    [params setObject:[NSString stringWithFormat:@"%f", rate] forKey:PARAM_RATE];
    
    [params setObject:address forKey:PARAM_ADDRESS];
    [params setObject:city forKey:PARAM_CITY];
    [params setObject:state forKey:PARAM_STATE];
    [params setObject:zipcode forKey:PARAM_ZIPCODE];
    
    [params setObject:phone forKey:PARAM_PHONE];
    [params setObject:dob forKey:PARAM_DOB];
    [params setObject:eyeColor forKey:PARAM_EYECOLOR];
    [params setObject:hairColor forKey:PARAM_HAIRCOLOR];
    
    [params setObject:[NSString stringWithFormat:@"%d", heightFoot] forKey:PARAM_HEIGHT_FOOT];
    [params setObject:[NSString stringWithFormat:@"%d", heightInch] forKey:PARAM_HEIGHT_INCH];
    
    [params setObject:favorites forKey:PARAM_FAVORITES];
    
    [params setObject:instagramId forKey:PARAM_INSTAGRAM];
    [params setObject:facebookId forKey:PARAM_FACEBOOK];
    //[params setObject:myPdf forKey:PARAM_PDF];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_REGISTER];
    
    [[NetAPIClient sharedClient]sendToServiceByPdfPOST:webServiceURL params:params media:photo mediaOption1:photoOption1 mediaOption2:photoOption2 mediaOption3:photoOption3 pdfData:myPdf mediaType:MediaTypePhoto success:success failure:failure responseContentType:ResponseContentTypeJSON];
   
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:email forKey:PARAM_EMAIL];
    [params setObject:password forKey:PARAM_PASSWORD];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_LOGIN];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)updateProfileWithName:(NSString *)name
                         rate:(float)rate
                    hairColor:(NSString *)hairColor
                    favorites:(NSString *)favorites
                   heightFoot:(int)heightFoot
                   heightInch:(int)heightInch
                     eyeColor:(NSString *)eyeColor
                        photo:(NSString *)photo
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:name forKey:PARAM_NAME];
    [params setObject:eyeColor forKey:PARAM_EYECOLOR];
    [params setObject:hairColor forKey:PARAM_HAIRCOLOR];
    [params setObject:photo forKey:PARAM_PICTURE];
    
    [params setObject:[NSString stringWithFormat:@"%f", rate] forKey:PARAM_RATE];
    [params setObject:[NSString stringWithFormat:@"%d", heightFoot] forKey:PARAM_HEIGHT_FOOT];
    [params setObject:[NSString stringWithFormat:@"%d", heightInch] forKey:PARAM_HEIGHT_INCH];
    
    [params setObject:favorites forKey:PARAM_FAVORITES];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_UPDATE_PROFILE];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)setAvailability:(BOOL)availability
checkAvailabilityDateTime:(NSString *)availabilityDateTime
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:[NSString stringWithFormat:@"%d", availability] forKey:PARAM_AVAILABILITY];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_SET_AVAILABILITY];
    
    if(availabilityDateTime != nil){
        [params setObject:availabilityDateTime forKey:PARAM_CHECK_AVAILABILITY_TIME];
    }
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)updateLocationWithLat:(double)lat
                          lon:(double)lon
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    NSNumber *latNum = [NSNumber numberWithDouble:lat];
    NSNumber *lonNum = [NSNumber numberWithDouble:lon];
//    [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:PARAM_LATITUDE];
//    [params setObject:[NSString stringWithFormat:@"%f", lon] forKey:PARAM_LONGITUDE];
    [params setObject:[latNum stringValue] forKey:PARAM_LATITUDE];
    [params setObject:[lonNum stringValue] forKey:PARAM_LONGITUDE];

    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_UPDATE_LOCATION];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)updateDeviceTokenToToken:(NSString *)token
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:token forKey:PARAM_DEVICE_TOKEN];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_UPDATE_DEV_TOKEN];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)getTotalEarningsWithSuccess:(void (^)(id))success
                            failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_GET_TOTAL_EARNINGS];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)sendNewPasswordToEmail:(NSString *)strEmail
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:strEmail forKey:PARAM_EMAIL];
    [params setObject:@(TYPE_MODEL) forKey:PARAM_TYPE];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_FORGOT_PASSWORD];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)getAllPhotosWithSuccess:(void (^)(id))success
                        failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:[NSString stringWithFormat:@"%lld", [AccountManager sharedManager].userId] forKey:PARAM_MODEL_ID];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_GET_ALL_PHOTOS];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)addPhoto:(NSData *)photo
         success:(void (^)(id))success
         failure:(void (^)(NSError *))failure {
    
    NSDictionary *params = [_baseParams mutableCopy];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_ADD_PHOTO];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                               media:photo
                                           mediaType:MediaTypePhoto
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)removePhoto:(long long)photoId
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:[NSString stringWithFormat:@"%lld", photoId] forKey:PARAM_PHOTO_ID];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_REMOVE_PHOTO];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

#pragma mark - Booking

- (void)countBookingsOfStatus:(NSArray *)status
         withCurrentDateTimer:(NSString *)cureentDateTime
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:status forKey:PARAM_BOOKING_STATUS];
    
    if(cureentDateTime != nil){
        [params setObject:cureentDateTime forKey:PARAM_CURRENT_TIME];
    }
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_COUNT_BOOKINGS];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)listBookingsOfStatus:(NSArray *)status
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:status forKey:PARAM_BOOKING_STATUS];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_LIST_BY_STATUS];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)setStatusOfBooking:(long long)bookingId
                    status:(BOOKING_STATUS)status
          additionalParams:(NSDictionary *)additionalParams
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:[NSString stringWithFormat:@"%lld", bookingId] forKey:PARAM_BOOKING_ID];
    [params setObject:[NSString stringWithFormat:@"%d", status] forKey:PARAM_BOOKING_STATUS];
    
    [params setObject:@1 forKey:PARAM_WHO];
    
    if (additionalParams)
        [params addEntriesFromDictionary:additionalParams];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_SET_BOOKING_STAT];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)setNotifyStatusOfBooking:(long long)bookingId
                          status:(NOTIFY_STATUS)status
                additionalParams:(NSDictionary *)additionalParams
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:[NSString stringWithFormat:@"%lld", bookingId] forKey:PARAM_BOOKING_ID];
    [params setObject:[NSString stringWithFormat:@"%d", status] forKey:PARAM_NOTIFY_STATUS];
    
    if (additionalParams)
        [params addEntriesFromDictionary:additionalParams];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_SET_NOTIFY_STAT];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)callInitiateWithCallerPhoneNumber:(NSString *)callerId
                    withCalleePhoneNumber:(NSString *)calleeId
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:callerId forKey:PARAM_CALLER_PHONE];
    [params setObject:calleeId forKey:PARAM_CALLEE_PHONE];
    [params setObject:@(1) forKey:PARAM_WHO];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_CALL_INITIATE];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

- (void)getBookingInfo:(long long)bookingId
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    
    [params setObject:[NSString stringWithFormat:@"%lld", bookingId] forKey:PARAM_BOOKING_ID];
    [params setObject:@"2" forKey:USER_TYPE];
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_BOOKING_INFO];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

-(void) renewTokenExpiryWithSuccess:(void (^)(id))success
                        failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_RENEW_TOKEN_EXPIRY];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
}

#pragma mark - Update password
-(void) updatePasswordInfo:(NSString *)password
                   success:(void (^)(id responseObject)) success
                   failure:(void (^)(NSError *error)) failure{
    
    
    NSMutableDictionary *params = [_baseParams mutableCopy];
    [params setObject:password forKey:PARAM_NEW_PASSWORD];
    
    NSString *webServiceURL = [NSString stringWithFormat:WEBSITE_URL, WEBAPI_CHANGE_PASSWROD];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:webServiceURL
                                              params:params
                                             success:success
                                             failure:failure
                                 responseContentType:ResponseContentTypeJSON];
    
}

@end
