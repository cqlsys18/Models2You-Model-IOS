//
//  NetAPIClient.m
//  project-luan-ludan
//
//  Created by user on 7/30/15.
//  Copyright (c) 2015 Toptal. All rights reserved.
//

#import "NetAPIClient.h"

//static NSString * const kNetAPIBaseURLString = @"http://...";

@implementation NetAPIClient

+ (NetAPIClient *)sharedClient
{
    __strong static NetAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    return _sharedClient;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self ;
}

#pragma mark - Custom Functions

- (NSMutableDictionary *)encodeUrlParams:(NSDictionary *)params
{
    NSMutableDictionary *encodedParams = [NSMutableDictionary dictionary];
    for (NSString *key in params.allKeys) {
        NSString *value = [params valueForKey:key];
        [encodedParams setObject:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
    }
    
    return encodedParams;
}

#pragma mark - Web Service

// send text data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
               params:(NSDictionary *)_params
              success:(void (^)(id _responseObject))_success
              failure:(void (^)(NSError *_error))_failure
  responseContentType:(ResponseContentType)_responseContentType
{
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (_responseContentType == ResponseContentTypeJSON)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    }
    else if (_responseContentType == ResponseContentTypeXML)
    {
        manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
    }
    else if (_responseContentType == ResponseContentTypeRAW)
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
    }
    
    [manager POST:serviceAPIURL parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString* string = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
//        NSLog( @"response : %@", string ) ;
        
        // Response Object ;
//        id _responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                             options:kNilOptions
//                                                               error:nil];
        
        // Success ;
        if (_success) {
            _success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"Error : %@", error.description ) ;
        
        // Failture ;
        if (_failure) {
            _failure(error);
        }
    }];*/
    
    //MARK:- New code for AFNetwork 3.0 and above
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(manager != nil){
        if (_responseContentType == ResponseContentTypeJSON)
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        }
        else if (_responseContentType == ResponseContentTypeXML)
        {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
        }
        else if (_responseContentType == ResponseContentTypeRAW)
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
        }
       
        [manager POST:serviceAPIURL parameters:_params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // Success ;
            if (_success) {
                _success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            // Failture ;
            if (_failure) {
                _failure(error);
            }
        }];
    }
    
}

// get text data
- ( void ) sendToServiceByGET : (NSString *) serviceAPIURL
                      params  : ( NSDictionary* ) _params
                      success : ( void (^)( id _responseObject ) ) _success
                      failure : ( void (^)( NSError* _error ) ) _failure
          responseContentType : (ResponseContentType)_responseContentType
{
   /* AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (_responseContentType == ResponseContentTypeJSON)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    }
    else if (_responseContentType == ResponseContentTypeXML)
    {
        manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
    }
    else if (_responseContentType == ResponseContentTypeRAW)
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
    }
    
    [manager GET:serviceAPIURL parameters:[self encodeUrlParams:_params] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString* string = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
//        NSLog( @"response : %@", string ) ;

        // Response Object ;
//        id _responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                              options:kNilOptions
//                                                                error:nil];

        // Success ;
        if (_success) {
            _success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"Error : %@", error.description ) ;

        // Failture ;
        if (_failure) {
            _failure(error);
        }
    }];*/
    
    //MARK:- New code for AFNetwork 3.0 and above
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(manager != nil){
        if (_responseContentType == ResponseContentTypeJSON)
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        }
        else if (_responseContentType == ResponseContentTypeXML)
        {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
        }
        else if (_responseContentType == ResponseContentTypeRAW)
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
        }
        
        [manager GET:serviceAPIURL parameters:[self encodeUrlParams:_params] progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // Success ;
            if (_success) {
                _success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            // Failture ;
            if (_failure) {
                _failure(error);
            }
        }];
    }
}


- (void)sendToServiceByGET:(NSString *)serviceAPIURL
                    params:(NSDictionary *)_params
              encodeParams:(BOOL)encodeParams
                   success:(void (^)(id))_success
                   failure:(void (^)(NSError *))_failure responseContentType:(ResponseContentType)_responseContentType {
    
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     if (_responseContentType == ResponseContentTypeJSON)
     {
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
     }
     else if (_responseContentType == ResponseContentTypeXML)
     {
     manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
     }
     else if (_responseContentType == ResponseContentTypeRAW)
     {
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
     }
     
     [manager GET:serviceAPIURL parameters:(encodeParams) ? [self encodeUrlParams:_params] : _params success:^(AFHTTPRequestOperation *operation, id responseObject) {
     if (_success) {
     _success(responseObject);
     }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog( @"Error : %@", error.description ) ;
     
     // Failture ;
     if (_failure) {
     _failure(error);
     }
     }];*/
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (_responseContentType == ResponseContentTypeJSON)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    }
    else if (_responseContentType == ResponseContentTypeXML)
    {
        manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
    }
    else if (_responseContentType == ResponseContentTypeRAW)
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
    }
    
    [manager GET:serviceAPIURL parameters:[self encodeUrlParams:_params] progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // Success ;
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        // Failture ;
        if (_failure) {
            _failure(error);
        }
    }];
}


//send photo/video data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                  mediaType:(MediaType)_mediaType // 0: photo, 1: video
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure
        responseContentType:(ResponseContentType)_responseContentType
{
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     if (_responseContentType == ResponseContentTypeJSON)
     {
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
     }
     else if (_responseContentType == ResponseContentTypeXML)
     {
     manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
     }
     else if (_responseContentType == ResponseContentTypeRAW)
     {
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
     }
     
     //NSDictionary *parameters = [self encodeUrlParams:_params];
     //    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
     [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     //        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
     
     if (_media) {
     if (_mediaType == MediaTypePhoto) {
     
     [formData appendPartWithFileData:_media
     name:@"picture"
     fileName:@"picture.png"
     mimeType:@"image/png" ] ;
     } else {
     [formData appendPartWithFileData:_media
     name:@"videfile"
     fileName:@"videfile"
     mimeType:@"video/quicktime"];
     }
     }
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     //        NSString* string = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
     NSLog( @"response : %@", responseObject ) ;
     
     // Response Object ;
     //        id _responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
     //                                                             options:kNilOptions
     //                                                               error:nil];
     
     // Success ;
     if (_success) {
     _success(responseObject);
     }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     NSLog( @"Error : %@", error.description ) ;
     
     // Failture ;
     if (_failure) {
     _failure(error);
     }
     
     }];*/
    
    //MARK:- New code for AFNetwork 3.0 and above
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(manager != nil){
        if (_responseContentType == ResponseContentTypeJSON)
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        }
        else if (_responseContentType == ResponseContentTypeXML)
        {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
        }
        else if (_responseContentType == ResponseContentTypeRAW)
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
        }
        
        [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (_media) {
                if (_mediaType == MediaTypePhoto) {
                    
                    [formData appendPartWithFileData:_media
                                                name:@"picture"
                                            fileName:@"picture.png"
                                            mimeType:@"image/png" ] ;
                    
                } else {
                    [formData appendPartWithFileData:_media
                                                name:@"videfile"
                                            fileName:@"videfile"
                                            mimeType:@"video/quicktime"];
                    
                }
            }
        }  progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // Success ;
            if (_success) {
                _success(responseObject);
            }
        }   failure:^(NSURLSessionDataTask *task, NSError *error){
            // Failture ;
            if (_failure) {
                _failure(error);
            }
        }];
    }
}

- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
               params:(NSDictionary *)_params
                media:(NSData* )_media
                mediaOption1:(NSData* )_mediaOption1
                mediaOption2:(NSData* )_mediaOption2
                mediaOption3:(NSData* )_mediaOption3
               mediaType:(MediaType)_mediaType // 0: photo, 1: video
              success:(void (^)(id _responseObject))_success
              failure:(void (^)(NSError* _error))_failure
  responseContentType:(ResponseContentType)_responseContentType
{
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (_responseContentType == ResponseContentTypeJSON)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    }
    else if (_responseContentType == ResponseContentTypeXML)
    {
        manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
    }
    else if (_responseContentType == ResponseContentTypeRAW)
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
    }
    
    //NSDictionary *parameters = [self encodeUrlParams:_params];
//    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        
        if (_media) {
            if (_mediaType == MediaTypePhoto) {
                
                [formData appendPartWithFileData:_media
                                              name:@"picture"
                                          fileName:@"picture.png"
                                          mimeType:@"image/png" ] ;
            } else {
                [formData appendPartWithFileData:_media
                                              name:@"videfile"
                                          fileName:@"videfile"
                                          mimeType:@"video/quicktime"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString* string = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
        NSLog( @"response : %@", responseObject ) ;
        
        // Response Object ;
//        id _responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                             options:kNilOptions
//                                                               error:nil];
        
        // Success ;
        if (_success) {
            _success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog( @"Error : %@", error.description ) ;
        
        // Failture ;
        if (_failure) {
            _failure(error);
        }
        
    }];*/
    
    //MARK:- New code for AFNetwork 3.0 and above
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(manager != nil){
        if (_responseContentType == ResponseContentTypeJSON)
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        }
        else if (_responseContentType == ResponseContentTypeXML)
        {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
        }
        else if (_responseContentType == ResponseContentTypeRAW)
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
        }
        
        [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (_media) {
                if (_mediaType == MediaTypePhoto) {
                    
                    [formData appendPartWithFileData:_media
                                                name:@"picture"
                                            fileName:@"picture.png"
                                            mimeType:@"image/png" ] ;
                    
                    if(_mediaOption1 != nil){
                        [formData appendPartWithFileData:_mediaOption1
                                                    name:@"picture1"
                                                fileName:@"picture1.png"
                                                mimeType:@"image/png" ] ;
                    }
                    
                    if(_mediaOption2 != nil){
                        [formData appendPartWithFileData:_mediaOption2
                                                    name:@"picture2"
                                                fileName:@"picture2.png"
                                                mimeType:@"image/png" ] ;
                    }
                    
                    if(_mediaOption3 != nil){
                        [formData appendPartWithFileData:_mediaOption3
                                                    name:@"picture3"
                                                fileName:@"picture3.png"
                                                mimeType:@"image/png" ] ;
                    }
                } else {
                    [formData appendPartWithFileData:_media
                                                name:@"videfile"
                                            fileName:@"videfile"
                                            mimeType:@"video/quicktime"];
                    
                    if(_mediaOption1 != nil){
                        [formData appendPartWithFileData:_mediaOption1
                                                    name:@"videfile1"
                                                fileName:@"videfile1"
                                                mimeType:@"video/quicktime"];
                    }
                    
                    if(_mediaOption2 != nil){
                        [formData appendPartWithFileData:_mediaOption2
                                                    name:@"videfile2"
                                                fileName:@"videfile2"
                                                mimeType:@"video/quicktime"];
                    }
                    
                    if(_mediaOption2 != nil){
                        [formData appendPartWithFileData:_mediaOption3
                                                    name:@"videfile3"
                                                fileName:@"videfile3"
                                                mimeType:@"video/quicktime"];
                    }
                }
                
                //TODO: Add multiple photos and video file in formData
            }
        }  progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // Success ;
            if (_success) {
                _success(responseObject);
            }
        }   failure:^(NSURLSessionDataTask *task, NSError *error){
            // Failture ;
            if (_failure) {
                _failure(error);
            }
        }];
    }
}

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
        responseContentType:(ResponseContentType)_responseContentType
{
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     if (_responseContentType == ResponseContentTypeJSON)
     {
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
     }
     else if (_responseContentType == ResponseContentTypeXML)
     {
     manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
     }
     else if (_responseContentType == ResponseContentTypeRAW)
     {
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
     }
     
     //NSDictionary *parameters = [self encodeUrlParams:_params];
     //    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
     [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     //        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
     
     if (_media) {
     if (_mediaType == MediaTypePhoto) {
     
     [formData appendPartWithFileData:_media
     name:@"picture"
     fileName:@"picture.png"
     mimeType:@"image/png" ] ;
     } else {
     [formData appendPartWithFileData:_media
     name:@"videfile"
     fileName:@"videfile"
     mimeType:@"video/quicktime"];
     }
     }
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     //        NSString* string = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
     NSLog( @"response : %@", responseObject ) ;
     
     // Response Object ;
     //        id _responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
     //                                                             options:kNilOptions
     //                                                               error:nil];
     
     // Success ;
     if (_success) {
     _success(responseObject);
     }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     NSLog( @"Error : %@", error.description ) ;
     
     // Failture ;
     if (_failure) {
     _failure(error);
     }
     
     }];*/
    
    //MARK:- New code for AFNetwork 3.0 and above
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(manager != nil){
        if (_responseContentType == ResponseContentTypeJSON)
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        }
        else if (_responseContentType == ResponseContentTypeXML)
        {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
        }
        else if (_responseContentType == ResponseContentTypeRAW)
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/xml", @"application/xml", nil];
        }
        
        [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (_media) {
                if (_mediaType == MediaTypePhoto) {
                    
                    [formData appendPartWithFileData:_media
                                                name:@"picture"
                                            fileName:@"picture.png"
                                            mimeType:@"image/png" ] ;
                    
                    if(_mediaOption1 != nil){
                        [formData appendPartWithFileData:_mediaOption1
                                                    name:@"picture1"
                                                fileName:@"picture1.png"
                                                mimeType:@"image/png" ] ;
                    }
                    
                    if(_mediaOption2 != nil){
                        [formData appendPartWithFileData:_mediaOption2
                                                    name:@"picture2"
                                                fileName:@"picture2.png"
                                                mimeType:@"image/png" ] ;
                    }
                    
                    if(_mediaOption3 != nil){
                        [formData appendPartWithFileData:_mediaOption3
                                                    name:@"picture3"
                                                fileName:@"picture3.png"
                                                mimeType:@"image/png" ] ;
                    }
                    if(pdf != nil){
                        [formData appendPartWithFileData:pdf
                                                    name:@"w9_form"
                                                fileName:@"w9_form.pdf"
                                                mimeType:@"application/pdf" ] ;
                    }
                    
                } else {
                    [formData appendPartWithFileData:_media
                                                name:@"videfile"
                                            fileName:@"videfile"
                                            mimeType:@"video/quicktime"];
                    
                    if(_mediaOption1 != nil){
                        [formData appendPartWithFileData:_mediaOption1
                                                    name:@"videfile1"
                                                fileName:@"videfile1"
                                                mimeType:@"video/quicktime"];
                    }
                    
                    if(_mediaOption2 != nil){
                        [formData appendPartWithFileData:_mediaOption2
                                                    name:@"videfile2"
                                                fileName:@"videfile2"
                                                mimeType:@"video/quicktime"];
                    }
                    
                    if(_mediaOption2 != nil){
                        [formData appendPartWithFileData:_mediaOption3
                                                    name:@"videfile3"
                                                fileName:@"videfile3"
                                                mimeType:@"video/quicktime"];
                    }
                }
                
                //TODO: Add multiple photos and video file in formData
            }
        }  progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // Success ;
            if (_success) {
                _success(responseObject);
            }
        }   failure:^(NSURLSessionDataTask *task, NSError *error){
            // Failture ;
            if (_failure) {
                _failure(error);
            }
        }];
    }
}
@end
