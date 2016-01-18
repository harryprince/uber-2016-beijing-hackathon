//
//  STGroup.h
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

@interface STGroup : NSObject
- (instancetype)init __attribute__((unavailable("Must initiate STPerson with a PERSON_UUID")));
- (instancetype)initWithDict:(NSDictionary *)dict;
/** 组的 ID*/
@property (nonatomic, strong, readonly) NSString *strGroupID;
/** 组名*/
@property (nonatomic, strong, readonly) NSString *strGroupName;

/** 含有的人的数量，若为 0，则不返回该字段*/
@property (nonatomic, assign, readonly) NSUInteger iPersonCount;

@end
