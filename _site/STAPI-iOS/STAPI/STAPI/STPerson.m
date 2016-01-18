//
//  STAPIPerson.m
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STPerson.h"

@interface STPerson ()



@property (nonatomic, strong, readwrite) NSString *strPersonID;

@property (nonatomic, strong, readwrite) NSString *strName;

@property (nonatomic, assign, readwrite) NSUInteger iFaceCount;
//
//@property (nonatomic, strong, readwrite) NSMutableArray *arrFaceIDs;
//
//@property (nonatomic, strong, readwrite) NSString *strUserData;

@end
@implementation STPerson
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        
        self.strPersonID = [dict objectForKey:@"person_id"];
        self.iFaceCount = [[dict objectForKey:@"face_count"]integerValue];
    }
    return self;
    
}

@end
