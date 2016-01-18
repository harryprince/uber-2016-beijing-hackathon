//
//  ImageFace.m
//  STAPI_Demo
//
//  Created by SenseTime on 15/12/31.
//  Copyright © 2015年 SenseTime. All rights reserved.
//

#import "ImageFace.h"


@implementation ImageFace


//extract faces
- (instancetype)initWithDict:(NSDictionary *)dic landmarksType:(int)mark
{
    self = [super init];
    if (self)
    {
        self.arrPoints = [[NSMutableArray alloc] init];
        self.strFaceID = dic[@"face_id"];
        self.strEyeDist = dic[@"eye_dist"];
        if (mark == 21)
        {
            for (int k=0; k<mark; k++)
            {
                float x = [dic[@"landmarks21"][k][0] floatValue];
                float y = [dic[@"landmarks21"][k][1] floatValue];
                FaceDot *dot = [[FaceDot alloc] init];
                dot.x = x;
                dot.y = y;
                [self.arrPoints addObject:dot];
            }
        }
        else
        {
            for (int k=0; k<mark; k++)
            {
                float x = [dic[@"landmarks106"][k][0] floatValue];
                float y = [dic[@"landmarks106"][k][1] floatValue];
                FaceDot *dot = [[FaceDot alloc] init];
                dot.x = x;
                dot.y = y;
                [self.arrPoints addObject:dot];
            }
        }
        NSString *left = dic[@"rect"][@"left"];
        self.left = [left intValue];
        NSString *right = dic[@"rect"][@"right"];
        self.right = [right intValue];
        NSString *top = dic[@"rect"][@"top"];
        self.top = [top intValue];
        NSString *bottom = dic[@"rect"][@"bottom"];
        self.bottom = [bottom intValue];
    }
    return self;
}


@end
