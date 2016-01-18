//
//  FaceSearchViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 16/1/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "FaceSearchViewController.h"

#import "STAPI.h"
#import "STImage.h"
#import "STFaceSet.h"
#import "STCommon.h"
#import "ImageFace.h"

#import "MyAPIKey.h"
//#error define my API key as following :
//#define MyApiID 		@"***********************"
//#define MyApiSecret 	@"***********************"

@interface FaceSearchViewController ()
{
    BOOL _bBusy;

    NSString *_strIds;
    NSMutableArray *_arrFaces;
    UIImageView *_imageFaceSet;
    UIImageView *_imageFace;
    UIActivityIndicatorView *_indicator;
}
@property (nonatomic, strong) UIButton *btnStart;
@end

@implementation FaceSearchViewController

#pragma mark
#pragma mark memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.strTitle;
    _bBusy = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    _arrFaces = [[NSMutableArray alloc] init];
    _imageFaceSet = [[UIImageView alloc] init];
    _imageFaceSet.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _imageFaceSet.image = [UIImage imageNamed:@"face_set.jpg"];
    _imageFaceSet.contentMode = UIViewContentModeScaleAspectFit;
    _imageFaceSet.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageFaceSet];
    
    _imageFace = [[UIImageView alloc] init];
    _imageFace.frame = CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-120, 120, 120);
    _imageFace.image = [UIImage imageNamed:@"face_liu.jpg"];
    _imageFace.contentMode = UIViewContentModeScaleAspectFit;
    _imageFace.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageFace];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-90, 80, 80);
    btnStart.alpha = 0.5;
    btnStart.backgroundColor = [UIColor blueColor];
    btnStart.layer.cornerRadius = 40;
    btnStart.layer.borderWidth = 8;
    btnStart.titleLabel.font = [UIFont systemFontOfSize:18];
    btnStart.layer.borderColor = [UIColor whiteColor].CGColor;
    [btnStart setTitle:@"开始" forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(onSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStart];
    self.btnStart = btnStart;
    
    _indicator = [[UIActivityIndicatorView alloc] init];
//    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 50, 50);
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
}

-(void)onSearch
{
    if (_bBusy) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在检测!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
        [alert show] ;
        return;
    }
    _bBusy = YES;
    
    [_indicator startAnimating];
    
    STAPI *myApi = [[STAPI alloc] init ] ;
    myApi.bDebug = YES ;
    
    [myApi start_apiid:MyApiID apisecret:MyApiSecret] ;
    if ( myApi.error )
    {
        NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
              myApi.status,
              myApi.httpStatusCode,
              [myApi.error description]);
        
        _bBusy = NO;
        [_indicator stopAnimating];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        //sets
        UIImage *imageFaceSet = [UIImage imageNamed:@"face_set.jpg"] ;
        STImage *stImage = [myApi face_detection_image:imageFaceSet] ;
        
        //face
        UIImage *imageFace = [UIImage imageNamed:@"face_liu.jpg"] ;
        STImage *stImageLiu = [myApi face_detection_image:imageFace] ;
   
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (myApi.error)
            {
                NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                      myApi.status,
                      myApi.httpStatusCode,
                      [myApi.error description]);
            }
            else
            {
                if ([myApi.status isEqualToString:STATUS_OK] && stImage.arrFaces.count > 0
                    && stImageLiu.arrFaces.count > 0)
                {
                    //get imageFaceSet
                    for (int i=0; i<stImage.arrFaces.count; i++)
                    {
                        ImageFace *face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:i] landmarksType:21];
                        [_arrFaces addObject:face];
                        
                        if (!_strIds)
                        {
                            _strIds = face.strFaceID;
                        }
                        else
                        {
                            _strIds = [_strIds stringByAppendingString:[NSString stringWithFormat:@",%@",face.strFaceID]];
                        }
                    }
                    //clean All exist faceSet
                    NSDictionary *dictFacesets = [myApi info_list_facesets];
                    NSArray *arr = dictFacesets[@"facesets"];
                    
                    if (arr.count > 0) {
                        for (int i = 0; i <arr.count; i++) {
                            NSString *strFaceset_id = arr[i][@"faceset_id"];
                            [myApi faceset_delete_facesetid:strFaceset_id];
                        }
                    }

                    STFaceSet *faceSet = [myApi faceset_create_name:@"123" faceids:_strIds userdata:@"test"];
                    //[myApi faceset_delete_facesetid:faceSet.strFaceSetID];
                    
                    if (!faceSet.strFaceSetID)
                    {
                        NSString *strMessage = [NSString stringWithFormat:@"%@\n%@", myApi.status, myApi.dictionary] ;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                        [alert show] ;

                        _bBusy = NO;
                        [_indicator stopAnimating];
                        return;
                    }
                    
                    //get face id
                    NSString *strFaceID = stImageLiu.arrFaces[0][@"face_id"] ;
                    
                    NSDictionary *resultDic = [[NSDictionary alloc] init];
                    resultDic = [myApi face_search_faceid:strFaceID facesetid:faceSet.strFaceSetID topnum:3];
                    
                    NSMutableArray *arrHightCandidates = [[NSMutableArray alloc] init];
                    NSMutableArray *arrCandidates = [resultDic objectForKey:@"candidates"];
                    for (int i=0; i<arrCandidates.count; i++)
                    {
                        float confidence = [[[arrCandidates objectAtIndex:i] objectForKey:@"confidence"] floatValue];
                        if (confidence > 0.6)
                        {
                            NSString *strFaceId = [[arrCandidates objectAtIndex:i] objectForKey:@"face_id"];
                            [arrHightCandidates addObject:strFaceId];
                        }
                    }
                    
                    //find out who confidence > 0.6
                    if (arrHightCandidates.count > 0)
                    {
                        NSString *strFaceId;
                        for (int i=0; i<arrHightCandidates.count; i++)
                        {
                            strFaceId = [arrHightCandidates objectAtIndex:i];
                            for (int i=0; i<_arrFaces.count; i++)
                            {
                                ImageFace *face = [_arrFaces objectAtIndex:i];
                                if ([face.strFaceID isEqualToString:strFaceId])
                                {
                                    //draw rect
                                    float fWidth = face.right - face.left;
                                    CGRect rectFace = CGRectMake(face.left, face.top, fWidth, fWidth) ;
                                    CGSize size = CGSizeMake(stImage.iWidth, stImage.iHeidth);
                                    UIGraphicsBeginImageContext(size);
                                    [_imageFaceSet.image drawInRect:CGRectMake(0, 0, _imageFaceSet.image.size.width, _imageFaceSet.image.size.height)];
                                    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
                                    CGContextAddRect(UIGraphicsGetCurrentContext(), rectFace) ;
                                    for (int j = 0; j < 21; j ++)
                                    {
                                        FaceDot *dot = [face.arrPoints objectAtIndex:j];
                                        CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake( dot.x , dot.y , 1, 1));
                                    }
                                    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
                                    CGContextStrokePath(UIGraphicsGetCurrentContext());
                                    _imageFaceSet.image = UIGraphicsGetImageFromCurrentImageContext();
                                    _imageFaceSet.frame = CGRectMake(0, 0, _imageFaceSet.frame.size.width, _imageFaceSet.frame.size.height);
                                    UIGraphicsEndImageContext();
                                }
                            }
                        }
                    }
                    
                    _bBusy = NO;
                    [_indicator stopAnimating] ;
                }
            }
        });
    } );
}

#pragma mark -
#pragma mark Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) )
    {
        _imageFaceSet.frame = CGRectMake(0, 0, size.width, size.height);
        _indicator.frame = CGRectMake(size.width/2-15, size.height/2-15, 50, 50);
        self.btnStart.frame = CGRectMake(size.width/2-40, size.height-90, 80, 80);
        _imageFace.frame = CGRectMake(size.width-120, size.height-120, 120, 120);

    }
}

@end
