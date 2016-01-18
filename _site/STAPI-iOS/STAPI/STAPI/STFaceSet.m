//
//  STFaceSet.m
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STFaceSet.h"

@interface STFaceSet ()

@property (nonatomic, strong, readwrite) NSString *strFaceSetID;

@property (nonatomic, strong, readwrite) NSString *strFaceSetName;

@property (nonatomic, assign, readwrite) NSUInteger iFaceCount;
@end
@implementation STFaceSet

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.strFaceSetID = [dict objectForKey:@"faceset_id"];
        self.strFaceSetName = [dict objectForKey:@"name"];
        self.iFaceCount = [[dict objectForKey:@"face_count"]integerValue];
    }
    return self;
}

@end
