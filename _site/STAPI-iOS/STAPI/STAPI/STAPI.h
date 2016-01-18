//
//  STAPI.h
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//
//  官网： http://www.sensetime.com/cn
//  SDK： https://github.com/SenseTimeApp/STAPI-iOS
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class STPerson;
@class STGroup;
@class STFaceSet;
@class STImage;
@class STFace;
/*! @brief STAPI接口函数类
 *
 * 该类封装了STAPI所有接口
 */
@interface STAPI : NSObject

// 单例的创建方法
+ (STAPI *)shareInstance;

/**
 *  客户端初始化函数 （建议在程序入口出调用，或者在调用其他STAPI之前调用）
 *
 *  @param apiid     SenseTime 的API ID
 *  @param apisecret SenseTime 的API SECRET
 */
- (void)start_apiid:(NSString *)apiid apisecret:(NSString *)apisecret;

// =======================信息获取===============================
/**
 *  获得当前账户的使用信息，包括频率限制以及各种数量限制，建议在程序入口调用，一方面测试调用方法是否正确，一方面也可以验证自己的api_id 和 api_secret
 *  @return 当前账户的使用信息
 */

- (NSDictionary *)info_api;

/**
 *  该 API 用于查询异步调用时的 HTTP 请求处理情况，详情请查看PDF.
 *  @param taskid    必须，有效期为 24 小时。异步调用时获得的任务 ID
 *
 *  @return 异步调用时的 HTTP 请求处理情况
 */

- (NSDictionary *)info_task_taskid:(NSString *)taskid;

/**
 *  可以获得图片的相关信息
 *  @param imageid   必须，图片 ID
 *  @param faces     非必须 是否返回图片中人脸信息，为 YES 时返回。默认为 NO，不返回
 *
 *  @return STImage对象的字典
 */

- (NSDictionary *)info_image_imageid:(NSString *)imageid withfaces:(BOOL)faces;

/**
 *  获取检测过的人脸的相关信息
 *
 *  @param faceid    必须，人脸 ID
 *  @param image     非必须 是否返回人脸所属图片信息，为 YES 时返回。默认为 NO，不返回
 *
 *  @return STFace对象的字典
 */
- (NSDictionary *)info_face_faceid:(NSString *)faceid withimage:(BOOL)image;

/**
 *  查询该账户目前所拥有的人的信息
 *
 *  @return STPerson对象字典
 */
- (NSDictionary *)info_list_persons;

/**
 *  查询该账户所拥有的组
 *
 *  @return STGroup对象字典
 */
- (NSDictionary *)info_list_groups;

/**
 *  查询该账户所拥有的人脸集合
 *
 *  @return STFaceSet对象字典
 */
- (NSDictionary *)info_list_facesets;

/**
 *  获取人的信息及其含有的人脸 ID
 *
 *  @param personid STPerson对象人的 ID
 *
 *  @return STPerson对象的字典
 */
- (NSDictionary*)info_personid:(NSString *)personid;


/**
 *  查询组的相关信息，包括组的名字、组的自定义数据以及组所拥有的人的信息
 *
 *  @param groupid   必须，组的 ID
 *
 *  @return STGroup对象的字典
 */
- (NSDictionary *)info_groupid:(NSString *)groupid;

/**
 *  获取人脸集合
 *
 *  @param facesetid 必须，人脸集合的 ID
 *
 *  @return STFaceSet对象的字典
 */
- (NSDictionary *)info_faceset_facesetid:(NSString *)facesetid;


#pragma mark - face detection

// =======================人脸检测与分析===============================
/**
 *  提供图片，进行人脸检测以及人脸分析
 *
 *  @param image        必须，格式必须为 JPG（JPEG），BMP，PNG，GIF，TIFF 之一,
                             宽和高必须大于 8px，小于等于 4000px
                             文件尺寸小于等于 5 MB
                             上传本地图片需上传的图片文件
*   注意：对于其他可选参数（如auto_rotate，landmarks106和 attribute），如果没有需求，请不要开启，这样会减少系统计算时间
 *  @param landmarks106 非必须，值为 1 时，计算 106 个关键点。默认值为 0，不计算
 *  @param attributes   非必须，值为 1 时，提取人脸属性。默认值为 0，不提取
 *  @param auto_rotate  非必须，值为1时，对图片进行自动旋转。默认值为0时，不旋转
 *  @param user_data    非必须，用户自定义信息
 *
 *  @return STImage对象
 */
-(STImage *)face_detection_image:(UIImage *)image ;

-(STImage *)face_detection_image:(UIImage *)image
                    landmarks106:(BOOL)landmarks106
                      attributes:(BOOL)attributes
                     auto_rotate:(BOOL)auto_rotate
                       user_data:(NSString *)user_data;

/**
 *  提供图片，进行人脸检测以及人脸分析
 *
 *  @param imageurl     必须，格式必须为 JPG（JPEG），BMP，PNG，GIF，TIFF 之一,
                             宽和高必须大于 8px，小于等于 4000px
                             文件尺寸小于等于 5 MB
                             网络图片方式时,图片网络地址
 *   注意：对于其他可选参数（如auto_rotate，landmarks106和 attribute），如果没有需求，请不要开启，这样会减少系统计算时间
 *  @param landmarks106 非必须，值为 1 时，计算 106 个关键点。默认值为 0，不计算
 *  @param attributes   非必须，值为 1 时，提取人脸属性。默认值为 0，不提取
 *  @param auto_rotate  非必须，值为1时，对图片进行自动旋转。默认值为0时，不旋转
 *  @param user_data    非必须，用户自定义信息
 *
 *  @return STImage对象
 */
- (STImage *)face_detection_url:(NSString *) strImageUrl    ;

- (STImage *)face_detection_url:(NSString *) strImageUrl
                   landmarks106:(BOOL)landmarks106
                     attributes:(BOOL)attributes
                    auto_rotate:(BOOL)auto_rotate
                      user_data:(NSString *)user_data;


#pragma mark - face verification

/**
 *  一对一人脸对比的功能
 *
 *  @param faceid  人脸 ID
 *  @param face2id  人脸 2 的 ID，脸与脸对比返回该字段
 *
 *  @return 对比的分数 大于于 0.6 时判断为同一人,
 */
- (float)face_verification_faceid:(NSString *)faceid face2id:(NSString *)face2id;


/**
 *  主要功能是将一个人脸与另外一个人进行对比,有可能发生异步调用,异步调用的详细说明请参考PDF
 *
 *  @param faceid  人脸 ID
 *  @param personid 人的 ID，脸与人对比返回该字段
 *
 *  @return 对比的分数 大于于 0.6 时判断为同一人
 */
- (float)face_verification_faceid:(NSString *)faceid personid:(NSString *)personid;


#pragma mark - face search

/**
 *  在众多人脸中搜索出与目标人脸最为相似的一张或者多张人脸,有可能发生异步调用,异步调用的详细说明请参考PDF
 *
 *  @param faceid    人脸 ID
 *  @param faceids 人脸 ID 数组
 *  @param num     非必须,最多返回 top 个相似人脸，值为 1~10，默认为 3
 *
 *  @return 相似的人脸字典
 */
- (NSDictionary *)face_search_faceid:(NSString *)faceid faceids:(NSString *)faceids topnum:(NSUInteger)num;

/**
 *  在众多人脸中搜索出与目标人脸最为相似的一张或者多张人脸,有可能发生异步调用,异步调用的详细说明请参考PDF
 *
 *  @param faceid      人脸 ID
 *  @param facesetid 人脸集合 ID
 *  @param num       非必须,最多返回 top 个相似人脸，值为 1~10，默认为 3
 *
 *  @return 相似的人脸字典，包括人脸 ID 以及置信度
 */
- (NSDictionary *)face_search_faceid:(NSString *)faceid facesetid:(NSString *)facesetid topnum:(NSUInteger)num;


#pragma mark - face identification

/**
 *  将一个目标人脸与某个组中的所有人进行对比,有可能发生异步调用,异步调用的详细说明请参考PDF
 *
 *  @param faceid  人脸 ID
 *  @param groupid 组的 ID
 *  @param num     非必须，最多返回 top 个人，值为 1~5，默认为 2
 *
 *  @return 当搜索出的人与目标人脸的置信度大于 0.6 时 candidates 中才会有结果返回。
 */
- (NSDictionary *)face_identification_faceid:(NSString *)faceid groupid:(NSString *)groupid topnum:(NSUInteger)num;


#pragma mark - face training

/**
 *  对人脸、人、人脸集合、组进行训练,有可能发生异步调用,异步调用的详细说明请参考PDF
 *  请求参数 face_id、person_id、faceset_id、group_id 至少存在一个，可多选
 *  @param faceids    人脸 ID 数组，多个人脸信息时以逗号分隔
 *  @param personids  人的 ID 数组，多个人时以逗号分隔
 *  @param facesetids 人脸集合 ID 数组，多个人脸集合时以逗号分隔
 *  @param groupids   组的 ID 数组，多个组时以逗号分隔
 *
 *  @return YES成功，NO 失败
 */
- (BOOL)face_training_faceids:(NSString *)faceids;
- (BOOL)face_training_personids:(NSString *)personids;
- (BOOL)face_training_facesetids:(NSString *)facesetids;
- (BOOL)face_training_groupids:(NSString *)groupids;

- (BOOL)face_training_faceids:(NSString *)faceids personids:(NSString *)personids facesetids:(NSString *)facesetids groupids:(NSString *)groupids;



#pragma mark - 人的管理

// =======================人的管理===============================

/**
 *  创建一个人。创建人时，可以同时为其添加人脸信息，也可以加上自定义信息
 *
 *  @param name   必须，人名
 *  @param faceids 非必须，人脸的ID数组，多个人脸时以逗号分隔。注意：一个 face_id 只能添加到一个 person 中。
 *  @param userdata 非必须，用户自定义信息
 *
 *  @return STPerson对象
 */
- (STPerson *)person_create_name:(NSString *)name;
- (STPerson *)person_create_name:(NSString *)name faceids:(NSString *)faceids userdata:(NSString *)userdata;

/**
 *  是删除一个人,删除人后，该人所拥有的人脸 ID 若未过期，则人脸 ID 不会失效。
 *
 *  @param personid ，要删除的人的 ID
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)person_delete_personid:(NSString *)personid;


/**
 *  人创建成功后，调用本 API，可以为该人添加人脸信息。
 *
 *  @param personid ，要添加的人的 ID
 *
 *  @param faceids ，人脸的 ID 数组
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)person_add_face_personid:(NSString *)personid faceids:(NSString *)faceids;

/**
 *  作用是移除人脸，使其不再属于这个人
 *
 *  @param personid ，要删除的人的 ID
 *
 *  @param faceids ，人脸的 ID 数组
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)person_remove_face_personid:(NSString *)personid faceids:(NSString *)faceids;


/**
 *  用于修改 person 的 user_data 和 name 信息
 *
 *  @param personid   STPerson对象 的 ID
 *  @param name     人名
 *  @param userdata 用户自定义数据
 *   请求参数 name、user_data 两者中至少存在一个。
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)person_change_personid:(NSString *)personid name:(NSString *)name userdata:(NSString *)userdata;



#pragma mark - 组的管理

// =======================组的管理===============================

/**
 *  用于创建一个组。创建组的同时可以向该组中添加人。
 *
 *  @param name     组名
 *  @param personids 非必须, STPerson 数组，多个数据时用逗号分隔
 *  @param userdata 非必须, 用户自定义信息
 *
 *  @return STGroup 对象
 */
- (STGroup *)group_create_groupname:(NSString *)name;
- (STGroup *)group_create_groupname:(NSString *)name personids:(NSString *)personids userdata:(NSString *)userdata;

/**
 *  删除一个组
 *
 *  @param groupid STGroup对象中的strGroupID
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)group_delete_groupid:(NSString *)groupid;

/**
 *  组创建成功后，调用本 API，可以为组添加人(一个人可以属于多个组)。
 *
 *  @param groupid STGroup对象中的strGroupID
 *  @param personids  STPerson中 strPersonID 的数组（如果其中有一个或多个 person_id 无效时，那么其他的 person_id 也会添加失败）
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)group_add_person_groupid:(NSString *)groupid personids:(NSString *)personids;


/**
 *  本 API 的作用是移除组中的人。
 *
 *  @param groupid   STGroup对象中strGroupID
 *  @param personids  STPerson中 strPersonID 的数组
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)group_remove_person_groupid:(NSString *)groupid personids:(NSString *)personids;

/**
 *  用于修改 group 的 user_data 和 name 信息
 *
 *  @param groupid  STGroup对象中strGroupID 组的 ID
 *  @param name     组名
 *  @param userdata 用户自定义数据
 *  请求参数 name、user_data 两者中至少存在一个
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)group_change_person_groupid:(NSString *)groupid name:(NSString *)name userdata:(NSString *)userdata;


#pragma mark - 人脸集合的管理

// =======================人脸集合的管理===============================

/**
 *  是创建一个人脸集合
 *
 *  @param name     人脸集合名
 *  @param faceids   非必须，人脸的 ID(STFace对象strPersonID)数组
 *  @param userdata 非必须，用户自定义信息
 *
 *  @return STFaceSet对象
 */
- (STFaceSet *)faceset_create_name:(NSString *)name;
- (STFaceSet *)faceset_create_name:(NSString *)name faceids:(NSString *)faceids userdata:(NSString *)userdata;

/**
 *  是删除一个人脸集合
 *
 *  @param facesetid 要删除的人脸集合的 ID
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)faceset_delete_facesetid:(NSString *)facesetid;

/**
 *  可以向人脸集合中添加人脸
 *
 *  @param facesetid 人脸集合的ID(STFaceSet的strFaceSetID)
 *  @param faceids    人脸的 ID 数组（STFace的strPersonID）
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)faceset_add_face_facesetid:(NSString *)facesetid faceids:(NSString *)faceids;

/**
 *  移除人脸集合所含有的人脸，使其不再属于该人脸集合
 *
 *  @param facesetids 人脸集合的ID(STFaceSet的strFaceSetID)
 *  @param faceids    人脸的 ID（STFace的strFaceSetID） 数组
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)faceset_remove_facesetid:(NSString *)facesetid faceids:(NSString *)faceids;

/**
 *  用于修改人脸集合的 user_data 和 name 信息。
 *
 *  @param facesetid 人脸集合的ID(STFaceSet的strFaceSetID)
 *  @param name      人脸集合名
 *  @param userdata  用户自定义数据
 *  请求参数name 与 user_data 二者中至少存在一个
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)faceset_change_facesetid:(NSString *)facesetid name:(NSString *)name userdata:(NSString*)userdata;


/** API 返回的JSON Dictionary*/
@property (nonatomic, strong, readonly) NSDictionary *dictionary;

/** 调试开关（控制NSLog的输出）*/
@property (nonatomic, assign) BOOL bDebug;


/**
 *  httpStatusCode 访问状态返回代码
 *
 *
 * 部分HTTP错误代码
 *
 * 200 - 确定。客户端请求已成功
 *
 * 400 - 错误的请求(最常见的错误，通常是提供的参数（数量、类型） 不符合要求，或者操作内容无效)
 *
 * 401 - 用户验证错误(未授权)
 *
 * 403 - 禁止访问(可能是本用户没有权限调用该 API，或者超过了调用限额)
 *
 * 404 - 未找到(没有找到 API，通常是 URL 写错了)
 *
 * 413 - 请求体过大(通常是上传的文件过大导致)
 *
 * 5xx - 内部服务器错误(其中 500 错误最常见)
 */
@property int httpStatusCode;

/**
 *  status 返回状态代码 （API错误类型）
 *
 *  OK          - 正常
 *
 *  UNAUTHORIZED - 账号或密钥错误
 *
 *  KEY_EXPIRED  - 账号过期，具体情况见 reason 字段内容
 *
 *  RATE_LIMIT_EXCEEDED  - 调用频率超出限额
 *
 *  NOT_FOUND - 请求路径错误
 *
 *  INTERNAL_ERROR - 服务器内部错误
 *
 *  INVALID_XXXX - XXXX 无效
 
 */
@property (nonatomic, strong) NSString* status;

/** STAPI对象中的error属性(可以获取STAPI对象的error)*/
@property (nonatomic, strong) NSError* error;

@end
