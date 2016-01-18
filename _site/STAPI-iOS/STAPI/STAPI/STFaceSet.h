//
//  STFaceSet.h
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//  人脸集合
//
//  官网： http://www.sensetime.com/cn
//  SDK： https://github.com/SenseTimeApp/STAPI-iOS
//

#import <Foundation/Foundation.h>

@interface STFaceSet : NSObject
- (instancetype)init __attribute__((unavailable("Must initiate STPerson with a PERSON_UUID")));

- (instancetype)initWithDict:(NSDictionary *)dict;

/** 人脸集合的 ID*/
@property (nonatomic, strong, readonly) NSString *strFaceSetID;
/** 人脸集合的名称*/
@property (nonatomic, strong, readonly) NSString *strFaceSetName;

/** 该人脸集合所拥有的人脸数量，若为 0，则不返回该字段*/
@property (nonatomic, assign, readonly) NSUInteger iFaceCount;

@end
