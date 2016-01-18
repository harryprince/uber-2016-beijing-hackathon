
//
//  STAPITests.m
//  STAPITests
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STAPI.h"
#import "STCommon.h"
#import "STImage.h"
#import "STGroup.h"
#import "STFaceSet.h"
#import "STPerson.h"

#import "MyAPIKey.h"
// define my API key as following :
//    #define MyApiID 		@"***********************"
//    #define MyApiSecret 	@"***********************"

@implementation NSBundle (MyAppTests)

+ (NSBundle *)testBundle {
    // return the bundle which contains our test code
    return [NSBundle bundleWithIdentifier:@"com.SenseTime.STAPITests"];
}

@end


@interface STAPITests : XCTestCase

@property (nonatomic, strong) STAPI *stApi;
@property (nonatomic, strong) STPerson *personJay;

@property (nonatomic, copy) NSString *strFaceID1;
@property (nonatomic, copy) NSString *strFaceID2;
@property (nonatomic, copy) NSString *strFaceID3;

@end

@implementation STAPITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if ( self.stApi != nil )
        return ;
    
    self.stApi = [[STAPI alloc] init];
    [self.stApi start_apiid:MyApiID
                  apisecret:MyApiSecret] ;
    //    self.stApi.bDebug = YES ;
    
    
    if (self.strFaceID1 != nil) {
        return;
    }
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"Jay1" ofType:@"jpg"];
    UIImage *imageJay1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageJay1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;
    self.strFaceID1 = strFaceID1;
    
    if (self.strFaceID2 != nil) {
        return;
    }
    //create FaceSet with Two faces
    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"Jay2" ofType:@"jpg"];
    UIImage *imageFace2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageFace2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    self.strFaceID2 = strFaceID2;
    
    if (self.strFaceID3 != nil) {
        return;
    }
    NSString *strImagePath3 = [[NSBundle testBundle] pathForResource:@"Jack" ofType:@"jpg"];
    UIImage *imageFace3 = [UIImage imageWithContentsOfFile:strImagePath3];
    STImage *stImage3 = [self.stApi face_detection_image: imageFace3 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage3 ) ;
    XCTAssert       ( [stImage3.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage3.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID3 = stImage3.arrFaces[0][@"face_id"] ;
    self.strFaceID3 = strFaceID3;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1_info {
    
    STAPI *myLFApi = [[STAPI alloc] init];
    [myLFApi start_apiid:@"test" apisecret:@"test"] ;
    NSDictionary *dictResult = [myLFApi info_api] ;
    XCTAssert ( [myLFApi.status isEqualToString:STATUS_UNAUTHORIZED]) ;
    
    
    dictResult = [self.stApi info_api] ;
    //    NSLog( @"self.stApi info_api: %@", dictResult) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    
}

#pragma mark - /face/detection
//    /face/detection	用于提供图片URL，进行人脸检测以及人脸分析
- (void)test2_face_detection_image {
    
    NSString *strImagePath = [[NSBundle testBundle] pathForResource:@"Jay1" ofType:@"jpg"];
    UIImage *imageFace = [UIImage imageWithContentsOfFile:strImagePath];
    STImage *stImage = [self.stApi face_detection_image: imageFace ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    stImage = [self.stApi face_detection_image: imageFace
                                  landmarks106: YES
                                    attributes: YES
                                   auto_rotate: NO
                                     user_data: @"MyFaceDetection" ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks106"] count] == 106 ) ;
    
    XCTAssert       ( stImage.arrFaces[0][@"attributes"]                    ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"age"] >=0        ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"gender"] intValue]> 50     ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"eyeglass"] intValue] < 50   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"attractive"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"sunglass"] >=0   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"smile"] >=0      ) ;
    
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"]                    ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"angry"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"calm"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"disgust"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"happy"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"sad"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"surprised"] >=0 ) ;
    
}

- (void)test2_face_detection_url {
    
    NSString *strUrl = @"http://images.missyuan.com/attachments/day_080127/20080127_05b8ca77b0d5a1a4aae3CslCIEfqu5Gz.jpg";
    STImage *stImage = [self.stApi face_detection_url: strUrl ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    stImage = [self.stApi face_detection_url: strUrl
                                landmarks106: YES
                                  attributes: YES
                                 auto_rotate: NO
                                   user_data: @"MyFaceDetection" ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks106"] count] == 106 ) ;
    
    XCTAssert       ( stImage.arrFaces[0][@"attributes"]                    ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"age"] >=0        ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"gender"] intValue]< 50     ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"eyeglass"] intValue] < 50   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"attractive"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"sunglass"] >=0   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"smile"] >=0      ) ;
    
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"]                    ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"angry"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"calm"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"disgust"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"happy"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"sad"] >=0 ) ;
//    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"surprised"] >=0 ) ;
    
}

#pragma mark -  /face/verification
//    /face/verification	将一张人脸与一个人（或者一张脸）进行对比，来判断是否为同一个人
- (void)test3_Face_verification_faceid {
    // not value
    float fValue = [self.stApi face_verification_faceid:nil face2id:nil];
    XCTAssert( fValue == -1 ) ;
    
    //same
    float fScoreSame = [self.stApi face_verification_faceid:self.strFaceID2 face2id:self.strFaceID1] ;
    XCTAssert( fScoreSame > 0.6 ) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    
    
    //different
    float fScoreDiff = [self.stApi face_verification_faceid:self.strFaceID3 face2id:self.strFaceID1] ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssert( fScoreDiff < 0.6 ) ;
    
}

- (void)test3_ImageInfo {
    NSDictionary *dictInfoImage1 = [self.stApi info_face_faceid:self.strFaceID1 withimage:NO];
    XCTAssertNotNil(dictInfoImage1);
    
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssert       (  [dictInfoImage1[@"status"]isEqualToString:STATUS_OK] ) ;
    XCTAssert       (  dictInfoImage1[@"face_id"] ) ;
    XCTAssert       (  dictInfoImage1[@"eye_dist"] > 0 ) ;
    XCTAssert       (  dictInfoImage1[@"rect"][@"bottom"] > dictInfoImage1[@"rect"][@"top"]   ) ;
    XCTAssert       (  dictInfoImage1[@"rect"][@"left"]   < dictInfoImage1[@"rect"][@"right"] ) ;
    XCTAssert       (  [dictInfoImage1[@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [dictInfoImage1[@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [dictInfoImage1[@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [dictInfoImage1[@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    
    NSDictionary *dictInfoImage2 = [self.stApi info_face_faceid:self.strFaceID1 withimage:YES];
    XCTAssertNotNil(dictInfoImage2);
    XCTAssert       (  [dictInfoImage2[@"status"]isEqualToString:STATUS_OK] ) ;
    XCTAssert       (  dictInfoImage2[@"face_id"] ) ;
    XCTAssert       (  dictInfoImage2[@"image"][@"image_id"] ) ;
    XCTAssert       (  [dictInfoImage2[@"image"][@"height"] integerValue]== 450 ) ;
    XCTAssert       (  [dictInfoImage2[@"image"][@"width"] integerValue]== 365 ) ;
    
    
    //imageid
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"Jay1" ofType:@"jpg"];
    UIImage *imageJay1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageJay1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssertNotNil ( stImage1.strImageID ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    
    
    NSDictionary *dictInfoImage3 = [self.stApi info_image_imageid:stImage1.strImageID withfaces:YES];
    XCTAssertNotNil(dictInfoImage3);
    XCTAssert       (  [dictInfoImage3[@"status"]isEqualToString:STATUS_OK] ) ;
    XCTAssert       (  dictInfoImage3[@"faces"][0][@"face_id"] ) ;
    XCTAssert       (  dictInfoImage3[@"faces"][0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  dictInfoImage3[@"faces"][0][@"rect"][@"bottom"] > dictInfoImage3[@"faces"][0][@"rect"][@"top"]   ) ;
    XCTAssert       (  dictInfoImage3[@"faces"][0][@"rect"][@"left"]   < dictInfoImage3[@"faces"][0][@"rect"][@"right"] ) ;
    XCTAssert       (  [dictInfoImage3[@"faces"][0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [dictInfoImage3[@"faces"][0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [dictInfoImage3[@"faces"][0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [dictInfoImage3[@"faces"][0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    XCTAssert       (  dictInfoImage3[@"image_id"] ) ;
    XCTAssert       (  [dictInfoImage3[@"height"] integerValue]== 450 ) ;
    XCTAssert       (  [dictInfoImage3[@"width"] integerValue]== 365 ) ;
    
}
- (void)test3_Face_verification_personid {
 
    // not value
    float fValue = [self.stApi face_verification_faceid:nil personid:nil];
    XCTAssert( fValue == -1 ) ;
    
    //create person
    STPerson *stPerson = [self.stApi person_create_name:@"test3_Face_verification_personid" faceids:self.strFaceID1 userdata:nil];
    XCTAssertNotNil(stPerson);
    XCTAssertNotNil(stPerson.strPersonID);
    XCTAssertTrue (1 == stPerson.iFaceCount);
    NSDictionary *dictInfoPersonid0 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid0[@"face_ids"] count] == 1) ;
    XCTAssertTrue([dictInfoPersonid0[@"name"] isEqualToString:@"test3_Face_verification_personid"] );
    
    // same
    float fScoreSame = [self.stApi face_verification_faceid:self.strFaceID1 personid:stPerson.strPersonID];
    XCTAssert( fScoreSame > 0.6 ) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    
    
    //different
    float fScoreDiff = [self.stApi face_verification_faceid:self.strFaceID3 personid:stPerson.strPersonID];
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssert( fScoreDiff < 0.6 ) ;
    
    //delete person
    BOOL bDelPerson = [self.stApi person_delete_personid:stPerson.strPersonID];
    XCTAssertTrue( bDelPerson );
}

#pragma mark - face/Person

- (void)test4_Person_function {
    
//    NSLog(@"test4_Person_delete = %@",[self.stApi info_list_persons]);
    
    //clean All exist Persons
    NSDictionary *dictPersons = [self.stApi info_list_persons];
    NSArray *arrPersons = dictPersons[@"persons"];
    if (arrPersons.count > 0) {
        for (int i = 0; i <arrPersons.count; i++) {
            NSString *strPerson_id = arrPersons[i][@"person_id"];
            [self.stApi person_delete_personid:strPerson_id];
        }
    }
    sleep(1);

    //not any value
    STPerson *stPersonTest = [self.stApi person_create_name:nil faceids:nil userdata:nil];
    XCTAssertNil(stPersonTest);
    
    // not name
    STPerson *stPersonNoName = [self.stApi person_create_name:nil faceids:self.strFaceID1 userdata:@"Jay"];
    XCTAssertNil(stPersonNoName);

    
    //1.create person
    STPerson *stPerson = [self.stApi person_create_name:@"test4_Person_function"];
    XCTAssertNotNil(stPerson);
    XCTAssertNotNil(stPerson.strPersonID);
    XCTAssertTrue (0 == stPerson.iFaceCount);
    NSDictionary *dictInfoPersonid0 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid0[@"face_ids"] count] == 0) ;
    XCTAssertTrue([dictInfoPersonid0[@"name"] isEqualToString:@"test4_Person_function"] );
    
    
    //2.1 add one face
    BOOL bAddTest = [self.stApi person_add_face_personid:stPerson.strPersonID faceids:nil];
    XCTAssertFalse (bAddTest);
    
    BOOL bAdd = [self.stApi person_add_face_personid:stPerson.strPersonID faceids:self.strFaceID1];
    XCTAssertTrue (bAdd);
    NSDictionary *dictInfoPersonid1 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid1[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid1[@"face_ids"] count] == 1) ;
    
    
    //2.2 add two face
    NSString *strFaceids = [NSString stringWithFormat:@"%@,%@",self.strFaceID2,self.strFaceID3];
    BOOL bAdd2 = [self.stApi person_add_face_personid:stPerson.strPersonID faceids:strFaceids];
    XCTAssertTrue (bAdd2);
    NSDictionary *dictInfoPersonid2 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid2[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid2[@"face_ids"] count] == 3) ;
    
    sleep(1);
    
    //3. remove face(strFaceID3) in person
    BOOL bRemoveFace = [self.stApi person_remove_face_personid:stPerson.strPersonID faceids:self.strFaceID3];
    XCTAssertTrue( bRemoveFace );
    NSDictionary *dictInfoPersonid3 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid3[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid3[@"face_ids"] count] == 2) ;
    
    //4. change person info
    BOOL bChangeTest = [self.stApi person_change_personid:nil name:nil userdata:nil];
    XCTAssertFalse( bChangeTest );
    
    sleep(1);
    
    BOOL bChange = [self.stApi person_change_personid:stPerson.strPersonID name:@"Jay" userdata:@"test_Jay"];
    XCTAssertTrue( bChange );
    NSDictionary *dictInfoPersonid4 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid4[@"status"] isEqualToString:STATUS_OK] );
    XCTAssertTrue([dictInfoPersonid4[@"name"] isEqualToString:@"Jay"] );
    XCTAssertTrue([dictInfoPersonid4[@"user_data"] isEqualToString:@"test_Jay"] );
    XCTAssert       (  [dictInfoPersonid4[@"face_ids"] count] == 2) ;
    
    //5. delete person
    BOOL bDelPerson = [self.stApi person_delete_personid:stPerson.strPersonID];
    XCTAssertTrue( bDelPerson );
    
}


#pragma mark - face/Group

- (void)test5_Group_function {
    //clean All exist Persons
    NSDictionary *dictPersons = [self.stApi info_list_persons];
    NSArray *arrPersons = dictPersons[@"persons"];
    if (arrPersons.count > 0) {
        for (int i = 0; i <arrPersons.count; i++) {
            NSString *strPerson_id = arrPersons[i][@"person_id"];
            [self.stApi person_delete_personid:strPerson_id];
        }
    }
    sleep(1);
    
//    NSLog(@"test5_Group_function = %@",[self.stApi info_list_groups]);
    //clean All exist Groups
    NSDictionary *dictGroups = [self.stApi info_list_groups];
    NSArray *arr = dictGroups[@"groups"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strGroup_id = arr[i][@"group_id"];
            [self.stApi group_delete_groupid:strGroup_id];
        }
    }
    
    //1. create group(add strFaceID1)
    STGroup *stGroupTest = [self.stApi group_create_groupname:nil personids:nil userdata:nil];
    XCTAssertNil(stGroupTest);

    STGroup *stGroup = [self.stApi group_create_groupname:@"test5_Group_function_Person_Group"];
    XCTAssertNotNil(stGroup);
    XCTAssertNotNil(stGroup.strGroupID);
    XCTAssertTrue (0 == stGroup.iPersonCount);
    NSDictionary *dictInfoGroup1 = [self.stApi info_groupid:stGroup.strGroupID];
    XCTAssertTrue([dictInfoGroup1[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoGroup1[@"persons"] count] == 0) ;
    XCTAssertTrue([dictInfoGroup1[@"name"] isEqualToString:@"test5_Group_function_Person_Group"] );
    
    sleep(1);
    
    //2. add person to group
    //create person
    STPerson *stPerson = [self.stApi person_create_name:@"test5_Group_function_Person" faceids:self.strFaceID1 userdata:nil];
    XCTAssertNotNil(stPerson);
    XCTAssertNotNil(stPerson.strPersonID);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertTrue (1 == stPerson.iFaceCount);
    NSDictionary *dictInfoPerson0 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPerson0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssertTrue([dictInfoPerson0[@"name"] isEqualToString:@"test5_Group_function_Person"] );
    
    //create other person
    STPerson *stPerson2 = [self.stApi person_create_name:@"test5_Group_function_Person2_Group" faceids:self.strFaceID2 userdata:nil];
    XCTAssertNotNil(stPerson2);
    XCTAssertNotNil(stPerson2.strPersonID);
    XCTAssertTrue (1 == stPerson2.iFaceCount);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoPerson1 = [self.stApi info_personid:stPerson2.strPersonID];
    XCTAssertTrue([dictInfoPerson1[@"status"] isEqualToString:STATUS_OK] );
    XCTAssertTrue([dictInfoPerson1[@"name"] isEqualToString:@"test5_Group_function_Person2_Group"] );
    
    NSString *strPersonids = [NSString stringWithFormat:@"%@,%@",stPerson.strPersonID,stPerson2.strPersonID];
    BOOL bAddPerson = [self.stApi group_add_person_groupid:stGroup.strGroupID personids:strPersonids];
    XCTAssertTrue( bAddPerson );
    NSDictionary *dictInfoGroup2 = [self.stApi info_groupid:stGroup.strGroupID];
    XCTAssertTrue([dictInfoGroup2[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoGroup2[@"persons"] count] == 2) ;
    
    sleep(1);
    
    //3. remove person(stPerson2) from group
    BOOL bRemove = [self.stApi group_remove_person_groupid:stGroup.strGroupID personids:stPerson2.strPersonID];
    XCTAssertTrue( bRemove );
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoGroup3 = [self.stApi info_groupid:stGroup.strGroupID];
    XCTAssertTrue([dictInfoGroup3[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoGroup3[@"persons"] count] == 1) ;
    
    //4. change group info
    BOOL bChange = [self.stApi group_change_person_groupid:stGroup.strGroupID name:@"Jay" userdata:@"test_Jay"];
    XCTAssertTrue( bChange );
    NSDictionary *dictInfoGroup4 = [self.stApi info_groupid:stGroup.strGroupID];
    XCTAssertTrue([dictInfoGroup4[@"status"] isEqualToString:STATUS_OK] );
    XCTAssertTrue([dictInfoGroup4[@"name"] isEqualToString:@"Jay"] );
    XCTAssertTrue([dictInfoGroup4[@"user_data"] isEqualToString:@"test_Jay"] );
    XCTAssert       (  [dictInfoGroup4[@"persons"] count] == 1) ;
    
    sleep(2);
    
    //5. delete group
    // delete person
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    BOOL bDelPerson = [self.stApi person_delete_personid:stPerson.strPersonID];
    XCTAssertTrue( bDelPerson );
    BOOL bDelPerson2 = [self.stApi person_delete_personid:stPerson2.strPersonID];
    XCTAssertTrue( bDelPerson2 );
    
    BOOL bDelGroup = [self.stApi group_delete_groupid:stGroup.strGroupID];
    XCTAssertTrue( bDelGroup );
    
}

#pragma mark -   face/FaceSet

- (void)test6_FaceSet_function {
    //clean All exist faceSet
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictFacesets = [self.stApi info_list_facesets];
    NSArray *arr = dictFacesets[@"facesets"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strFaceset_id = arr[i][@"faceset_id"];
            [self.stApi faceset_delete_facesetid:strFaceset_id];
        }
    }
    sleep(1);
    STFaceSet *stFaceSetTest = [self.stApi faceset_create_name:nil faceids:nil userdata:nil];
    XCTAssertNil(stFaceSetTest);

    //1. create faceSet (strFaceID1)
    STFaceSet *stFaceSet = [self.stApi faceset_create_name:@"test6_FaceSet_function"];
    XCTAssertNotNil(stFaceSet);
    XCTAssertNotNil(stFaceSet.strFaceSetID);
    XCTAssertTrue (0 == stFaceSet.iFaceCount);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoFaceSet0 = [self.stApi info_faceset_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue([dictInfoFaceSet0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoFaceSet0[@"face_ids"] count] == 0) ;
    XCTAssertTrue([dictInfoFaceSet0[@"name"] isEqualToString:@"test6_FaceSet_function"] );
    
    NSString *strFaceids = [NSString stringWithFormat:@"%@,%@",self.strFaceID1,self.strFaceID2];
    //2. add faceids(strFaceID2) to faceSet
    BOOL bAddFaceids = [self.stApi faceset_add_face_facesetid:stFaceSet.strFaceSetID faceids:strFaceids];
    XCTAssertTrue( bAddFaceids );
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoFaceSet1 = [self.stApi info_faceset_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue([dictInfoFaceSet1[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoFaceSet1[@"face_ids"] count] == 2) ;
    
    sleep(1);
    
    //3. remove face(strFaceID2) in FaceSet
    BOOL bRemoveFace = [self.stApi faceset_remove_facesetid:stFaceSet.strFaceSetID faceids:self.strFaceID2];
    XCTAssertTrue( bRemoveFace );
    NSDictionary *dictInfoFaceSet2 = [self.stApi info_faceset_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue([dictInfoFaceSet2[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoFaceSet2[@"face_ids"] count] == 1) ;
    
    //4. change faceSet info
    BOOL bChange = [self.stApi faceset_change_facesetid:stFaceSet.strFaceSetID name:@"Jay" userdata:@"test_Jay"];
    XCTAssertTrue( bChange );
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoFaceSet3 = [self.stApi info_faceset_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue([dictInfoFaceSet3[@"status"] isEqualToString:STATUS_OK] );
    XCTAssertTrue([dictInfoFaceSet3[@"name"] isEqualToString:@"Jay"] );
    XCTAssertTrue([dictInfoFaceSet3[@"user_data"] isEqualToString:@"test_Jay"] );
    XCTAssert       (  [dictInfoFaceSet3[@"face_ids"] count] == 1) ;
    
    //5. delete faceSet
    BOOL bDelFaceSet = [self.stApi faceset_delete_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue( bDelFaceSet );
}

#pragma mark -   face/search
//      /face/search	在众多人脸中搜索出与目标人脸最为相似的一张或者多张人脸
- (void)test6_Facesetids_search {
    //clean All exist faceSet
    NSDictionary *dictFaceset = [self.stApi info_list_facesets];
    NSArray *arr = dictFaceset[@"facesets"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strFaceset_id = arr[i][@"faceset_id"];
            [self.stApi faceset_delete_facesetid:strFaceset_id];
        }
    }
    sleep(1);

    NSString *strFaceids = [NSString stringWithFormat:@"%@,%@",self.strFaceID2,self.strFaceID3];
    //create FaceSet
    STFaceSet *stFaceSet = [self.stApi faceset_create_name:@"test6_Facesetids_search" faceids:strFaceids userdata:nil];
    XCTAssertNotNil(stFaceSet);
    XCTAssertTrue(stFaceSet.iFaceCount == 2);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoFaceSet = [self.stApi info_faceset_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue([dictInfoFaceSet[@"status"] isEqualToString:STATUS_OK] );
    XCTAssertTrue([dictInfoFaceSet[@"name"] isEqualToString:@"test6_Facesetids_search"] );
    
    // search
    NSDictionary *dict = [self.stApi face_search_faceid:self.strFaceID1 facesetid:stFaceSet.strFaceSetID topnum:1];
    XCTAssertNotNil(dict);
 
    //delete Faceset
    BOOL bDelFaceSet = [self.stApi faceset_delete_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue(bDelFaceSet);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
 
}

- (void)test6_Faceids_search {
    //clean All exist faceSet
    NSDictionary *dictFaceset = [self.stApi info_list_facesets];
    NSArray *arr = dictFaceset[@"facesets"];
        if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strFaceset_id = arr[i][@"faceset_id"];
            [self.stApi faceset_delete_facesetid:strFaceset_id];
        }
    }
    
    NSString *strFaceids = [NSString stringWithFormat:@"%@,%@",self.strFaceID2,self.strFaceID3];
    
    // search
    NSDictionary *dict = [self.stApi face_search_faceid:self.strFaceID1 faceids:strFaceids topnum:1];
    XCTAssertNotNil(dict);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
}
 
#pragma mark - face/identification
//    /face/identification	将一个目标人脸与某个组中的所有人进行对比，找出几个与该人脸最相似的人
- (void)test7_Idenfitication {
    //clean All exist Persons
    NSDictionary *dictPersons = [self.stApi info_list_persons];
    NSArray *arrPersons = dictPersons[@"persons"];
    if (arrPersons.count > 0) {
        for (int i = 0; i <arrPersons.count; i++) {
            NSString *strPerson_id = arrPersons[i][@"person_id"];
            [self.stApi person_delete_personid:strPerson_id];
        }
    }
    
    //clean All info_list_groups
    NSDictionary *dictGroups = [self.stApi info_list_groups];
    NSArray *arr = dictGroups[@"groups"];
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strGroup_id = arr[i][@"group_id"];
            [self.stApi group_delete_groupid:strGroup_id];
        }
    }
    
    NSString *strFaceids = [NSString stringWithFormat:@"%@,%@",self.strFaceID1,self.strFaceID2];
    
    sleep(1);
    
    //create Person
    STPerson *stPerson = [self.stApi person_create_name:@"test7_Idenfitication_Person" faceids:strFaceids userdata:nil];
    XCTAssertNotNil(stPerson);
    XCTAssertNotNil(stPerson.strPersonID);
    XCTAssertTrue (2 == stPerson.iFaceCount);
    XCTAssert( [self.stApi.status isEqualToString:STATUS_OK]) ;
    NSDictionary *dictInfoPersonid0 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid0[@"face_ids"] count] == 2) ;
    
    // create group
    STGroup *stGroup = [self.stApi group_create_groupname:@"test7_Idenfitication_Group" personids:stPerson.strPersonID userdata:nil];
    XCTAssertNotNil(stGroup);
    XCTAssert   ( stGroup.iPersonCount == 1);
    
    
    //similar
    NSDictionary *dictIndenfity1 = [self.stApi face_identification_faceid:self.strFaceID1 groupid:stGroup.strGroupID topnum:1];
    XCTAssertNotNil(dictIndenfity1);
    XCTAssertNotNil(dictIndenfity1[@"group_id"]);
    XCTAssertTrue([dictIndenfity1[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert ([dictIndenfity1[@"candidates"] count] == 1);
    XCTAssert ([dictIndenfity1[@"candidates"][0][@"confidence"] integerValue]== 1);

    //un similar
    NSDictionary *dictIndenfity2 = [self.stApi face_identification_faceid:self.strFaceID3 groupid:stGroup.strGroupID topnum:1];
    XCTAssertNotNil(dictIndenfity2);
    XCTAssertNotNil(dictIndenfity2[@"group_id"]);
    XCTAssertTrue([dictIndenfity2[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert ([dictIndenfity2[@"candidates"] count] == 0);
    
    
    //delete person
    BOOL bDelPerson = [self.stApi person_delete_personid:stPerson.strPersonID];
    XCTAssertTrue( bDelPerson);
    //delete group
    BOOL bDelGroup = [self.stApi group_delete_groupid:stGroup.strGroupID];
    XCTAssertTrue( bDelGroup);
    
}

#pragma makr - /face/training
//    /face/training	可以对人脸、人、人脸集合、组进行训练，提取其中的人脸信息
- (void)test8_Training {
    //clean All exist Persons
    NSDictionary *dictPersons = [self.stApi info_list_persons];
    NSArray *arrPersons = dictPersons[@"persons"];
    if (arrPersons.count > 0) {
        for (int i = 0; i <arrPersons.count; i++) {
            NSString *strPerson_id = arrPersons[i][@"person_id"];
            [self.stApi person_delete_personid:strPerson_id];
        }
    }

    //clean All exist Groups
    NSDictionary *dictGroups = [self.stApi info_list_groups];
    NSArray *arrGroups = dictGroups[@"groups"];
    if (arrGroups.count > 0) {
        for (int i = 0; i <arrGroups.count; i++) {
            NSString *strGroup_id = arrGroups[i][@"group_id"];
            [self.stApi group_delete_groupid:strGroup_id];
        }
        
    }
    
    //clean All exist Facesets
    NSDictionary *dictFaceset = [self.stApi info_list_facesets];
    NSArray *arrFaceset = dictFaceset[@"facesets"];
    
    if (arrFaceset.count > 0) {
        for (int i = 0; i <arrFaceset.count; i++) {
            NSString *strFaceset_id = arrFaceset[i][@"faceset_id"];
            [self.stApi faceset_delete_facesetid:strFaceset_id];
        }
    }
    
    sleep(1);
    
    //create Person
    STPerson *stPerson = [self.stApi person_create_name:@"test8_Training_Person" faceids:self.strFaceID2 userdata:nil];
    XCTAssertNotNil(stPerson);
    XCTAssertNotNil(stPerson.strPersonID);
    XCTAssertTrue (1 == stPerson.iFaceCount);
    NSDictionary *dictInfoPersonid0 = [self.stApi info_personid:stPerson.strPersonID];
    XCTAssertTrue([dictInfoPersonid0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoPersonid0[@"face_ids"] count] == 1) ;
    
    //create group
    STGroup *stGroup = [self.stApi group_create_groupname:@"test8_Training_Group" personids:stPerson.strPersonID userdata:nil];
    XCTAssertNotNil(stGroup);
    XCTAssertNotNil(stGroup.strGroupID);
    XCTAssertTrue (1 == stGroup.iPersonCount);
    NSDictionary *dictInfoGroup1 = [self.stApi info_groupid:stGroup.strGroupID];
    XCTAssertTrue([dictInfoGroup1[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoGroup1[@"persons"] count] == 1) ;
    
    //create faceSet
    STFaceSet *stFaceSet = [self.stApi faceset_create_name:@"test8_Training_FaceSet" faceids:self.strFaceID3 userdata:nil];
    XCTAssertNotNil(stFaceSet);
    XCTAssertNotNil(stFaceSet.strFaceSetID);
    XCTAssertTrue (1 == stFaceSet.iFaceCount);
    NSDictionary *dictInfoFaceSet0 = [self.stApi info_faceset_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue([dictInfoFaceSet0[@"status"] isEqualToString:STATUS_OK] );
    XCTAssert       (  [dictInfoFaceSet0[@"face_ids"] count] == 1) ;
    
    BOOL bTrainNoValue = [self.stApi face_training_faceids:nil personids:nil facesetids:nil groupids:nil];
    XCTAssertFalse(bTrainNoValue);
    
    BOOL bTrain1 = [self.stApi face_training_faceids:self.strFaceID1];
    XCTAssertTrue(bTrain1);
    
    BOOL bTrain2 = [self.stApi face_training_personids:stPerson.strPersonID];
    XCTAssertTrue(bTrain2);
    
    BOOL bTrain3 = [self.stApi face_training_facesetids:stFaceSet.strFaceSetID];
    XCTAssertTrue(bTrain3);
    
    BOOL bTrain4 = [self.stApi face_training_groupids:stGroup.strGroupID];
    XCTAssertTrue(bTrain4);
    
    sleep(1);
    BOOL bTrain5 = [self.stApi face_training_faceids:self.strFaceID1 personids:stPerson.strPersonID facesetids:stFaceSet.strFaceSetID groupids:stGroup.strGroupID];
    XCTAssertTrue(bTrain5);

    //delete faceSet
    BOOL bDelFaceSet = [self.stApi faceset_delete_facesetid:stFaceSet.strFaceSetID];
    XCTAssertTrue( bDelFaceSet );
    //delete person
    BOOL bDelPerson = [self.stApi person_delete_personid:stPerson.strPersonID];
    XCTAssertTrue( bDelPerson);
    //delete group
    BOOL bDelGroup = [self.stApi group_delete_groupid:stGroup.strGroupID];
    XCTAssertTrue( bDelGroup);
}
//    /face/grouping	将一堆人脸根据其之间的相似度进行分类，同一个人的人脸为一类


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
