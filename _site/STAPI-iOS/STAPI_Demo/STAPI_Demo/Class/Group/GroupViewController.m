//
//  GroupViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 16/1/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "GroupViewController.h"

#import "STAPI.h"
#import "STImage.h"
#import "STPerson.h"
#import "STGroup.h"
#import "STCommon.h"
#import "MyAPIKey.h"
#import "ImageFace.h"

#import "GroupListCell.h"
#import "FaceIdentifiViewController.h"

@interface GroupViewController ()<UITableViewDelegate, UITableViewDataSource,
UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL bIsSelectImage;
    UIButton *_btnPhoto;
    UIButton *_btnStart;
    UIImage *_photoImage;
    UITableView *_tableView;
    UITextField *_nameTextView;
    UIImageView *_imageviewForAdding;
    UIActivityIndicatorView *_indicator;
    UIImagePickerController *_photoPicker;
}

@property (nonatomic, strong) STAPI *myAPI;
@property (nonatomic, strong) STGroup *group;
@property (nonatomic, strong) NSMutableArray *arrPersons;
@property (nonatomic, strong) NSMutableArray *arrPersonNames;

@end

@implementation GroupViewController

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
    
    bIsSelectImage = NO;
    self.arrPersons = [[NSMutableArray alloc] init];
    self.arrPersonNames = [[NSMutableArray alloc] init];
    
    self.myAPI = [[STAPI alloc] init ] ;
    self.myAPI.bDebug = YES ;
    [self.myAPI start_apiid:MyApiID apisecret:MyApiSecret] ;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(onAddPerson)];
    rightItem.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = rightItem;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:(UITableViewStylePlain)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    [self initAddingView];
    [self initCamera];
    [self createGroup];

    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.frame = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50);
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    
    _btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStart.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-100, 100, 80);
    [_btnStart addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside];
    _btnStart.backgroundColor = [UIColor lightGrayColor];
    _btnStart.layer.borderWidth = 1;
    _btnStart.contentMode = UIViewContentModeScaleAspectFit;
    [_btnStart setTitle:@"开   始" forState:UIControlStateNormal];
    [_btnStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnStart.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_btnStart];
}

- (void)initAddingView
{
    _imageviewForAdding = [[UIImageView alloc] init];
    _imageviewForAdding.hidden = YES;
    _imageviewForAdding.userInteractionEnabled = YES;
    _imageviewForAdding.backgroundColor = [UIColor lightGrayColor];
    _imageviewForAdding.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-200, 400, 400);
    _imageviewForAdding.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageviewForAdding.layer.borderWidth = 1;
    [self.view addSubview:_imageviewForAdding];
    
    UILabel *lbTitle = [[UILabel alloc] init];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = @"请输入名字";
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.frame = CGRectMake(_imageviewForAdding.frame.size.width/2-100, 20, 200, 30);
    [_imageviewForAdding addSubview:lbTitle];
    
    _nameTextView = [[UITextField alloc] init];
    _nameTextView.backgroundColor = [UIColor whiteColor];
    _nameTextView.placeholder = @"姓名";
    _nameTextView.textAlignment = NSTextAlignmentLeft;
    _nameTextView.frame = CGRectMake(_imageviewForAdding.frame.size.width/2-130, 60, 260, 40);
    [_imageviewForAdding addSubview:_nameTextView];
    
    _btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPhoto.frame = CGRectMake(_imageviewForAdding.frame.size.width/2-130, 110, 260, 200);
    [_btnPhoto addTarget:self action:@selector(onPhoto) forControlEvents:UIControlEventTouchUpInside];
    _btnPhoto.backgroundColor = [UIColor whiteColor];
    _btnPhoto.layer.borderWidth = 1;
    _btnPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [_btnPhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [_btnPhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imageviewForAdding addSubview:_btnPhoto];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(70, 340, 60, 40);
    [btnCancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.layer.borderWidth = 1;
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imageviewForAdding addSubview:btnCancel];

    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnConfirm.frame = CGRectMake(_imageviewForAdding.frame.size.width-130, 340, 60, 40);
    [btnConfirm addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    btnConfirm.backgroundColor = [UIColor whiteColor];
    btnConfirm.layer.borderWidth = 1;
    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnConfirm.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imageviewForAdding addSubview:btnConfirm];
}

- (void)initCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        
    }
//    sourceType = UIImagePickerControllerSourceTypeCamera;
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _photoPicker = [[UIImagePickerController alloc] init];
    _photoPicker.delegate = self;
    _photoPicker.allowsEditing = NO;
    _photoPicker.sourceType = sourceType;
}

#pragma mark
#pragma mark button event

- (void)onAddPerson
{
    _imageviewForAdding.hidden = NO;

}

- (void)onCancel
{
    _imageviewForAdding.hidden = YES;
}

- (void)onConfirm
{
    //check parameter
    if ([_nameTextView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"请输入名字"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (!bIsSelectImage)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"请输入图像"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [_indicator startAnimating];
    
    //create person: 2steps, 1-get faceId, 2-create person
    if ( self.myAPI.error )
    {
        NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
              self.myAPI.status,
              self.myAPI.httpStatusCode,
              [self.myAPI.error description]);
        if (self.myAPI.httpStatusCode == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                           message:@"请连接网络"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }

        [_indicator stopAnimating];
        return;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        STImage *stImage = [self.myAPI face_detection_image:_photoImage] ;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
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
                    //the photoImage maybe contain one or more faces
                    NSString *strIds;
                    for (int i=0; i<stImage.arrFaces.count; i++)
                    {
                        ImageFace *face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:i] landmarksType:21];
                        
                        if (!strIds)
                        {
                            strIds = face.strFaceID;
                        }
                        else
                        {
                            strIds = [strIds stringByAppendingString:[NSString stringWithFormat:@",%@",face.strFaceID]];
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
                    
                    //if find face, create person
                    STPerson *person = [self.myAPI person_create_name:_nameTextView.text faceids:strIds userdata:@"mark"];
                    
                    //create person success
                    if (person && person.strPersonID && person.iFaceCount > 0)
                    {
                        [_arrPersons addObject:person];
                        
                        //get person info
                        NSDictionary *dicPersonInfo = [self.myAPI info_personid:person.strPersonID];
                        [self.arrPersonNames addObject:[dicPersonInfo objectForKey:@"name"]];
                        
                        //send into group
                        BOOL bAddPerson = [self.myAPI group_add_person_groupid:self.group.strGroupID personids:person.strPersonID];
                        
                        if (!bAddPerson)
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                           message:@"添加到组失败"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else
                        {
                            //refresh into tableview
                            [_tableView reloadData];
                            
                            //clear addingview
                            _nameTextView.text = @"";
                            [_btnPhoto setImage:nil forState:UIControlStateNormal];
                            _photoImage = nil;
                        }
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                       message:@"创建Person失败"
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    [_nameTextView resignFirstResponder];
                    _imageviewForAdding.hidden = YES;
                    [_indicator stopAnimating];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                   message:@"检测人脸失败，请重试"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                    [alert show];
                    [_indicator stopAnimating];
                }
            }
        });
    } );
}

- (void)onPhoto
{
    [self presentViewController:_photoPicker animated:YES completion:nil];
}

- (void)onStart
{
    if (!_arrPersons.count)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"请添加Person"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    FaceIdentifiViewController *vc = [[FaceIdentifiViewController alloc] init];
    vc.strGroupId = _group.strGroupID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
#pragma mark group

- (void)createGroup
{
    [_indicator startAnimating];
    
    if ( self.myAPI.error )
    {
        NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
              self.myAPI.status,
              self.myAPI.httpStatusCode,
              [self.myAPI.error description]);
        
        [_indicator stopAnimating];
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        NSDictionary *dictGroups = [self.myAPI info_list_groups];
        NSArray *arr = dictGroups[@"groups"];
        
        if (arr.count > 0)
        {
            for (int i = 0; i <arr.count; i++)
            {
                NSString *strGroup_id = arr[i][@"group_id"];
                [self.myAPI group_delete_groupid:strGroup_id];
            }
        }
        
        sleep(1);
        self.group = [self.myAPI group_create_groupname:@"mark_ios" personids:nil userdata:@"mark"];

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.myAPI.error)
            {
                NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                      self.myAPI.status,
                      self.myAPI.httpStatusCode,
                      [self.myAPI.error description]);
                [_indicator stopAnimating];
            }
            else
            {
                if ([self.myAPI.status isEqualToString:STATUS_OK])
                {
                    if (self.group.strGroupID && self.group.strGroupName)
                    {
                        NSLog(@"create group success");
                    }
                    else
                    {
                        NSLog(@"create group failed");
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                       message:@"创建Group失败"
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    [_indicator stopAnimating];
                }
            }
        });
    } );
}

#pragma mark 
#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrPersons.count;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonCell";
    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[GroupListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
    }
    
    STPerson *person = [_arrPersons objectAtIndex:indexPath.row];
    NSString *name = [_arrPersonNames objectAtIndex:indexPath.row];
    
    cell.lbName.text = name;
    cell.lbFaceCount.text = [NSString stringWithFormat:@"人脸数:%lu", (unsigned long)person.iFaceCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_indicator startAnimating];
        STPerson *person = [_arrPersons objectAtIndex:indexPath.row];
        
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            BOOL bDelete = [self.myAPI person_delete_personid:person.strPersonID];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.myAPI.error)
                {
                    NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                          self.myAPI.status,
                          self.myAPI.httpStatusCode,
                          [self.myAPI.error description]);
                    [_indicator stopAnimating];
                }
                else
                {
                    if ([self.myAPI.status isEqualToString:STATUS_OK] && bDelete)
                    {
                        [_arrPersons removeObjectAtIndex:indexPath.row];
                        [_arrPersonNames removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [_indicator stopAnimating];
                    }
                }
            });
        } );
    }
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
        _tableView.frame = CGRectMake(0,0,size.width,size.height);
        _indicator.frame = CGRectMake(size.width/2-25, size.height/2-25, 50, 50);
        _btnStart.frame = CGRectMake(size.width/2-50, size.height-100, 100, 80);

        _imageviewForAdding.frame = CGRectMake(size.width/2-200, size.height/2-200, 400, 400);
        
    }
}


#pragma mark
#pragma mark pickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    bIsSelectImage = YES;
    _photoImage = photoImage;
    [_btnPhoto setImage:photoImage forState:UIControlStateNormal];
    [_photoPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    bIsSelectImage = NO;
    [_photoPicker dismissViewControllerAnimated:YES completion:nil];
}

@end
