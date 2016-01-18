//
//  STFace.h
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//
//  官网： http://www.sensetime.com/cn
//  SDK： https://github.com/SenseTimeApp/STAPI-iOS
//
//

#import <Foundation/Foundation.h>

@interface STFace : NSObject
- (instancetype)init __attribute__((unavailable("Must initiate STPerson with a PERSON_UUID")));
/** 人脸的ID*/
@property (nonatomic, strong, readonly) NSString *strFaceID;
/** 人名*/
@property (nonatomic, strong, readonly) NSString *strName;
/** 该人所拥有的人脸数量*/
@property (nonatomic, assign, readonly) NSUInteger iFaceCount;
/** 用户自定义信息*/
@end
