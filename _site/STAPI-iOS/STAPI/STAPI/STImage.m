//
//  STImage.m
//  STAPI
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STImage.h"
@interface STImage ()

/**图片所有信息*/
@property (nonatomic, strong, readwrite) NSDictionary *dictFull;

/**图片的 ID*/
@property (nonatomic, strong, readwrite) NSString *strImageID;
/** 图片的宽度（px）*/
@property (nonatomic, assign, readwrite) NSUInteger iWidth;

/** 图片的高度（px）*/
@property (nonatomic, assign, readwrite) NSUInteger iHeidth;

/** 图片中包含的人脸的数组，若未包含则为空数组*/
@property (nonatomic, strong, readwrite) NSArray *arrFaces;

//@property (nonatomic, strong, readwrite) NSString *strRotate;
//
//@property (nonatomic, assign, readwrite) NSUInteger iexif_orientation;
//
///** 用户自定义信息*/
//@property (nonatomic, strong, readwrite) NSString *strUserData;
@end
@implementation STImage

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.strImageID = [dict objectForKey:@"image_id"];
        self.iWidth = [[dict objectForKey:@"width"] integerValue];
        self.iHeidth = [[dict objectForKey:@"height"] integerValue];
        self.arrFaces = [dict objectForKey:@"faces"];
        self.dictFull = dict ;
    }
    
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@", self.dictFull] ;
}
@end
