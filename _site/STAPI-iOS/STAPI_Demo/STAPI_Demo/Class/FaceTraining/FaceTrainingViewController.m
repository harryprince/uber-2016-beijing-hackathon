//
//  FaceTrainingViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 16/1/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "FaceTrainingViewController.h"

#import "STAPI.h"
#import "STImage.h"
#import "STPerson.h"
#import "STFaceSet.h"
#import "STGroup.h"
#import "MyAPIKey.h"
#import "STCommon.h"
#import "ImageFace.h"

@interface FaceTrainingViewController ()
{
    BOOL _bBusy;

    UIImageView *_imageFaceSet;
    UIButton *_btnStart;
    UIActivityIndicatorView *_indicator;
}

@property (nonatomic, strong) STAPI *myAPI;
@end

@implementation FaceTrainingViewController

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
    
    self.myAPI = [[STAPI alloc] init ] ;
    self.myAPI.bDebug = NO ;
    [self.myAPI start_apiid:MyApiID apisecret:MyApiSecret] ;
    
    _imageFaceSet = [[UIImageView alloc] init];
    _imageFaceSet.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _imageFaceSet.image = [UIImage imageNamed:@"face_set.jpg"];
    _imageFaceSet.contentMode = UIViewContentModeScaleAspectFit;
    _imageFaceSet.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageFaceSet];
    
    _btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStart.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-90, 80, 80);
    _btnStart.alpha = 0.5;
    _btnStart.backgroundColor = [UIColor blueColor];
    _btnStart.layer.cornerRadius = 40;
    _btnStart.layer.borderWidth = 8;
    _btnStart.titleLabel.font = [UIFont systemFontOfSize:18];
    _btnStart.layer.borderColor = [UIColor whiteColor].CGColor;
    [_btnStart setTitle:@"开始" forState:UIControlStateNormal];
    [_btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStart addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStart];
    
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.frame = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50);
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
}


#pragma mark
#pragma mark button event

- (void)onStart
{
    if (_bBusy) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在检测！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
        [alert show] ;
        return;
    }
    _bBusy = YES;
    
    [_indicator startAnimating];
    
    if ( self.myAPI.error )
    {
        NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
              self.myAPI.status,
              self.myAPI.httpStatusCode,
              [self.myAPI.error description]);
        _bBusy = NO;
        [_indicator stopAnimating];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        STImage *stImage = [self.myAPI face_detection_image:_imageFaceSet.image] ;
        
        //clean sets: if more than 5 sets creation will be failed
        NSDictionary *dictSets = [self.myAPI info_list_facesets];
        NSArray *arrSets = dictSets[@"facesets"];
        if (arrSets.count > 0)
        {
            for (int i = 0; i <arrSets.count; i++)
            {
                NSString *strSet_id = arrSets[i][@"faceset_id"];
                [self.myAPI faceset_delete_facesetid:strSet_id];
            }
        }
        
        //clean groups: if more than 3 groups creation will be failed
        NSDictionary *dictGroups = [self.myAPI info_list_groups];
        NSArray *arrGroups = dictGroups[@"groups"];
        if (arrGroups.count > 0)
        {
            for (int i = 0; i <arrGroups.count; i++)
            {
                NSString *strGroup_id = arrGroups[i][@"group_id"];
                [self.myAPI group_delete_groupid:strGroup_id];
            }
        }

        //clean All exist Persons
        NSDictionary *dictPersons = [self.myAPI info_list_persons];
        NSArray *arrPersons = dictPersons[@"persons"];
        if (arrPersons.count > 0) {
            for (int i = 0; i <arrPersons.count; i++) {
                NSString *strPerson_id = arrPersons[i][@"person_id"];
                [self.myAPI person_delete_personid:strPerson_id];
            }
        }
        sleep(1);
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog(@"tag =         status(%@)",self.myAPI.status);

            if (self.myAPI.error)
            {
                NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                      self.myAPI.status,
                      self.myAPI.httpStatusCode,
                      [self.myAPI.error description]);
            }
            else
            {
                if ([self.myAPI.status isEqualToString:STATUS_OK] &&
                    stImage.arrFaces.count > 0)
                {
                    //all kind of ids will be send into training interface
                    NSString *strIds, *strSetIds, *strPersonIds, *strGroupIds;

                    for (int i=0; i<stImage.arrFaces.count; i++)
                    {
                        //faceIds
                        ImageFace *face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:i] landmarksType:21];
                        
                        if (!strIds)
                        {
                            strIds = face.strFaceID;
                        }
                        else
                        {
                            strIds = [strIds stringByAppendingString:[NSString stringWithFormat:@",%@",face.strFaceID]];
                        }

                        //setIds
                        STFaceSet *set = [self.myAPI faceset_create_name:[NSString stringWithFormat:@"set%d",i] faceids:face.strFaceID userdata:@"set"];
                        if (set && set.strFaceSetID && set.iFaceCount >0)
                        {
                            if (!strSetIds)
                            {
                                strSetIds = set.strFaceSetID;
                            }
                            else
                            {
                                strSetIds = [strSetIds stringByAppendingString:[NSString stringWithFormat:@",%@",set.strFaceSetID]];
                            }
                        }

                        //personIds
                        STPerson *person = [self.myAPI person_create_name:[NSString stringWithFormat:@"person%d",i] faceids:face.strFaceID userdata:@"person"];
                        if (person && person.strPersonID && person.iFaceCount > 0)
                        {
                            if (!strPersonIds)
                            {
                                strPersonIds = person.strPersonID;
                            }
                            else
                            {
                                strPersonIds = [strPersonIds stringByAppendingString:[NSString stringWithFormat:@",%@",person.strPersonID]];
                            }
                        }
                        
                        //groupIds
                        STGroup *group = [self.myAPI group_create_groupname:[NSString stringWithFormat:@"group%d",i] personids:person.strPersonID userdata:@"group"];
                        if (group && group.strGroupID && group.iPersonCount > 0)
                        {
                            if (!strGroupIds)
                            {
                                strGroupIds = group.strGroupID;
                            }
                            else
                            {
                                strGroupIds = [strGroupIds stringByAppendingString:[NSString stringWithFormat:@",%@",group.strGroupID]];
                            }
                        }
                    }
                    
                    sleep(1);
                    
                    //training
                    if (strIds && strSetIds && strPersonIds && strGroupIds)
                    {
                        BOOL bTraining = [self.myAPI face_training_faceids:strIds personids:strPersonIds facesetids:strSetIds groupids:strGroupIds];
                        
                        if (bTraining)
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"训练成功"
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"训练失败"
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                    else if (!strIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"图片错误"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if (!strSetIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建set失败"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if (!strPersonIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建person失败"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if (!strGroupIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建组失败"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    _bBusy = NO;
                    [_indicator stopAnimating];
                }else {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error"
                                                                   message:[self.myAPI.status debugDescription]
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                    [alert show];
                    
                    _bBusy = NO;
                    [_indicator stopAnimating];

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
        _imageFaceSet.frame = CGRectMake(0, 0, size.width,size.height);
        _btnStart.frame = CGRectMake(size.width/2-40, size.height-90, 80, 80);
        _indicator.frame = CGRectMake(size.width/2-25, size.height/2-25, 50, 50);
        
    }
}

@end
