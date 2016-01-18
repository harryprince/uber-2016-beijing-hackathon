//
//  STAPIConst.m
//  STAPI
//
//  Created by SenseTime on 15/12/22.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STCommon.h"


NSString *const API_ID = @"api_id";

NSString *const API_SECRET = @"api_secret";

// ------------------API的URL
NSString *const BASE_URL = @"https://v1-api.visioncloudapi.com/";

NSString *const FORM_LINE = @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@";


// ------------------信息获取

NSString *const INFO_API = @"info/api";

NSString *const INFO_TASK = @"info/task";

NSString *const INFO_IMAGE = @"info/image";

NSString *const INFO_FACE = @"info/face";

NSString *const INFO_LIST_PERSONS = @"info/list_persons";

NSString *const INFO_LIST_GROUPS = @"info/list_groups";

NSString *const INFO_LIST_FACESETS = @"info/list_facesets";

NSString *const INFO_PERSON = @"info/person";

NSString *const INFO_GROUP = @"info/group";

NSString *const INFO_FACESET = @"info/faceset";

// ------------------人脸检测与分析

NSString *const FACE_DETECTION = @"face/detection";

NSString *const FACE_VERIFCATION = @"face/verification";

NSString *const FACE_SEARCH = @"face/search";

NSString *const FACE_IDENTIFICATION = @"face/identification";

NSString *const FACE_TRAINING = @"face/training";


// ------------------人的管理

NSString *const PERSON_CREATE = @"person/create";

NSString *const PERSON_DELETE = @"person/delete";

NSString *const PERSON_ADD_FACE = @"person/add_face";

NSString *const PERSON_REMOVE_FACE = @"person/remove_face";

NSString *const PERSON_CHANGE = @"person/change";


// ------------------组的管理

NSString *const GROUP_CREATE = @"group/create";

NSString *const GROUP_DELETE = @"group/delete";

NSString *const GROUP_ADD_PERSON = @"group/add_person";

NSString *const GROUP_REMOVE_PERSON = @"group/remove_person";

NSString *const GROUP_CHANGE = @"group/change";


// ------------------人脸集合的管理

NSString *const FACESET_CREATE = @"faceset/create";

NSString *const FACESET_DELETE = @"faceset/delete";

NSString *const FACESET_ADD_FACE = @"faceset/add_face";

NSString *const FACESET_REMOVE_FACE = @"faceset/remove_face";

NSString *const FACESET_CHANGE = @"faceset/change";

