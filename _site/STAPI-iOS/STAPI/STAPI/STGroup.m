//
//  STGroup.m
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STGroup.h"

@interface STGroup ()

@property (nonatomic, strong, readwrite) NSString *strGroupID;
@property (nonatomic, strong, readwrite) NSString *strGroupName;
@property (nonatomic, assign, readwrite) NSUInteger iPersonCount;
@end
@implementation STGroup

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.strGroupID = [dict objectForKey:@"group_id"];
        self.strGroupName = [dict objectForKey:@"name"];
        self.iPersonCount = [[dict objectForKey:@"person_count"] integerValue];
        
    }
    return self;
}
@end
