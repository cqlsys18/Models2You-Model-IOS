//
//  NetAPIClient.h
//  project-luan-ludan
//
//  Created by user on 7/30/15.
//  Copyright (c) 2015 Toptal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

typedef enum {
    MediaTypePhoto = 0,
    MediaTypeVideo,
} MediaType;

typedef enum {
    ResponseContentTypeJSON = 0,
    ResponseContentTypeXML,
    ResponseContentTypeRAW
} ResponseContentType;

@interface NetAPIClient : AFHTTPSessionManager

+ (NetAPIClient *)sharedClient;

// send text data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
               params:(NSDictionary*)_params
              success:(void (^)(id _responseObject))_success
              failure:(void (^)(NSError* _error))_failure
  responseContentType:(ResponseContentType)_responseContentType;

- (void)sendToServiceByGET:(NSString *)serviceAPIURL
                    params:(NSDictionary *)_params
              encodeParams:(BOOL)encodeParams
                   success:(void (^)(id))_success
                   failure:(void (^)(NSError *))_failure responseContentType:(ResponseContentType)_responseContentType;

//send photo/video data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                  mediaType:(MediaType)_mediaType // 0: photo, 1: video
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure
        responseContentType:(ResponseContentType)_responseContentType;

// get text data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
               mediaOption1:(NSData* )_mediaOption1
               mediaOption2:(NSData* )_mediaOption2
               mediaOption3:(NSData* )_mediaOption3
                  mediaType:(MediaType)_mediaType // 0: photo, 1: video
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure
        responseContentType:(ResponseContentType)_responseContentType;

- (void)sendToServiceByPdfPOST:(NSString *)serviceAPIURL
                        params:(NSDictionary *)_params
                         media:(NSData* )_media
                  mediaOption1:(NSData* )_mediaOption1
                  mediaOption2:(NSData* )_mediaOption2
                  mediaOption3:(NSData* )_mediaOption3
                       pdfData:(NSData* )pdf
                     mediaType:(MediaType)_mediaType // 0: photo, 1: video
                       success:(void (^)(id _responseObject))_success
                       failure:(void (^)(NSError* _error))_failure
           responseContentType:(ResponseContentType)_responseContentType;

@end
