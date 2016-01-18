//
//  FaceDetectionViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 12/29/15.
//  Copyright © 2015 SenseTime. All rights reserved.
//

#import "FaceDetectionViewController.h"
#import "STAPI.h"
#import "STImage.h"
#import "STCommon.h"
#import "ImageFace.h"

#import "MyAPIKey.h"
//#error define my API key as following :
//#define MyApiID 		@"***********************"
//#define MyApiSecret 	@"***********************"

@interface FaceDetectionViewController () {
    BOOL _bBusy;
}

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableArray *arrFaces;
@property (strong, nonatomic) UIImageView *faceView;
@property (strong, nonatomic) UIButton *btnStart;

@property (nonatomic, strong) UILabel  *labelAttr;

@end

@implementation FaceDetectionViewController

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
    
    _bBusy = NO;
    self.arrFaces = [[NSMutableArray alloc] init];
    
    self.faceView = [[UIImageView alloc] init];
    self.faceView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.faceView.contentMode = UIViewContentModeScaleAspectFit;
    self.faceView.image = [UIImage imageNamed:@"face.jpg"];
    self.faceView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.faceView];
    
    self.btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnStart.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-90, 80, 80);
    self.btnStart.alpha = 0.5;
    self.btnStart.backgroundColor = [UIColor blueColor];
    self.btnStart.layer.cornerRadius = 40;
    self.btnStart.layer.borderWidth = 8;
    self.btnStart.titleLabel.font = [UIFont systemFontOfSize:18];
    self.btnStart.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnStart setTitle:@"21点" forState:UIControlStateNormal];
    [self.btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnStart addTarget:self action:@selector(onDetect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnStart];
    
    self.indicator = [[UIActivityIndicatorView alloc] init];
    self.indicator.backgroundColor = [UIColor clearColor];
    self.indicator.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 50, 50);
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.indicator];
    
    
    //
    self.labelAttr = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, 20, 200)];
    [self.view addSubview:self.labelAttr];

}

#pragma mark
#pragma mark button event

- (void)onDetect
{
 
    if (_bBusy) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在检测！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
        [alert show] ;
        return;
    }
    _bBusy = YES;
    
    [self.indicator startAnimating] ;
    
    STAPI *mySTApi = [[STAPI alloc] init ] ;
    mySTApi.bDebug = YES ;
    
    [mySTApi start_apiid:MyApiID apisecret:MyApiSecret] ;
    
    if ( mySTApi.error )
    { // ![mySTApi.status isEqualToString:STATUS_OK]
        
        NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
              mySTApi.status,
              mySTApi.httpStatusCode,
              [mySTApi.error description]);
        
        NSString *strMessage = [NSString stringWithFormat:@"%@\n%@", mySTApi.status, mySTApi.dictionary] ;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
        [alert show] ;

        _bBusy = NO;
        [self.indicator stopAnimating];
        return;
        
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        UIImage *imageFace = [UIImage imageNamed:@"face.jpg"] ;
        
        ///
        STImage *imageFaceTest = [mySTApi face_detection_image:imageFace landmarks106:NO attributes:YES auto_rotate:YES user_data:nil];
        imageFaceTest.dictFull;
        NSLog(@"imageFaceTest =  %@", imageFaceTest[@"faces"]);
        
        
        STImage *stImage;
        if ([self.btnStart.titleLabel.text isEqualToString:@"21点"])
        {//21
            stImage = [mySTApi face_detection_image:imageFace] ;
        }
        else
        {//106
            stImage = [mySTApi face_detection_image:imageFace
                                       landmarks106:YES
                                         attributes:NO
                                        auto_rotate:YES
                                          user_data:nil] ;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
//            self.labelAttr.text = imageFaceTest[@"faces"];
            if (mySTApi.error)
            {
                NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                      mySTApi.status,
                      mySTApi.httpStatusCode,
                      [mySTApi.error description]);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[mySTApi.error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                [alert show] ;
                
            }
            else
            {
                if ([mySTApi.status isEqualToString:STATUS_OK] && stImage.arrFaces.count > 0)
                {
                    //clean cache
                    [self.arrFaces removeAllObjects];
                    [self.faceView removeFromSuperview];
                    self.faceView = [[UIImageView alloc] init];
                    self.faceView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    self.faceView.contentMode = UIViewContentModeScaleAspectFit;
                    self.faceView.image = [UIImage imageNamed:@"face.jpg"];
                    self.faceView.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:self.faceView];
                    [self.view bringSubviewToFront:self.indicator];
                    
                    //draw faces
                    for (int i=0; i<stImage.arrFaces.count; i++)
                    {
                        ImageFace *face;
                        if ([self.btnStart.titleLabel.text isEqualToString:@"21点"])
                        {
                            face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:i] landmarksType:21];
                        }
                        else
                        {
                            face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:i] landmarksType:106];
                        }
                        
                        [self.arrFaces addObject:face];
                    }
                    
                    for (int i=0; i<self.arrFaces.count; i++)
                    {
                        ImageFace *face = [self.arrFaces objectAtIndex:i];
                        
                        float fWidth = face.right - face.left;
                        
                        CGRect rectFace = CGRectMake(face.left, face.top, fWidth, fWidth) ;
                        CGSize size = CGSizeMake(stImage.iWidth, stImage.iHeidth);
                        UIGraphicsBeginImageContext(size);
                        [self.faceView.image drawInRect:CGRectMake(0, 0, self.faceView.image.size.width, self.faceView.image.size.height)];
                        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
                        CGContextAddRect(UIGraphicsGetCurrentContext(), rectFace) ;
                        if ([self.btnStart.titleLabel.text isEqualToString:@"21点"])
                        {
                            for (int j = 0; j < 21; j ++)
                            {
                                FaceDot *dot = [face.arrPoints objectAtIndex:j];
                                CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake( dot.x , dot.y , 1, 1));
                            }
                        }
                        else
                        {
                            for (int j = 0; j < 106; j ++)
                            {
                                FaceDot *dot = [face.arrPoints objectAtIndex:j];
                                CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake( dot.x , dot.y , 1, 1));
                            }
                        }
                        
                        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
                        CGContextStrokePath(UIGraphicsGetCurrentContext());
                        self.faceView.image = UIGraphicsGetImageFromCurrentImageContext();
                        self.faceView.frame = CGRectMake(0, 0, self.faceView.frame.size.width, self.faceView.frame.size.height);
                        UIGraphicsEndImageContext();
                    }
                    _bBusy = NO;
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"没有检测到脸！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                    [alert show] ;
                    _bBusy = NO;
                }
            }
            
            if ([self.btnStart.titleLabel.text isEqualToString:@"21点"])
            {
                [self.btnStart setTitle:@"106点" forState:UIControlStateNormal];
            }
            else
            {
                [self.btnStart setTitle:@"21点" forState:UIControlStateNormal];
            }
            
            _bBusy = NO;
            [self.indicator stopAnimating] ;
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
        self.faceView.frame = CGRectMake(0, 0, size.width, size.height);
        self.btnStart.frame = CGRectMake(size.width/2-40, size.height-90, 80, 80);
    }
}

@end
