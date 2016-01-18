//
//  STImage.h
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

@interface STImage : NSObject
- (instancetype)init __attribute__((unavailable("Must initiate STImage with a strImageID or Dict")));

- (instancetype)initWithDict:(NSDictionary *)dict;

/**图片所有信息*/
@property (nonatomic, strong, readonly) NSDictionary *dictFull;

/**图片的 ID*/
@property (nonatomic, strong, readonly) NSString *strImageID;

/** 图片的宽度（px）*/
@property (nonatomic, assign, readonly) NSUInteger iWidth;

/** 图片的高度（px）*/
@property (nonatomic, assign, readonly) NSUInteger iHeidth;

/** 图片中包含的人脸的数组，若未包含则为空数组*/
@property (nonatomic, strong, readonly) NSArray *arrFaces;

/** 当 auto_rotate 功能打开时，如果发生了旋转，则会返回此字段，可能的值为 cw90，cw180，cw270，表明顺时针旋转的角度。如果没有发生旋转，则不返回此字段*/
//@property (nonatomic, strong, readonly) NSString *strRotate;
//
///** 表示图片含有 exif 信息，返回值范围为 1~8 。如果图片不含 exif 信息，则不返回该字段
//    返回值的具体含义请参考 http://jpegclub.org/exif_orientation.html
// */
//@property (nonatomic, assign, readonly) NSUInteger iexif_orientation;
//
///** 用户自定义信息*/
//@property (nonatomic, strong, readonly) NSString *strUserData;



@end
