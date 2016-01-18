//
//  FaceIdentifiViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 16/1/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "FaceIdentifiViewController.h"

#import "STAPI.h"
#import "STImage.h"
#import "STPerson.h"
#import "STGroup.h"
#import "STCommon.h"
#import "MyAPIKey.h"
#import "ImageFace.h"

@interface FaceIdentifiViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage *_photoImage;
    UIButton *_btnPhoto;
    UILabel *_lbName;
    UIImageView *_personsImageView;
    UIActivityIndicatorView *_indicator;
    UIImagePickerController *_photoPicker;
}
@end

@implementation FaceIdentifiViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPhoto.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-200, 400, 400);
    [_btnPhoto addTarget:self action:@selector(onPhoto) forControlEvents:UIControlEventTouchUpInside];
    _btnPhoto.backgroundColor = [UIColor whiteColor];
    _btnPhoto.layer.borderWidth = 1;
    _btnPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [_btnPhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [_btnPhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_btnPhoto];
    
    _lbName = [[UILabel alloc] init];
    _lbName.hidden = YES;
    _lbName.backgroundColor = [UIColor blackColor];
    _lbName.frame = CGRectMake(0, 0, _btnPhoto.frame.size.width, 30);
    _lbName.font = [UIFont systemFontOfSize:12];
    _lbName.textAlignment = NSTextAlignmentCenter;
    [_btnPhoto addSubview:_lbName];

    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.frame = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50);
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    
    [self initCamera];
}

#pragma mark
#pragma mark init camera

- (void)initCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    _photoPicker = [[UIImagePickerController alloc] init];
    _photoPicker.delegate = self;
    _photoPicker.allowsEditing = NO;
    _photoPicker.sourceType = sourceType;
}

#pragma mark
#pragma mark button event

- (void)onPhoto
{
    [self presentViewController:_photoPicker animated:YES completion:nil];
}

#pragma mark
#pragma mark pickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _lbName.hidden = YES;
    
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _photoImage = photoImage;
    [_btnPhoto setImage:photoImage forState:UIControlStateNormal];
    [_photoPicker dismissViewControllerAnimated:YES completion:nil];
    
    //start Identify
    [self startIdentify];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_photoPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark Identify

- (void)startIdentify
{
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
        
        [_indicator stopAnimating];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        STImage *stImage = [myApi face_detection_image:_photoImage] ;
        
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
                if ([myApi.status isEqualToString:STATUS_OK] &&
                    stImage.arrFaces.count > 0)
                {
                    //the photoImage must be one face
                    ImageFace *face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:0] landmarksType:21];
                    
                    //start identify
                    NSDictionary *dicResult = [myApi face_identification_faceid:face.strFaceID groupid:self.strGroupId topnum:1];
                    
                    if (!dicResult)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                       message:@"验证失败"
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                        
                        _lbName.text = @"验证失败";
                        _lbName.textColor = [UIColor redColor];
                    }
                    else
                    {
                        NSMutableArray *arrCandidates = [dicResult objectForKey:@"candidates"];
                        
                        if (!arrCandidates.count) {
                            _lbName.text = @"mismatching";
                            _lbName.textColor = [UIColor redColor];
                            
                        }else {
                            for (int i=0; i<arrCandidates.count; i++)
                            {
                                float confidence = [[[arrCandidates objectAtIndex:i] objectForKey:@"confidence"] floatValue];
                                if (confidence > 0.6)
                                {
                                    NSString *strName = [[arrCandidates objectAtIndex:i] objectForKey:@"name"];
                                    _lbName.text = strName;
                                    _lbName.textColor = [UIColor greenColor];
                                }
                            }
                        }
                        
                    }
                    
                    _lbName.hidden = NO;
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
        _btnPhoto.frame = CGRectMake(size.width/2-200, size.height/2-200, 400, 400);
        _indicator.frame = CGRectMake(size.width/2-25, size.height/2-25, 50, 50);
        
    }
}

@end
