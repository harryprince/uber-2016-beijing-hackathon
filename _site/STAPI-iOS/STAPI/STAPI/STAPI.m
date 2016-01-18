//
//  STAPI.m
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STAPI.h"
#import "STCommon.h"
#import "STFace.h"
#import "STImage.h"
#import "STFaceSet.h"
#import "STPerson.h"
#import "STGroup.h"

@interface STAPI ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
//{
//    NSMutableData *_responseData; // response data
//}

@property (nonatomic, strong, readwrite) NSDictionary *dictionary;

@property (nonatomic, strong) NSString *apiid;
@property (nonatomic, strong) NSString *apisecret;

@end

@implementation STAPI

+(STAPI *)shareInstance{
    
    static STAPI *stapi = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        stapi = [[STAPI alloc]init];
    });
    return stapi;
}

- (void)start_apiid:(NSString *)apiid apisecret:(NSString *)apisecret {
    self.apiid = apiid;
    self.apisecret = apisecret;
    
}

- (NSDictionary *)info_api {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_API];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret};
    
    return [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_task_taskid:(NSString *)taskid {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_TASK];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret,@"task_id":taskid};
    
    return [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_image_imageid:(NSString *)imageid withfaces:(BOOL)faces {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_IMAGE];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret,@"image_id":imageid,@"with_faces":[NSNumber numberWithBool:faces]};
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_face_faceid:(NSString *)faceid withimage:(BOOL)image {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_FACE];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret,@"face_id":faceid,@"with_image":[NSNumber numberWithBool:image]};
    
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_list_persons {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_LIST_PERSONS];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret};
    
    return  [self sendGetRequestWithMethod:method parameters:parameters];
    
}

- (NSDictionary *)info_list_groups {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_LIST_GROUPS];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret};
    
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_list_facesets {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_LIST_FACESETS];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret};
    
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary*)info_personid:(NSString *)personid {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_PERSON];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret,@"person_id":personid};
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_groupid:(NSString *)groupid {
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_GROUP];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret,@"group_id":groupid};
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

- (NSDictionary *)info_faceset_facesetid:(NSString *)facesetid {
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,INFO_FACESET];
    
    NSDictionary *parameters = @{ API_ID:self.apiid,API_SECRET:self.apisecret,@"faceset_id":facesetid};
    return  [self sendGetRequestWithMethod:method parameters:parameters];
}

#pragma mark 人脸检测与分析
- (STImage *)face_detection_image:(UIImage *)image {
    if ( image == nil ) {
        NSLog(@"face detection error: image is nill");
        return nil ;
    }
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_DETECTION];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:nil andImage:image];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STImage *stImage = [[STImage alloc]initWithDict:dict];
        return stImage;
    }
    return nil;
}

- (STImage *)face_detection_image:(UIImage *)image
                    landmarks106:(BOOL)landmarks106
                      attributes:(BOOL)attributes
                     auto_rotate:(BOOL)auto_rotate
                       user_data:(NSString *)user_data {
    if ( image == nil ) {
        NSLog(@"face detection error: image is nill");
        return nil ;
    }
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!user_data) {
        parameters = @{
                       @"landmarks106":[NSNumber numberWithBool:landmarks106],
                       @"attributes": [NSNumber numberWithBool:attributes],
                       @"auto_rotate": [NSNumber numberWithBool:auto_rotate],
                       };
    } else {
        parameters = @{
                       @"landmarks106":[NSNumber numberWithBool:landmarks106],
                       @"attributes": [NSNumber numberWithBool:attributes],
                       @"auto_rotate": [NSNumber numberWithBool:auto_rotate],
                       @"user_data": user_data
                       };
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_DETECTION];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters andImage:image];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STImage *stImage = [[STImage alloc]initWithDict:dict];
        return stImage;
    }
    return nil;
}

- (STImage *)face_detection_url:(NSString *)strImageUrl {
    if ( strImageUrl == nil ) {
        NSLog(@"face detection error: strImageUrl is nill");
        return nil ;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_DETECTION];
    
    NSDictionary *parameters = @{  @"url": strImageUrl   };
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STImage *stImage = [[STImage alloc]initWithDict:dict];
        return stImage;
    }
    return nil;
}

- (STImage *)face_detection_url:(NSString *)strImageUrl
                   landmarks106:(BOOL)landmarks106
                     attributes:(BOOL)attributes
                    auto_rotate:(BOOL)auto_rotate
                      user_data:(NSString *)user_data {
    if ( strImageUrl == nil ) {
        NSLog(@"face detection error: strImageUrl is nill");
        return nil ;
    }
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!user_data) {
        parameters = @{
                       @"landmarks106":[NSNumber numberWithBool:landmarks106],
                       @"attributes": [NSNumber numberWithBool:attributes],
                       @"auto_rotate": [NSNumber numberWithBool:auto_rotate],
                       @"url": strImageUrl ,
                       };
    } else {
        parameters = @{
                       @"landmarks106":[NSNumber numberWithBool:landmarks106],
                       @"attributes": [NSNumber numberWithBool:attributes],
                       @"auto_rotate": [NSNumber numberWithBool:auto_rotate],
                       @"user_data": user_data,
                       @"url": strImageUrl ,
                       };
    }

    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_DETECTION];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STImage *stImage = [[STImage alloc]initWithDict:dict];
        return stImage;
    }
    return nil;
}

- (float)face_verification_faceid:(NSString *)faceid face2id:(NSString *)face2id {
    if (!faceid || !face2id) {
        NSLog(@"face verification error : faceid or face2id is nil");
        return -1;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_VERIFCATION];
    NSDictionary *parameters = @{@"face_id":faceid,@"face2_id":face2id };
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return [[dict objectForKey:@"confidence"] floatValue];
    }
    return -1;
}
- (float)face_verification_faceid:(NSString *)faceid personid:(NSString *)personid {
    if (!faceid || !personid) {
        NSLog(@"face verification error : faceid or personid is nil");
        return -1;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_VERIFCATION];
    NSDictionary *parameters = @{@"face_id":faceid,@"person_id":personid };
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return [[dict objectForKey:@"confidence"] floatValue];
    }
    return -1;
}

- (NSDictionary *)face_search_faceid:(NSString *)faceid faceids:(NSString *)faceids topnum:(NSUInteger)num {
    if (!faceid || !faceids) {
        NSLog(@"face_search error : faceid or faceids is nil");
        return nil;
    }

    NSDictionary *parameters = [NSDictionary dictionary];
    if (!num) {
        parameters = @{
                       @"face_id":faceid,
                       @"face_ids":faceids,
                       };
    } else {
        parameters = @{
                       @"face_id":faceid,
                       @"face_ids":faceids,
                       @"top":[NSNumber numberWithInteger:num],
                       };
    }

    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_SEARCH];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return dict;
    }
    return nil;
}

- (NSDictionary *)face_search_faceid:(NSString *)faceid facesetid:(NSString *)facesetid topnum:(NSUInteger)num {
    if (!faceid || !facesetid) {
        NSLog(@"face search error : faceid or facesetid is nil");
        return nil;
    }
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!num) {
        parameters = @{
                       @"face_id":faceid,
                       @"faceset_id":facesetid,
                       };
    } else {
        parameters = @{
                       @"face_id":faceid,
                       @"faceset_id":facesetid,
                       @"top":[NSNumber numberWithInteger:num]
                       };
    }
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_SEARCH];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return dict;
    }
    return nil;
}

- (NSDictionary *)face_identification_faceid:(NSString *)faceid groupid:(NSString *)groupid topnum:(NSUInteger)num {
    if (!faceid || !groupid) {
        NSLog(@"face identification error : faceid or groupid is nil");
        return nil;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_IDENTIFICATION];
    
    NSDictionary *parameters = @{
                                 @"face_id":faceid,
                                 @"group_id":groupid,
                                 @"top":[NSNumber numberWithInteger:num]
                                 };
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return dict;
    }
    return nil;
    
}

- (BOOL)face_training_faceids:(NSString *)faceids {
    if ( !faceids ) {
        NSLog(@"face training error : faceids is nil");
        return NO;
    }
    NSDictionary *parameters = @{@"face_id":faceids};

    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_TRAINING];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;

}
- (BOOL)face_training_personids:(NSString *)personids {
    if ( !personids ) {
        NSLog(@"face training error : personids is nil");
        return NO;
    }
    NSDictionary *parameters = @{@"person_id":personids};
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_TRAINING];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}
- (BOOL)face_training_facesetids:(NSString *)facesetids {
    if ( !facesetids ) {
        NSLog(@"face training error : facesetids is nil");
        return NO;
    }
    NSDictionary *parameters = @{@"faceset_id":facesetids};
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_TRAINING];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}
- (BOOL)face_training_groupids:(NSString *)groupids {
    if ( !groupids ) {
        NSLog(@"face training error : groupids is nil");
        return NO;
    }
    NSDictionary *parameters = @{@"group_id":groupids};
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_TRAINING];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}
- (BOOL)face_training_faceids:(NSString *)faceids personids:(NSString *)personids facesetids:(NSString *)facesetids groupids:(NSString *)groupids {
    
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!faceids && !personids && !facesetids && !groupids) {
        NSLog(@"face training error : faceids & personids & facesetids & groupids is nil");
        return NO;
    }
    //one key
    if ( faceids ) {
        parameters = @{
                       @"face_id":faceids
                       };
    }
    if ( personids ) {
        parameters = @{
                       @"person_id":personids
                       };
    }
    if ( facesetids ) {
        parameters = @{
                       @"faceset_id":facesetids
                       };
    }
    if ( groupids ) {
        parameters = @{
                       @"group_id":groupids
                       };
    }
    
    //two key
    if ( faceids && personids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"person_id":personids
                       };
    }
    if ( faceids && facesetids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"faceset_id":facesetids
                       };
    }
    if ( faceids && groupids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"group_id":groupids
                       };
    }
    
    if ( personids && facesetids ) {
        parameters = @{
                       @"person_id":personids,
                       @"faceset_id":facesetids
                       };
    }
    if ( personids && groupids ) {
        parameters = @{
                       @"person_id":personids,
                       @"group_id":groupids
                       };
    }
    
    if ( facesetids && groupids) {
        parameters = @{
                       @"faceset_id":facesetids,
                       @"group_id":groupids
                       };
    }
    
    //three key
    if ( faceids && personids && facesetids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"person_id":personids,
                       @"faceset_id":facesetids
                       };
    }
    if ( faceids && personids && groupids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"person_id":personids,
                       @"group_id":groupids
                       };
    }
    if ( faceids && facesetids && groupids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"faceset_id":facesetids,
                       @"group_id":groupids
                       };
    }
    if ( personids && facesetids && groupids ) {
        parameters = @{
                       @"person_id":personids,
                       @"faceset_id":facesetids,
                       @"group_id":groupids
                       };
    }
    
    //four key
    if ( faceids && personids && facesetids && groupids ) {
        parameters = @{
                       @"face_id":faceids,
                       @"person_id":personids,
                       @"faceset_id":facesetids,
                       @"group_id":groupids
                       };
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACE_TRAINING];
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

#pragma mark 人的管理
- (STPerson *)person_create_name:(NSString *)name {
    if ( !name ) {
        NSLog(@"person create error : name is nil");
        return nil;
    }
    NSDictionary *parameters = @{@"name":name};
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,PERSON_CREATE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STPerson *stPerson = [[STPerson alloc]initWithDict:dict];
        if ( self.bDebug ){
            NSLog(@"STPerson = %@", stPerson);
        }
        return stPerson;
        
    }
    return nil;
}
- (STPerson *)person_create_name:(NSString *)name faceids:(NSString *)faceids userdata:(NSString *)userdata {
    if ( !name ) {
        NSLog(@"person create error : name is nil");
        return nil;
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    // one key
    if (name ) {
        parameters = @{
                       @"name":name
                       };
    }
    if ( faceids ) {
        parameters = @{
                       @"name":name,
                       @"face_id":faceids
                       };
        }
    if (userdata) {
        parameters = @{
                       @"name":name,
                       @"user_data":userdata
                       };
    }
    //two key
    if (faceids && userdata) {
        parameters = @{
                       @"name":name,
                       @"face_id":faceids,
                       @"user_data":userdata
                       };
    }
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,PERSON_CREATE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STPerson *stPerson = [[STPerson alloc]initWithDict:dict];
        if ( self.bDebug ){
            NSLog(@"STPerson = %@", stPerson);
        }
        return stPerson;
        
    }
    return nil;
}

- (BOOL)person_delete_personid:(NSString *)personid {
    if (!personid) {
        NSLog(@" person delete error : personid is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,PERSON_DELETE];
    
    NSDictionary *parameters = @{@"person_id":personid};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
    
}

- (BOOL)person_add_face_personid:(NSString *)personid faceids:(NSString *)faceids {
    if (!personid || !faceids) {
        NSLog(@"person add error : personid or faceids is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,PERSON_ADD_FACE];
    
    NSDictionary *parameters = @{@"person_id":personid,@"face_id":faceids};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)person_remove_face_personid:(NSString *)personid faceids:(NSString *)faceids {
    if (!personid || !faceids) {
        NSLog(@"person remove error : personid or faceids is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,PERSON_REMOVE_FACE];
    
    NSDictionary *parameters = @{@"person_id":personid,@"face_id":faceids};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)person_change_personid:(NSString *)personid name:(NSString *)name userdata:(NSString *)userdata {
    if ( !personid ) {
        NSLog(@"person change error : personid is nil");
        return NO;
    }
    if ( !name  && !userdata ) {
        NSLog(@"person change error : name & facesetid is nil");
        return NO;
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    //one key
    if ( name ) {
        parameters = @{
                       @"person_id":personid,
                       @"name":name
                       };
    }
    if ( userdata ) {
        parameters = @{
                       @"person_id":personid,
                       @"user_data":userdata
                       };
    }
    //two key
    if ( name && userdata ) {
        parameters = @{
                       @"person_id":personid,
                       @"name":name,
                       @"user_data":userdata
                       };
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,PERSON_CHANGE];
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

#pragma mark 组的管理
- (STGroup *)group_create_groupname:(NSString *)name {
    if ( !name ) {
        NSLog(@"group create error : name is nil");
        return nil;
    }
    
    NSDictionary *parameters = @{@"name":name};
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,GROUP_CREATE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STGroup *stGroup = [[STGroup alloc]initWithDict:dict];
        if ( self.bDebug ){
            NSLog(@"STGroup = %@", stGroup);
        }
        return stGroup;
        
    }
    return nil;
}

- (STGroup *)group_create_groupname:(NSString *)name personids:(NSString *)personids userdata:(NSString *)userdata {
    if ( !name ) {
        NSLog(@"group create error : name is nil");
        return nil;
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    //one key
    if ( name ) {
        parameters = @{
                       @"name":name
                       };
    }
    if ( personids ) {
        parameters = @{
                       @"name":name,
                       @"person_id":personids
                       };
    }
    if ( userdata ) {
        parameters = @{
                       @"name":name,
                       @"user_data":userdata
                       };
    }
    //two key
    if ( personids && userdata ) {
        parameters = @{
                       @"name":name,
                       @"person_id":personids,
                       @"user_data":userdata
                       };
    }
    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,GROUP_CREATE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        
        STGroup *stGroup = [[STGroup alloc]initWithDict:dict];
        if ( self.bDebug ){
            NSLog(@"STGroup = %@", stGroup);
        }
        return stGroup;
        
    }
    return nil;
}

- (BOOL)group_delete_groupid:(NSString *)groupid {
    if (!groupid ) {
        NSLog(@"group delete error : groupid is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,GROUP_DELETE];
    
    NSDictionary *parameters = @{@"group_id":groupid};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)group_add_person_groupid:(NSString *)groupid personids:(NSString *)personids {
    if ( !groupid || !personids ) {
        NSLog(@"group add error : groupid or personids is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,GROUP_ADD_PERSON];
    
    NSDictionary *parameters = @{@"group_id":groupid,@"person_id":personids};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)group_remove_person_groupid:(NSString *)groupid personids:(NSString *)personids {
    if ( !groupid || !personids ) {
        NSLog(@"group remove error : groupid or personids is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,GROUP_REMOVE_PERSON];
    NSDictionary *parameters = @{@"group_id":groupid,@"person_id":personids};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)group_change_person_groupid:(NSString *)groupid name:(NSString *)name userdata:(NSString *)userdata {
    if ( !groupid ) {
        NSLog(@"group change error : groupid is nil");
        return NO;
    }
    if ( !name  && !userdata ) {
        NSLog(@"group change error : name & facesetid is nil");
        return NO;
    }

    NSDictionary *parameters = [NSDictionary dictionary];
    //one key
    if ( name ) {
        parameters = @{
                       @"group_id":groupid,
                       @"name":name
                       };
    }
    if ( userdata ) {
        parameters = @{
                       @"group_id":groupid,
                       @"user_data":userdata
                       };
    }
    //two key
    if ( name && userdata ) {
        parameters = @{
                       @"group_id":groupid,
                       @"name":name,
                       @"user_data":userdata
                       };
    }

    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,GROUP_CHANGE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

#pragma mark 人脸集合的管理
- (STFaceSet *)faceset_create_name:(NSString *)name {
    if ( !name ) {
        NSLog(@"faceset create error : name is nil");
        return nil;
    }
    
    NSDictionary *parameters = @{@"name":name};
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACESET_CREATE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        STFaceSet *stFaceSet = [[STFaceSet alloc]initWithDict:dict];
        if ( self.bDebug ){
            NSLog(@"STFaceSet = %@", stFaceSet);
        }
        return stFaceSet;
    }
    return nil;
}
- (STFaceSet *)faceset_create_name:(NSString *)name faceids:(NSString *)faceids userdata:(NSString *)userdata {
    if ( !name ) {
        NSLog(@"faceset create error : name is nil");
        return nil;
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    //one key
    if ( name ) {
        parameters = @{
                       @"name":name
                       };
    }
    if ( faceids ) {
        parameters = @{
                       @"name":name,
                       @"face_id":faceids
                       };
    }
    if ( userdata ) {
        parameters = @{
                       @"name":name,
                       @"user_data":userdata,
                       };
    }
    //two key
    if ( faceids && userdata ) {
        parameters = @{
                       @"name":name,
                       @"face_id":faceids,
                       @"user_data":userdata,
                       };
    }

    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACESET_CREATE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        STFaceSet *stFaceSet = [[STFaceSet alloc]initWithDict:dict];
        if ( self.bDebug ){
            NSLog(@"STFaceSet = %@", stFaceSet);
        }
        return stFaceSet;
    }
    return nil;
}

- (BOOL)faceset_delete_facesetid:(NSString *)facesetid {
    if (!facesetid ) {
        NSLog(@"faceset delete : facesetid is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACESET_DELETE];
    
    NSDictionary *parameters = @{@"faceset_id":facesetid};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)faceset_add_face_facesetid:(NSString *)facesetid faceids:(NSString *)faceids {
    if (!facesetid || !faceids) {
        NSLog(@"faceset add error : facesetid or faceids is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACESET_ADD_FACE];
    
    NSDictionary *parameters = @{@"faceset_id":facesetid,@"face_id":faceids};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

- (BOOL)faceset_remove_facesetid:(NSString *)facesetid faceids:(NSString *)faceids {
    if (!facesetid || !faceids) {
        NSLog(@"faceset remove error : facesetid or faceids is nil");
        return NO;
    }
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACESET_REMOVE_FACE];
    
    NSDictionary *parameters = @{@"faceset_id":facesetid,@"face_id":faceids};
    
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}


- (BOOL)faceset_change_facesetid:(NSString *)facesetid name:(NSString *)name userdata:(NSString*)userdata {
    if ( !facesetid ) {
        NSLog(@"faceset change error : facesetid is nil");
        return NO;
    }
    if ( !name  && !userdata ) {
        NSLog(@"faceset change error : name & facesetid is nil");
        return NO;
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    //one key
    if ( name ) {
        parameters = @{
                       @"faceset_id":facesetid,
                       @"name":name
                       };
    }
    if ( userdata ) {
        parameters = @{
                       @"faceset_id":facesetid,
                       @"user_data":userdata
                       };
    }
    //two key
    if ( name && userdata ) {
        parameters = @{
                       @"faceset_id":facesetid,
                       @"name":name,
                       @"user_data":userdata
                       };
    }

    
    NSString *method = [NSString stringWithFormat:@"%@%@",BASE_URL,FACESET_CHANGE];
    NSDictionary *dict =  [self sendPostRequestWithMethod:method parameters:parameters];
    if ([self.status isEqualToString:STATUS_OK]&&dict) {
        return YES;
    }
    return NO;
}

# pragma mark - Utilities
// ------GET请求
- (NSDictionary *)sendGetRequestWithMethod:(NSString *)method parameters:(NSDictionary *)parameterDict {
    self.dictionary = nil ;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    
    NSMutableString *httpBodyString = [method mutableCopy];
    
    // ------GET请求的URL地址在参数前，需要加上?，表示参数列表开始
    
    [httpBodyString appendString:@"?"];
    
    // ------循环将参数拼接到URL后面
    for (NSString *key in parameterDict) {
        
        [httpBodyString appendFormat:@"%@=%@&", key, [parameterDict objectForKey:key]];
    }
    // 将string转为URL
    NSURL *url = [NSURL URLWithString:httpBodyString];
    
    // set URL
    [request setURL: url];
    
    if ( self.bDebug )
    {
        NSLog(@"[STAPI]request url: \n%@", [request URL]);
    }
    
    NSError *error = NULL;
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSError *jsonError = nil;
    
    if ( responseData != nil ) {
        
        self.dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        
        self.status = [self.dictionary objectForKey:STATUS_KEY];
        
        self.httpStatusCode = (int)urlResponse.statusCode;
    }
    
    self.error = error ;
    
    if ( self.httpStatusCode != 200 ) {
        
        NSLog(@"[STAPI Error]request httpStatusCode: %d : %@\n",
              self.httpStatusCode,
              [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]);
        return nil ;
    }
    if ( self.error != nil ) {
        
        NSLog(@"[STAPI Error]request error: %@\n", [self.error description] ) ;
        return nil ;
    }
    
    if ( self.bDebug )
        NSLog(@"[STAPI]response JSON: \n%@", [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]);
    
    if (jsonError != NULL) {
        self.error = jsonError ;
        return nil ;
    }
    if ( self.bDebug ){
        NSLog(@"[STAPI]response: \n%@", self.dictionary);
    }
    return self.dictionary ;
}

// ------POSt请求
- (NSDictionary *)sendPostRequestWithMethod:(NSString *)method parameters:(NSDictionary *)parameterDict {
    return [self sendPostRequestWithMethod:method parameters:parameterDict andImage:nil];
}

// ------POST请求上传图片
- (NSDictionary *)sendPostRequestWithMethod:(NSString *)method parameters:(NSDictionary *)parameterDict andImage:(UIImage *)image {
    self.dictionary = nil ;
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [self generateBoundaryString];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [[NSMutableData alloc] init];
    
    // add image data
    if ( image != nil )
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        
        if ( self.bDebug) {
            NSLog(@"imageData size is : %lu kb",imageData.length/1024);
        }
        
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpeg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // add user and key
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:FORM_LINE, API_ID, self.apiid] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:FORM_LINE, API_SECRET, self.apisecret] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add other parameters
    for (id key in parameterDict) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:FORM_LINE, key, [parameterDict objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",method];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    // set URL
    [request setURL: [NSURL URLWithString:urlString]];
    if ( self.bDebug )
        NSLog(@"[STAPI]request url: \n%@", [request URL]);
    
    NSError *error = NULL;
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSError *jsonError = nil;
    if ( responseData != nil ) {
        self.dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        self.status = [self.dictionary objectForKey:STATUS_KEY];
        self.httpStatusCode = (int)urlResponse.statusCode;
    }
    self.error = error ;
    if ( self.httpStatusCode != 200 ) {
        NSLog(@"[STAPI Error]request httpStatusCode: %d : %@\n",
              self.httpStatusCode,
              [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]);
        return nil ;
    }
    if ( self.error != nil ) {
        NSLog(@"[STAPI Error]request error: %@\n", [self.error description] ) ;
        return nil ;
    }
    
    if ( self.bDebug )
        NSLog(@"[STAPI]response JSON: \n%@", [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]);
    
    if (jsonError != NULL) {
        self.error = jsonError ;
        return nil ;
    }
    if ( self.bDebug )
        NSLog(@"[STAPI]response: \n%@", self.dictionary);
    return self.dictionary ;
    
}

-(NSString *)generateBoundaryString {
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    NSString *result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        default:
            break;
    }
    return nil;
}

@end
