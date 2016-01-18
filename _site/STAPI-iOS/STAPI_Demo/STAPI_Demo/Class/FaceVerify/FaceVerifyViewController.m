//
//  FaceVerifyViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 15/12/31.
//  Copyright © 2015年 SenseTime. All rights reserved.
//

#import "FaceVerifyViewController.h"

#import "STAPI.h"
#import "STImage.h"

#import "MyAPIKey.h"       
//#error define my API key as following :
//#define MyApiID 		@"***********************"
//#define MyApiSecret 	@"***********************"

@interface FaceVerifyViewController () {
    BOOL _bBusy;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FaceVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.strTitle;

    _bBusy = NO;
}
- (IBAction)onVerify:(id)sender {
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
    
    
    if ( mySTApi.error ) { // ![mySTApi.status isEqualToString:STATUS_OK]
        
        self.textView.text = [NSString stringWithFormat:@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                              mySTApi.status,
                              mySTApi.httpStatusCode,
                              [mySTApi.error description] ];
        _bBusy = NO;
        [self.indicator stopAnimating];
        return;
        
    }

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        STImage *stImage1 = [mySTApi face_detection_image: self.imageView1.image ];
        STImage *stImage2 = [mySTApi face_detection_image: self.imageView2.image ];


        dispatch_sync(dispatch_get_main_queue(), ^{
            if (mySTApi.error) {
                self.textView.text = [NSString stringWithFormat:@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                                      mySTApi.status,
                                      mySTApi.httpStatusCode,
                                      [mySTApi.error description] ];
                _bBusy = NO;
                [self.indicator stopAnimating] ;
                
            }else{
                float fScoreSame = [mySTApi face_verification_faceid:stImage1.arrFaces[0][@"face_id"] face2id:stImage2.arrFaces[0][@"face_id"]] ;
                
                // fScoreSame  分值越大 说明两图片 内容(人) 相似度越大
                NSLog(@"fScoreSame = %f  ", fScoreSame);

                self.textView.text = [NSString stringWithFormat:@"相似度：%f\n返回状态: %@\n返回结果: %@",fScoreSame,mySTApi.status, mySTApi.dictionary ] ;
                
                if ( stImage1 ) {
                    
                    // draw face points
                    
                }
            }
            _bBusy = NO;
            [self.indicator stopAnimating] ;
            
        });
        
        
    } );


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
