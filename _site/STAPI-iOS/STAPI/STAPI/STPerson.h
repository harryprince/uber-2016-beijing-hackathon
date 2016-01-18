//
//  STAPIPerson.h
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

@interface STPerson : NSObject
- (instancetype)init __attribute__((unavailable("Must initiate STPerson with a PERSON_UUID")));

- (instancetype)initWithDict:(NSDictionary *)dict;
/** 人的 ID*/
@property (nonatomic, strong, readonly) NSString *strPersonID;
/** 人名*/
//@property (nonatomic, strong, readonly) NSString *strName;
///** 该人所拥有的人脸数量*/
@property (nonatomic, assign, readonly) NSUInteger iFaceCount;
///** 该人拥有的人脸 ID 数组*/
//@property (nonatomic, strong, readonly) NSMutableArray *arrFaceIDs;
///** 用户自定义信息*/
//@property (nonatomic, strong, readonly) NSString *strUserData;

@end
