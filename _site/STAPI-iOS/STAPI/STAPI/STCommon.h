//
//  STAPIConst.h
//  STAPI
//
//  Created by SenseTime on 15/12/22.
//  Copyright © 2016年 SenseTime. All rights reserved.
//
//  官网： http://www.sensetime.com/cn
//  SDK： https://github.com/SenseTimeApp/STAPI-iOS
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** STATUS DEFINES status*/
UIKIT_EXTERN NSString *const STATUS_KEY;

/** STATUS DEFINES OK*/
UIKIT_EXTERN NSString * const STATUS_OK;

/** API账户*/
UIKIT_EXTERN NSString *const API_ID;

/** API密钥*/
UIKIT_EXTERN NSString *const API_SECRET;

/** API的URL*/
UIKIT_EXTERN NSString *const BASE_URL;

UIKIT_EXTERN NSString *const FORM_LINE;


// ------------------信息获取

/** info/api*/
UIKIT_EXTERN NSString *const INFO_API;

/** task*/
UIKIT_EXTERN NSString *const INFO_TASK;

/** info/image*/
UIKIT_EXTERN NSString *const INFO_IMAGE;

/** info/face*/
UIKIT_EXTERN NSString *const INFO_FACE;

/** info/list_persons*/
UIKIT_EXTERN NSString *const INFO_LIST_PERSONS;

/** info/list_groups*/
UIKIT_EXTERN NSString *const INFO_LIST_GROUPS;

/** info/list_facesets*/
UIKIT_EXTERN NSString *const INFO_LIST_FACESETS;

/** info/person*/
UIKIT_EXTERN NSString *const INFO_PERSON;

/** info/group*/
UIKIT_EXTERN NSString *const INFO_GROUP;

/** info/faceset*/
UIKIT_EXTERN NSString *const INFO_FACESET;

// ------------------人脸检测与分析

/** face/detection*/
UIKIT_EXTERN NSString *const FACE_DETECTION;

/** face/verification*/
UIKIT_EXTERN NSString *const FACE_VERIFCATION;

/** face/search*/
UIKIT_EXTERN NSString *const FACE_SEARCH;

/** face/identification*/

UIKIT_EXTERN NSString *const FACE_IDENTIFICATION;

/** face/training*/
UIKIT_EXTERN NSString *const FACE_TRAINING;

// ------------------人的管理

/** person/create*/
UIKIT_EXTERN NSString *const PERSON_CREATE;

/** person/delete*/
UIKIT_EXTERN NSString *const PERSON_DELETE;

/** person/add_face*/
UIKIT_EXTERN NSString *const PERSON_ADD_FACE;

/** person/remove_face*/
UIKIT_EXTERN NSString *const PERSON_REMOVE_FACE;

/** person/change*/
UIKIT_EXTERN NSString *const PERSON_CHANGE;


// ------------------组的管理

/** group/create*/
UIKIT_EXTERN NSString *const GROUP_CREATE;

/** group/delete*/
UIKIT_EXTERN NSString *const GROUP_DELETE;

/** group/add_person*/
UIKIT_EXTERN NSString *const GROUP_ADD_PERSON;

/** group/remove_person*/
UIKIT_EXTERN NSString *const GROUP_REMOVE_PERSON;

/** group/change*/
UIKIT_EXTERN NSString *const GROUP_CHANGE;


// ------------------人脸集合的管理

/** faceset/create*/
UIKIT_EXTERN NSString *const FACESET_CREATE;

/** faceset/delete*/
UIKIT_EXTERN NSString *const FACESET_DELETE;

/** faceset/add_face*/
UIKIT_EXTERN NSString *const FACESET_ADD_FACE;

/** faceset/remove_face*/
UIKIT_EXTERN NSString *const FACESET_REMOVE_FACE;

/** faceset/change*/
UIKIT_EXTERN NSString *const FACESET_CHANGE;


// ERROR STATUS
#define STATUS_KEY              (@"status")
#define STATUS_OK               (@"OK")

#define STATUS_UNAUTHORIZED     (@"UNAUTHORIZED")
#define STATUS_INVALID_ARGUMENT (@"INVALID_ARGUMENT")
#define STATUS_RATE_LIMIT_EXCEEDED (@"RATE_LIMIT_EXCEEDED")
#define STATUS_NO_PERMISSION    (@"NO_PERMISSION")
#define STATUS_KEY_EXPIRED      (@"KEY_EXPIRED")
#define STATUS_INTERNAL_ERROR   (@"INTERNAL_ERROR")
#define STATUS_NOT_FOUND        (@"NOT_FOUND")


/*
#define STATUS_EMPTY_FACESET (@"EMPTY_FACESET")
#define STATUS_FACE_ALREADY_EXISTS (@"FACE_ALREADY_EXISTS")
#define STATUS_INVALID_URL (@"INVALID_URL")


#define STATUS_INVALID_DIRECTION (@"INVALID_DIRECTION")
#define STATUS_INVALID_FACE (@"INVALID_FACE")
#define STATUS_INVALID_FACE_RECT (@"INVALID_FACE_RECT")
#define STATUS_INVALID_FACE_UUID (@"INVALID_FACE_UUID")
#define STATUS_INVALID_IMAGE (@"INVALID_IMAGE")
#define STATUS_INVALID_IMAGE_FORMAT_OR_SIZE (@"INVALID_IMAGE_FORMAT_OR_SIZE")
#define STATUS_INVALID_IMAGE_UUID (@"INVALID_IMAGE_UUID")
#define STATUS_INVALID_PERSON_UUID (@"INVALID_PERSON_UUID")
#define STATUS_INVALID_POINT_COUNT (@"INVALID_POINT_COUNT")
#define STATUS_INVALID_UUID (@"INVALID_UUID")
#define STATUS_FACE_ALREADY_EXISTS (@"FACE_ALREADY_EXISTS")
#define STATUS_EXCEED_DAILY_QUOTA (@"EXCEED_DAILY_QUOTA")
*/
