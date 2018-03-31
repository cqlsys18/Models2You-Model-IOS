//
//  Config.h
//  Models2You
//
//  Created by user on 9/17/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#ifndef Models2You_Config_h
#define Models2You_Config_h

//------------------------
// Web Service
//------------------------

//#define WEBSITE_URL             @"http://52.11.251.134/%@"

//TODO:Remove Staging url after test
//#define WEBSITE_URL             @"http://staging.47billion.com/%@" // Staging url
//#define WEBSITE_URL             @"http://192.168.1.84:8000/%@" // Staging url
#define WEBSITE_URL               @"http://54.244.203.250/%@" // Client Staging url
//#define WEBSITE_URL             @"http://54.213.253.84/%@" // Staging url

#define WEBAPI_REGISTER             @"provider/new_register"
#define WEBAPI_LOGIN                @"provider/new_login"
#define WEBAPI_UPDATE_PROFILE       @"provider/new_update"
#define WEBAPI_SET_AVAILABILITY     @"provider/new_set_availability"
#define WEBAPI_UPDATE_LOCATION      @"provider/new_update_location"
#define WEBAPI_UPDATE_DEV_TOKEN     @"provider/update_device_token"
#define WEBAPI_GET_TOTAL_EARNINGS   @"provider/get_total_earnings"
#define WEBAPI_GET_ALL_PHOTOS       @"provider/get_all_photos"
#define WEBAPI_ADD_PHOTO            @"provider/add_photo"
#define WEBAPI_FORGOT_PASSWORD      @"application/forgot-password"
#define WEBAPI_REMOVE_PHOTO         @"provider/remove_photo"
#define WEBAPI_RENEW_TOKEN_EXPIRY   @"provider/renew_token_expiry"
#define WEBAPI_CHANGE_PASSWROD      @"application/change-password"

#define WEBAPI_COUNT_BOOKINGS   @"booking/count"
#define WEBAPI_LIST_BY_STATUS   @"booking/list_by_status"
#define WEBAPI_SET_BOOKING_STAT @"booking/set_status"
#define WEBAPI_SET_NOTIFY_STAT  @"booking/set_notify_status"
#define WEBAPI_BOOKING_INFO     @"booking/info"
#define WEBAPI_CALL_INITIATE     @"user/call_user"

#define USER_TYPE                @"user_type"

#define RES_KEY_SUCCESS         @"success"
#define RES_KEY_ERROR           @"error"
#define RES_KEY_ERROR_MESSAGES  @"error_messages"
#define RES_KEY_BOOKINGS        @"bookings"
#define RES_KEY_BOOKING         @"booking"
#define RES_KEY_PHOTOS          @"photos"
#define RES_VALUE_SUCCESS       @1

#define PARAM_TYPE              @"type"
#define TYPE_MODEL              1
#define PARAM_ID                @"id"
#define PARAM_TOKEN             @"token"
#define PARAM_PICTURE           @"picture"
#define PARAM_EMAIL             @"email"
#define PARAM_PASSWORD          @"password"
#define PARAM_NAME              @"name"
#define PARAM_ADDRESS           @"address"
#define PARAM_CITY              @"city"
#define PARAM_STATE             @"state"
#define PARAM_ZIPCODE           @"zipcode"
#define PARAM_INSTAGRAM         @"instagram"
#define PARAM_FACEBOOK          @"facebook"
#define PARAM_PDF               @"w9_form"

#define PARAM_PHONE             @"phone"
#define PARAM_DOB               @"dob"
#define PARAM_EYECOLOR          @"eyecolor"
#define PARAM_HAIRCOLOR         @"haircolor"
#define PARAM_HEIGHT_FOOT       @"height_foot"
#define PARAM_HEIGHT_INCH       @"height_inch"
#define PARAM_FAVORITES         @"favorites"
#define PARAM_AVAILABILITY      @"availability"
#define PARAM_LATITUDE          @"lat"
#define PARAM_LONGITUDE         @"lon"
#define PARAM_DEVICE_TOKEN      @"device_token"
#define PARAM_SESSION_TIME_OUT  @"session_timeout"

#define PARAM_URL               @"url"
#define PARAM_PHOTO_ID          @"photo_id"

#define PARAM_BOOKING_STATUS            @"status"
#define PARAM_MODEL_ID                  @"model_id"
#define PARAM_CLIENT_ID                 @"client_id"
#define PARAM_BOOK_DATE                 @"book_date"
#define PARAM_APPOINTMENT_DATETIME      @"appointment_datetime"
#define PARAM_ARRIVED_TIME              @"arrived_time"
#define PARAM_DURATION                  @"duration"
#define PARAM_RATE                      @"rate"
#define PARAM_LOCATION                  @"location"
#define PARAM_EVENT_LATITUDE          @"latitude"
#define PARAM_EVENT_LONGITUDE         @"longitude"
#define PARAM_COMMENT                   @"comment"
#define PARAM_WEAR                      @"wear"
#define PARAM_NOTIFY_STATUS             @"notify_status"
#define PARAM_DELAY                     @"delay"
#define PARAM_REASON                    @"reason"
#define PARAM_WHO                       @"who"
#define PARAM_MODEL_RATE_PER_HOUR       @"model_rate_per_hour"

#define PARAM_CHECK_AVAILABILITY_TIME   @"check_availability_time"
#define PARAM_CURRENT_TIME              @"current_time"

#define PARAM_COUNT             @"count"
#define PARAM_BOOKING_ID        @"booking_id"
#define PARAM_NEW_PASSWORD      @"new_password"
#define PARAM_TOTAL_EARNING     @"total_earnings"
#define PARAM_CALLER_PHONE           @"callerPhone"
#define PARAM_CALLEE_PHONE           @"calleePhone"

//------------------------
// Broadcast Notification
//------------------------

#define kNotificationSuggestChangeNotiSettings          @"NSCNS"
#define kNotificationStopMonitoringSigLocationChanges   @"NSMSLC"
#define kNotificationModifyCurBookingCount              @"NMCBC"
#define MODIFY_COUNT_KEY        @"modify_count"

//------------------------
// Push Notification
//------------------------

#define CATEGORY_BOOK_MODEL     @"book_model"
#define ACTION_ACCEPT           @"accept"
#define ACTION_DENY             @"deny"
#define PARAM_IDENTIFICATION_KEY    @"identification_key"
#define PARAM_IDENTIFICATION_VALUE    @"logout_timer"
#define CATEGORY_LOCAL_NOTIFICATION     @"local_notification"
#define ACTION_YES           @"yes"
#define ACTION_NO             @"no"
#define DEVICE_LOCATION_UPDATE @"DEVICE_LOCATION_UPDATE"
#define BOOKING_APPOINTMENT_COMPLETE_CANCEL @"BOOKING_APPOINTMENT_COMPLETE_CANCEL"

//----------------------------------------
// Default message for Twilio calling
//----------------------------------------
#define TWILIO_CALLING_MSG @"Call initiated, please wait for incoming call"

// Image upload size
#define SERVER_UPLOAD_IMAGE_SIZE 1000


#endif
