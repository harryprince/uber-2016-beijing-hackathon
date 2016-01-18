//
//  ImageFace.h
//  STAPI_Demo
//
//  Created by SenseTime on 15/12/31.
//  Copyright © 2015年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STImage.h"
#import "FaceDot.h"
#import <UIKit/UIKit.h>

@interface ImageFace : NSObject

@property (readwrite, nonatomic, strong) NSString *strFaceID;
@property (readwrite, nonatomic, strong) NSString *strEyeDist;
@property (readwrite, nonatomic, strong) NSMutableArray *arrPoints;
@property (nonatomic, assign) int left;
@property (nonatomic, assign) int right;
@property (nonatomic, assign) int top;
@property (nonatomic, assign) int bottom;

- (instancetype)initWithDict:(NSDictionary *)dic landmarksType:(int)mark;

@end
