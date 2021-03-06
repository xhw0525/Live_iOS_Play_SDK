//
//  LiveViewController.m
//  NewCCDemo
//
//  Created by cc on 2016/11/23.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "LiveViewController.h"
#import "TextFieldUserInfo.h"
#import "NavigationView.h"
#import "InformationShowView.h"
#import "LoadingView.h"
//#import "CCPush/CCPushUtil.h"
#import "SettingViewController.h"
#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LiveViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIBarButtonItem      *leftBarBtn;
@property(nonatomic,strong)UIBarButtonItem      *rightBarBtn;
@property(nonatomic,strong)UILabel              *informationLabel;

@property(nonatomic,strong)TextFieldUserInfo    *textFieldUserId;
@property(nonatomic,strong)TextFieldUserInfo    *textFieldRoomId;
@property(nonatomic,strong)TextFieldUserInfo    *textFieldUserName;
@property(nonatomic,strong)TextFieldUserInfo    *textFieldUserPassword;

@property(nonatomic,strong)UIButton             *loginBtn;
@property(nonatomic,strong)NavigationView       *navigationView;
@property(nonatomic,strong)LoadingView          *loadingView;
@property(nonatomic,copy)NSString               *viewerId;
@property(nonatomic,copy)NSString               *roomName;
@property(nonatomic,strong)InformationShowView  *informationView;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem=self.leftBarBtn;
    self.navigationItem.rightBarButtonItem=self.rightBarBtn;
    [self.navigationController.navigationBar setBackgroundImage:
     [self createImageWithColor:CCRGBColor(255,102,51)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = CCRGBColor(250, 250, 250);
    [self.view addSubview:self.informationLabel];
    
    WS(ws);
    [_informationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
        make.top.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));;
        make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(CCGetRealFromPt(24));
    }];
    
    [self.view addSubview:self.textFieldUserId];
    [self.view addSubview:self.textFieldRoomId];
    [self.view addSubview:self.textFieldUserName];
    [self.view addSubview:self.textFieldUserPassword];
    
    self.textFieldUserId.text = @"B27039502337407C";
    self.textFieldRoomId.text = @"70C6ADD72B967B7C9C33DC5901307461";
    self.textFieldUserName.text = @"yinzhaoqing";
    self.textFieldUserPassword.text = @"111";
    
    [self.textFieldUserId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.informationLabel.mas_bottom).with.offset(CCGetRealFromPt(22));
        make.height.mas_equalTo(CCGetRealFromPt(92));
    }];
    
    [self.textFieldRoomId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ws.textFieldUserId);
        make.top.mas_equalTo(ws.textFieldUserId.mas_bottom);
        make.height.mas_equalTo(ws.textFieldUserId.mas_height);
    }];

    [self.textFieldUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ws.textFieldUserId);
        make.top.mas_equalTo(ws.textFieldRoomId.mas_bottom);
        make.height.mas_equalTo(ws.textFieldRoomId.mas_height);
    }];

    [self.textFieldUserPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ws.textFieldUserId);
        make.top.mas_equalTo(ws.textFieldUserName.mas_bottom);
        make.height.mas_equalTo(ws.textFieldUserName);
    }];
    
    UIView *line = [UIView new];
    [self.view addSubview:line];
    [line setBackgroundColor:CCRGBColor(238,238,238)];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.textFieldUserPassword.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(65));
        make.right.mas_equalTo(ws.view).with.offset(-CCGetRealFromPt(65));
        make.top.mas_equalTo(line.mas_bottom).with.offset(CCGetRealFromPt(70));
        make.height.mas_equalTo(CCGetRealFromPt(86));
    }];
    
    _navigationView = [[NavigationView alloc] initWithTitle:@"我要直播" pushBlock:^(NSInteger index) {
        UIViewController *viewController = nil;
        switch (index) {
            case 1:
//                viewController = [[LiveViewController alloc] init];
                break;
            case 2:
                viewController = [[PlayViewController alloc] init];
                break;
            case 3:
                viewController = [[PlayBackViewController alloc] init];
                break;
            default:
                break;
        }
        [ws.navigationController pushViewController:viewController animated:NO];
    }];
    
    self.navigationItem.titleView = _navigationView;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:CONTROLLER_INDEX];
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(165), CCGetRealFromPt(34)));
    }];
    
    [self addObserver];
}

//#pragma mark - QRCodeReader Delegate Methods
//- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSRange rangeRoomId = [result rangeOfString:@"roomid="];
//        NSRange rangeUserId = [result rangeOfString:@"userid="];
//        
//        if (rangeRoomId.location == NSNotFound || rangeUserId.location == NSNotFound) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"扫码失败" message:@"扫的二维码肯定错了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        } else {
//            NSString *roomId = [result substringWithRange:NSMakeRange(rangeRoomId.location + rangeRoomId.length, rangeUserId.location - 1 - (rangeRoomId.location + rangeRoomId.length))];
//            NSString *userId = [result substringFromIndex:rangeUserId.location + rangeUserId.length];
//            
//            //            NSLog(@"roomId = %@,userId = %@",roomId,userId);
//            
//            self.textFieldRoomId.text = roomId;
//            self.textFieldUserId.text = userId;
//        }
//    }];
//}
//
//- (void)readerDidCancel:(QRCodeReaderViewController *)reader
//{
////    [self dismissViewControllerAnimated:YES completion:NULL];
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.textFieldUserId.text = GetFromUserDefaults(LIVE_USERID);
    self.textFieldRoomId.text = GetFromUserDefaults(LIVE_ROOMID);
    self.textFieldUserName.text = GetFromUserDefaults(LIVE_USERNAME);
    self.textFieldUserPassword.text = GetFromUserDefaults(LIVE_PASSWORD);
    
    if(StrNotEmpty(_textFieldUserId.text) && StrNotEmpty(_textFieldRoomId.text) && StrNotEmpty(_textFieldUserName.text)) {
        self.loginBtn.enabled = YES;
        [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
    } else {
        self.loginBtn.enabled = NO;
        [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
    }
}

-(void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc {
    [self removeObserver];
}

-(UIButton *)loginBtn {
    if(_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = CCRGBColor(255,102,51);
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_loginBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:CCRGBAColor(255, 255, 255, 0.4) forState:UIControlStateDisabled];
        [_loginBtn.layer setMasksToBounds:YES];
//        [_loginBtn.layer setBorderWidth:1.0];
//        [_loginBtn.layer setBorderColor:[CCRGBColor(255,71,0) CGColor]];
        [_loginBtn.layer setCornerRadius:CCGetRealFromPt(40)];
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];

        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255,102,51)] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBAColor(255,102,51,0.2)] forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(248,92,40)] forState:UIControlStateHighlighted];
    }
    return _loginBtn;
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//监听touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self keyboardHide];
}

-(void)informationViewRemove {
    [_informationView removeFromSuperview];
    _informationView = nil;
}

-(void)loginAction {
    [self.view endEditing:YES];
    [self keyboardHide];
    if(self.textFieldUserName.text.length > 20) {
        [_informationView removeFromSuperview];
        _informationView = [[InformationShowView alloc] initWithLabel:@"用户名限制在20个字符以内"];
        [self.view addSubview:_informationView];
        [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(informationViewRemove) userInfo:nil repeats:NO];
        return;
    }
    
    _loadingView = [[LoadingView alloc] initWithLabel:@"正在登录..." centerY:NO];
    [self.view addSubview:_loadingView];

    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_loadingView layoutIfNeeded];
//    self.textFieldUserId.text = @"B27039502337407C";
//    self.textFieldRoomId.text = @"1015DD10924CC6759C33DC5901307461";
//    self.textFieldUserName.text = @"yinzhaoqing";
//    self.textFieldUserPassword.text = @"111";
    
    //[[CCPushUtil sharedInstanceWithDelegate:self] loginWithUserId:self.textFieldUserId.text RoomId:self.textFieldRoomId.text ViewerName:self.textFieldUserName.text ViewerToken:self.textFieldUserPassword.text];
}

-(UILabel *)informationLabel {
    if(_informationLabel == nil) {
        _informationLabel = [UILabel new];
        [_informationLabel setBackgroundColor:CCRGBColor(250, 250, 250)];
        [_informationLabel setFont:[UIFont systemFontOfSize:FontSize_24]];
        [_informationLabel setTextColor:CCRGBColor(102, 102, 102)];
        [_informationLabel setTextAlignment:NSTextAlignmentLeft];
        [_informationLabel setText:@"直播间信息"];
    }
    return _informationLabel;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(UIBarButtonItem *)leftBarBtn {
    if(_leftBarBtn == nil) {
        UIImage *aimage = [UIImage imageNamed:@"nav_ic_back_nor"];
        UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _leftBarBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSelectVC)];
    }
    return _leftBarBtn;
}

-(UIBarButtonItem *)rightBarBtn {
    if(_rightBarBtn == nil) {
        UIImage *aimage = [UIImage imageNamed:@"nav_ic_code"];
        UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _rightBarBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSweepCode)];
    }
    return _rightBarBtn;
}

//扫码
-(void)onSweepCode {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        ScanViewController *scanViewController = [[ScanViewController alloc] initWithType:1];
                        [self.navigationController pushViewController:scanViewController animated:NO];
                    }else{
                        //用户拒绝
                        ScanViewController *scanViewController = [[ScanViewController alloc] initWithType:1];
                        [self.navigationController pushViewController:scanViewController animated:NO];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            ScanViewController *scanViewController = [[ScanViewController alloc] initWithType:1];
            [self.navigationController pushViewController:scanViewController animated:NO];
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            // 用户明确地拒绝授权，或者相机设备无法访问
            ScanViewController *scanViewController = [[ScanViewController alloc] initWithType:1];
            [self.navigationController pushViewController:scanViewController animated:NO];
        }
            break;
        default:
            break;
    }

//    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
//        QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
//        reader.delegate = self;
//        reader.title = @"扫描观看地址";
//        [reader setCompletionWithBlock:^(NSString *resultAsString) {
//        }];
//        
//        [self.navigationController pushViewController:reader animated:YES];
//    }
//    else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描错误" message:@"请打开本应用的摄像头权限" preferredStyle:(UIAlertControllerStyleAlert)];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:okAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}
    
-(TextFieldUserInfo *)textFieldUserId {
    if(_textFieldUserId == nil) {
        _textFieldUserId = [TextFieldUserInfo new];
        [_textFieldUserId textFieldWithLeftText:@"CC账号ID" placeholder:@"16位账号ID" lineLong:YES text:GetFromUserDefaults(LIVE_USERID)];
        _textFieldUserId.delegate = self;
        _textFieldUserId.tag = 1;
        [_textFieldUserId addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldUserId;
}

-(TextFieldUserInfo *)textFieldRoomId {
    if(_textFieldRoomId == nil) {
        _textFieldRoomId = [TextFieldUserInfo new];
        [_textFieldRoomId textFieldWithLeftText:@"直播间ID" placeholder:@"32位直播间ID" lineLong:NO text:GetFromUserDefaults(LIVE_ROOMID)];
        _textFieldRoomId.delegate = self;
        _textFieldRoomId.tag = 2;
        [_textFieldRoomId addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldRoomId;
}

-(TextFieldUserInfo *)textFieldUserName {
    if(_textFieldUserName == nil) {
        _textFieldUserName = [TextFieldUserInfo new];
        [_textFieldUserName textFieldWithLeftText:@"昵称" placeholder:@"聊天中显示的名字" lineLong:NO text:GetFromUserDefaults(LIVE_USERNAME)];
        _textFieldUserName.delegate = self;
        _textFieldUserName.tag = 3;
        [_textFieldUserName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldUserName;
}

-(TextFieldUserInfo *)textFieldUserPassword {
    if(_textFieldUserPassword == nil) {
        _textFieldUserPassword = [TextFieldUserInfo new];
        [_textFieldUserPassword textFieldWithLeftText:@"密码" placeholder:@"讲师密码" lineLong:NO text:GetFromUserDefaults(LIVE_PASSWORD)];
        _textFieldUserPassword.delegate = self;
        _textFieldUserPassword.tag = 4;
        [_textFieldUserPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldUserPassword.secureTextEntry = YES;
    }
    return _textFieldUserPassword;
}

-(void)onSelectVC {
    [self.navigationView hideNavigationView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CCPushDelegate
//@optional
/**
 *	@brief	请求成功
 */
-(void)requestLoginSucceedWithViewerId:(NSString *)viewerId {
    //NSLog(@"登录成功 viewerId = %@",viewerId);
    self.viewerId = viewerId;
    SaveToUserDefaults(LIVE_USERID,_textFieldUserId.text);
    SaveToUserDefaults(LIVE_ROOMID,_textFieldRoomId.text);
    SaveToUserDefaults(LIVE_USERNAME,_textFieldUserName.text);
    SaveToUserDefaults(LIVE_PASSWORD,_textFieldUserPassword.text);
    
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:NO],SET_SCREEN_LANDSCAPE,[NSNumber numberWithBool:YES],SET_BEAUTIFUL,
                                   @"前置摄像头",SET_CAMERA_DIRECTION,
                                   @"360*640",SET_SIZE,
                                   [NSNumber numberWithInteger:450],SET_BITRATE,
                                   [NSNumber numberWithInteger:20],SET_IFRAME,
                                   [NSNumber numberWithInteger:0],SET_SERVER_INDEX,
                                   nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

/**
 *	@brief	登录请求失败
 */
-(void)requestLoginFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    [_informationView removeFromSuperview];
    _informationView = [[InformationShowView alloc] initWithLabel:message];
    [self.view addSubview:_informationView];
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(informationViewRemove) userInfo:nil repeats:NO];
}

#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidChange:(UITextField *) TextField {
    if(StrNotEmpty(_textFieldUserId.text) && StrNotEmpty(_textFieldRoomId.text) && StrNotEmpty(_textFieldUserName.text)) {
        self.loginBtn.enabled = YES;
        [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
    } else {
        self.loginBtn.enabled = NO;
        [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
    }
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.textFieldRoomId isFirstResponder] && ![self.textFieldUserId isFirstResponder] && [self.textFieldUserName isFirstResponder] && ![self.textFieldUserPassword isFirstResponder]) {
        return;
    }
    
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat y = keyboardRect.size.height;
    CGFloat x = keyboardRect.size.width;
    //NSLog(@"键盘高度是  %d",(int)y);
    //NSLog(@"键盘宽度是  %d",(int)x);
    
    for (int i = 1; i <= 4; i++) {
        UITextField *textField = [self.view viewWithTag:i];
        //NSLog(@"textField = %@,%f,%f",NSStringFromCGRect(textField.frame),CGRectGetMaxY(textField.frame),SCREENH_HEIGHT);
        if ([textField isFirstResponder] == true && (SCREENH_HEIGHT - (CGRectGetMaxY(textField.frame) + CCGetRealFromPt(10))) < y) {
            WS(ws)
            [self.informationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
                make.top.mas_equalTo(ws.view).with.offset( - (y - (SCREENH_HEIGHT - (CGRectGetMaxY(textField.frame) + CCGetRealFromPt(10)))));
                make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
                make.height.mas_equalTo(CCGetRealFromPt(24));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            }];
        }
    }
}

-(void)keyboardHide {
    WS(ws)
    [self.informationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
        make.top.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));;
        make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(CCGetRealFromPt(24));
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [ws.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [self keyboardHide];
}

- (void)loginRoomName:(NSString *)roomName {
    _roomName = roomName;
}

/**
 *	@brief	返回节点列表，节点测速时间，以及最优点索引(从0开始，如果无最优点，随机获取节点当作最优节点)
 */
- (void) nodeListDic:(NSMutableDictionary*)dic bestNodeIndex:(NSInteger)index {
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithServerDic:dic viewerId:self.viewerId roomName:_roomName];
    SaveToUserDefaults(SET_SERVER_INDEX,[NSNumber numberWithInteger:index]);
    [self.navigationController pushViewController:settingViewController animated:NO];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
