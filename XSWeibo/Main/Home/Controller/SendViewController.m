//
//  SendViewController.m
//  XSWeibo
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeButton.h"
#import "ZoomView.h"
#import "NetWorking.h"
#import "AFNetworking.h"
#import "UIProgressView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "FaceView.h"
#import "FaceScrollView.h"

@interface SendViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZoomViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,FaceScrollDelegate>
{
    UITextView *_textView; //输入内容textView
    ZoomView *_photoImage; //显示上传的图片
    UIView *_toolBar;  //工具栏 存放工具栏按钮
    UIImage *_senderimage;
    
    ThemeButton *_cancleButton; //删除图片按钮
    
    UIWindow *_tipWindow;  //提示是否发送成功window
    
    CLLocationManager *_locationManager; //位置管理器
    UILabel *_locationLabel;  // 显示地址label
    
    UIPageControl *_page;//页面视图
    UIScrollView *_scllow;
    FaceScrollView *_faceScrollView;
}

@end

@implementation SendViewController
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送微博";
    [self setItems];
    [self _ceratView];
    [self receiveNotification];
    [self addTap];
}

- (void)creatFaceView
{
    //创建表情视图
    _faceScrollView = [[FaceScrollView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 220)];
    _faceScrollView.delegate = self;
    _faceScrollView.scrollDelegate = self;
    [self.view addSubview:_faceScrollView];
    _faceScrollView.top = kScreenHeight - 64;
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _page.bottom = kScreenHeight - 64;
    _page.numberOfPages = 4;
    _page.currentPage = 0;
    //    _page.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_page];
    _page.hidden = YES;
}
- (void)upScrollView
{
    [UIView animateWithDuration:.3 animations:^{
        _faceScrollView.bottom = kScreenHeight - 64;
        _toolBar.bottom = _faceScrollView.top;
    } completion:^(BOOL finished) {
        _page.hidden = NO;
    }];
}

- (void)downScrollView
{
    [UIView animateWithDuration:.3 animations:^{
        _faceScrollView.top = kScreenHeight - 64;
    } completion:^(BOOL finished) {
        _page.hidden = YES;
    }];
}

//给self.view添加一个点击手势
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}
//点击view关闭键盘
- (void)tapAction
{
    [_textView resignFirstResponder];
}
//text开始编辑开启键盘
- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    [self judgeIsFirstResponder];
    [_textView becomeFirstResponder];
//    [self receiveNotification];
}
//接收改变键盘frame的通知
- (void)receiveNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToolBarFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//随着键盘frame的改变toolbar的frame改变
- (void)changeToolBarFrame:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [value CGRectValue];
    _toolBar.bottom = frame.origin.y - 64;
}

//自定义UIBarButtonItem
- (void)setItems
{
    //关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.backgroundImageName = @"button_icon_close";
    [closeButton addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //发送按钮
    ThemeButton *senderButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [senderButton addTarget:self action:@selector(senderAction) forControlEvents:UIControlEventTouchUpInside];
    senderButton.backgroundImageName = @"button_icon_ok";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:senderButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//关闭按钮点击事件
- (void)cancleButtonAction
{
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击发送按钮事件
- (void)senderAction
{
    //判断输入微博内容是否错误
    NSString *error = nil;
    if (_textView.text.length == 0) {
        error = @"请输入内容";
    }
    else if (_textView.text.length > 140)
    {
        error = @"输入内容请小于140个字";
    }
    
    if (error) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        
        return;
    }
    
    //设置图片数据
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if (_senderimage) {
        NSData *data = UIImageJPEGRepresentation(_senderimage, 1);
        if (data.length > 1024 * 1024 * 2) {
            data = UIImageJPEGRepresentation(_senderimage, .5);
        }
        [datas setObject:data forKey:@"pic"];
    }
    else
    {
        datas = nil;
    }
    
    AFHTTPRequestOperation *operation = [NetWorking POSTURLWithParameters:_textView.text data:datas completionBlock:^(id result) {
        [self showTipStatus:nil title:@"发送成功" show:NO];
        NSLog(@"发送成功");
    } errorBlock:^(NSError *error) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"发送失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        NSLog(@"失败：%@", error);
    }];
    
    if (datas) {
        [self showTipStatus:operation title:@"正在发送" show:YES];
    }
    else
    {
        [self showTipStatus:nil title:@"正在发送" show:YES];
    }
    
    //退出模态视图
    [self cancleButtonAction];
    
}


//状态栏提示
- (void)showTipStatus:(AFHTTPRequestOperation *)operation title:(NSString *)text show:(BOOL)isShow
{
    if (_tipWindow == nil) {
        //创建window
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        //创建提示label;
        UILabel *tipLbael = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tipLbael.tag = 100;
        tipLbael.textAlignment = NSTextAlignmentCenter;
        tipLbael.textColor = [UIColor whiteColor];
        [_tipWindow addSubview:tipLbael];
        
        //设置进度条
        UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(2, 0, kScreenWidth - 4, 10)];
        progress.tag = 101;
        progress.progress = 0;
        progress.bottom = _tipWindow.bottom;
        progress.progressTintColor = [UIColor orangeColor];
        [_tipWindow addSubview:progress];
    }
    //取出label和progress
    UILabel *tipLbael = (UILabel *)[_tipWindow viewWithTag:100];
    UIProgressView *progress = (UIProgressView *)[_tipWindow viewWithTag:101];
    //设置文字
    tipLbael.text = text;
    //是否显示
    if (isShow) {
        _tipWindow.hidden = NO;
        //判断是否要上传文件
        if (operation) {
            //要上传文件
            progress.hidden = NO;
            [progress setProgressWithUploadProgressOfOperation:operation animated:YES];
        }
        else
        {
            //不用上传文件
            progress.hidden = YES;
        }
    }
    else
    {
        _tipWindow.hidden = NO;
        [self performSelector:@selector(hiddenTipWindow) withObject:nil afterDelay:2];
    }
    
    
}

- (void)hiddenTipWindow
{
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}



//创建视图
- (void)_ceratView
{
    //创建textview
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.layer.cornerRadius = 6;
    _textView.layer.borderWidth = 2;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.layer.borderColor = [UIColor orangeColor].CGColor;
    _textView.editable = YES;
    _textView.backgroundColor = [UIColor lightTextColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    //创建工具栏
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 55, kScreenWidth, 55)];
//    _toolBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_toolBar];
    CGFloat width = kScreenWidth / 5;
    NSArray *buttonNameAry = @[@"compose_toolbar_1",
                     @"compose_toolbar_4",
                     @"compose_toolbar_3",
                     @"compose_toolbar_5",
                     @"compose_toolbar_6"];
    for (int index = 0; index < 5; index ++) {
        //创建按钮
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(width * index, 5, width, 45)];
        button.normalImageName = buttonNameAry[index];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:button];
    }
    
    //显示表情
    [self creatFaceView];
}
//点击工具栏按钮事件
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        [self selectPhoto];
    }
    else if (sender.tag == 103)
    {
        [self location];
    }
    else if (sender.tag == 104)
    {
        [self judgeIsFirstResponder];
    }
}

//判断是否是第一响应者
- (void)judgeIsFirstResponder
{
    if (_textView.isFirstResponder) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_textView resignFirstResponder];
        [self upScrollView];
    }
    else
    {
        [self receiveNotification];
        [_textView becomeFirstResponder];
        [self downScrollView];
        //[self showEmotions];
        
    }
}
//显示表情
- (void)showEmotions
{
    _scllow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    UIImage *image = [UIImage imageNamed:@"emoticon_keyboard_background"];
//    image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    _scllow.backgroundColor = [UIColor colorWithPatternImage:image];
    _scllow.bottom = kScreenHeight - 64;
    _scllow.clipsToBounds = NO;
    [self.view addSubview:_scllow];
    _scllow.pagingEnabled = YES;
    _scllow.showsHorizontalScrollIndicator = NO;
    _scllow.delegate = self;

    for (int index = 1; index <= 4; index++) {
        FaceView *face = [[FaceView alloc] initWithFrame:CGRectZero];
        face.delegate = self;
        face.pageNum = index;
        face.backgroundColor = [UIColor clearColor];
        [_scllow addSubview:face];
    }
    _scllow.contentSize = CGSizeMake(kScreenWidth * 4, 0);
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _page.bottom = kScreenHeight - 64;
    _page.numberOfPages = 4;
    _page.currentPage = 0;
//    _page.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_page];

}
//表情视图代理方法
- (void)write:(NSString *)str
{
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,str];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

//设置地理位置
- (void)location
{
    //创建显示位置的label
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, 20)];
        [_toolBar addSubview:_locationLabel];
        _locationLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _locationLabel.text = @"  正在定位...";
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        //判断是否是8.0版本
        if (kDeviceVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    //设置精确度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置代理
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];
    
}
//location代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [_locationManager stopUpdatingLocation];
    //获取地理位置
    CLLocation *location = [locations lastObject];
//    NSLog(@"地理位置信息 %@",location);
    CLLocationCoordinate2D coordinate = location.coordinate;
   // NSLog(@"经度 %lf,纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    //weibo地理位置接口  发送坐标返回地理位置
    //设置参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *locationSTR = [NSString stringWithFormat:@"%lf,%lf",coordinate.longitude,coordinate.latitude];
    [parameters setObject:locationSTR forKey:@"coordinate"];
    //设置access_token
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [parameters setObject:appdelegate.weib.accessToken forKey:@"access_token"];
    
    //发送get请求
    [NetWorking GETURLWithURLStr:geo_to_address Parameters:parameters completionBlock:^(id result) {
        NSArray *ary = result[@"geos"];
        if (ary.count > 0) {
            NSDictionary *dic = [ary lastObject];
            NSString *address = dic[@"address"];
            if (address) {
                _locationLabel.text = address;
            }
            else
            {
                _locationLabel.text = @"未知地址";
            }
            //NSLog(@"%@",address);
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"错误 %@",error);
        _locationLabel.text = @"定位失败";
    }];
    
    
    //iOS 内置反编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = [placemarks lastObject];

        NSLog(@"%@",place.name);
    }];
}


//选择相册
- (void)selectPhoto
{
    //设置弹出框
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [sheet showInView:self.view];
}

//弹出视图的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //设置类型
    UIImagePickerControllerSourceType sourceType;
    //当点击拍照按钮
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"警告" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            return;
        }
    }
    else if (buttonIndex == 1)
    {
        //点击相册按钮
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        return;
    }
    
    //创建相册访问控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}


//选择相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //选择照片
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        if (!_photoImage) {
            //创建显示要发送的图片的imageView
            _photoImage = [[ZoomView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
            //    _photoImage.contentMode = UIViewContentModeScaleAspectFit;
            _photoImage.delegate = self;
            _photoImage.top = _textView.bottom + 5;
            //    _photoImage.backgroundColor = [UIColor yellowColor];
            [self.view addSubview:_photoImage];
        }
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        _photoImage.image = image;
        _senderimage = image;
        
        //创建删除按钮
        if (_cancleButton == nil) {
            _cancleButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            _cancleButton.left = _photoImage.right;
            _cancleButton.top = _photoImage.top;
            [_cancleButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _cancleButton.backgroundColor = [UIColor lightGrayColor];
            _cancleButton.backgroundImageName = @"button_icon_close";
            [self.view addSubview:_cancleButton];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//删除图片按钮执行方法
- (void)deleteButtonAction
{
    [_photoImage removeFromSuperview];
    _photoImage = nil;
    _senderimage = nil;
    [_cancleButton removeFromSuperview];
    _cancleButton = nil;
}


//zoomView代理方法
- (void)zoomIN
{
    //收起键盘
    [_textView resignFirstResponder];
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
