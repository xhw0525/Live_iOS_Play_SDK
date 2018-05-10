//
//  PushViewController.m
//  NewCCDemo
//
//  Created by cc on 2016/12/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "PushViewController.h"
#import "InformationShowView.h"
#import "ModelView.h"
#import "CCPublicTableViewCell.h"
#import "CustomTextField.h"
#import "CCPrivateChatView.h"

@interface PushViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView               *preView;
@property(nonatomic,strong)UIView               *informationView;
@property(nonatomic,strong)UILabel              *hostNameLabel;
@property(nonatomic,strong)UILabel              *userCountLabel;
@property(nonatomic,strong)NSTimer              *timer;

@property(nonatomic,strong)UIButton             *publicChatBtn;
@property(nonatomic,strong)UIButton             *privateChatBtn;
@property(nonatomic,strong)UIButton             *cameraChangeBtn;
@property(nonatomic,strong)UIButton             *micChangeBtn;
@property(nonatomic,strong)UIButton             *beautifulBtn;
@property(nonatomic,strong)UIButton             *closeBtn;

@property(nonatomic,strong)ModelView            *modelView;
@property(nonatomic,strong)UIView               *modeoCenterView;
@property(nonatomic,strong)UILabel              *modeoCenterLabel;
@property(nonatomic,strong)UIButton             *cancelBtn;
@property(nonatomic,strong)UIButton             *sureBtn;

@property(nonatomic,strong)CustomTextField      *chatTextField;
@property(nonatomic,strong)UIButton             *sendButton;
@property(nonatomic,strong)UIView               *contentView;
@property(nonatomic,strong)UIButton             *rightView;

@property(nonatomic,strong)UITableView          *tableView;
@property(nonatomic,strong)NSMutableArray       *tableArray;
@property(nonatomic,copy)NSString               *antename;
@property(nonatomic,copy)NSString               *anteid;

@property(nonatomic,strong)UIImageView          *contentBtnView;
@property(nonatomic,strong)UIView               *emojiView;
@property(nonatomic,assign)CGRect               keyboardRect;
@property(nonatomic,strong)CCPrivateChatView    *ccPrivateChatView;

@property(nonatomic,strong)NSMutableDictionary  *dataPrivateDic;
@property(nonatomic,copy)  NSString             *viewerId;
@property(nonatomic,strong)InformationShowView  *informationViewPop;

@end

@implementation PushViewController

-(instancetype)initWithViwerid:(NSString *)viewerId {
    self = [super init];
    if(self) {
        self.viewerId = viewerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self addObserver];
    
    [self startTimer];
    
    //[[CCPushUtil sharedInstanceWithDelegate:self] setPreview:_preView];
    
    BOOL isCameraFront = [GetFromUserDefaults(SET_CAMERA_DIRECTION) isEqualToString:@"前置摄像头"];
    //[[CCPushUtil sharedInstanceWithDelegate:self] startPushWithCameraFront:isCameraFront];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

-(NSDictionary *)dataPrivateDic {
    if(!_dataPrivateDic) {
        _dataPrivateDic = [[NSMutableDictionary alloc] init];
    }
    return _dataPrivateDic;
}

- (void)dealSingleTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.view];
    [self.chatTextField resignFirstResponder];
    if(CGRectContainsPoint(self.tableView.frame, point)) {
        
    } else {
        //[[CCPushUtil sharedInstanceWithDelegate:self] focuxAtPoint:point];
    }
}

-(void) stopTimer {
    if([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)startTimer {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerfunc) userInfo:nil repeats:YES];
}

- (void)timerfunc {
    //[[CCPushUtil sharedInstanceWithDelegate:self] roomContext];
    //[[CCPushUtil sharedInstanceWithDelegate:self] roomUserCount];
}

-(ModelView *)modelView {
    if(!_modelView) {
        _modelView = [ModelView new];
        _modelView.backgroundColor = CCClearColor;
    }
    return _modelView;
}

-(UIView *)modeoCenterView {
    if(!_modeoCenterView) {
        _modeoCenterView = [UIView new];
        _modeoCenterView.backgroundColor = [UIColor whiteColor];
        _modeoCenterView.layer.borderWidth = 1;
        _modeoCenterView.layer.borderColor = [CCRGBColor(187, 187, 187) CGColor];
        _modeoCenterView.layer.cornerRadius = CCGetRealFromPt(10);
        _modeoCenterView.layer.masksToBounds = YES;
    }
    return _modeoCenterView;
}

-(UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.layer.cornerRadius = CCGetRealFromPt(10);
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:CCRGBColor(51,51,51) forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor whiteColor];
        _sureBtn.layer.cornerRadius = CCGetRealFromPt(10);
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:CCRGBColor(51,51,51) forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(CGSize)getTitleSizeByFont:(NSString *)str font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(20000.0f, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

-(void)initUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.preView];
    WS(ws)
    [_preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
    [self.view addSubview:self.informationView];
    NSString *userName = [@"主播：" stringByAppendingString:GetFromUserDefaults(LIVE_USERNAME)];
    NSString *userCount = @"在线人数：20";
    CGSize userNameSize = [self getTitleSizeByFont:userName font:[UIFont systemFontOfSize:FontSize_26]];
    CGSize userCountSize = [self getTitleSizeByFont:userCount font:[UIFont systemFontOfSize:FontSize_26]];

    CGSize size = userNameSize.width > userCountSize.width ? userNameSize : userCountSize;
    
    if(size.width > self.view.frame.size.width * 0.75) {
        size.width = self.view.frame.size.width * 0.75;
    }
    
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(80));
        make.width.mas_equalTo(CCGetRealFromPt(75) + size.width);
        make.height.mas_equalTo(CCGetRealFromPt(90));
    }];
    
    [self.view addSubview:self.contentBtnView];
    [self.view addSubview:self.tableView];
    [self.contentBtnView addSubview:self.publicChatBtn];
    [self.contentBtnView addSubview:self.privateChatBtn];
    [self.contentBtnView addSubview:self.cameraChangeBtn];
    [self.contentBtnView addSubview:self.micChangeBtn];
    [self.contentBtnView addSubview:self.beautifulBtn];
    [self.contentBtnView addSubview:self.closeBtn];
    
    [self.view addSubview:self.ccPrivateChatView];
    
    [self.ccPrivateChatView setCheckDotBlock1:^(BOOL flag) {
        ws.privateChatBtn.selected = flag;
    }];
    
    _cameraChangeBtn.selected = ![GetFromUserDefaults(SET_CAMERA_DIRECTION) isEqualToString:@"前置摄像头"];
    _micChangeBtn.selected = NO;
    
    BOOL beauti = [[[NSUserDefaults standardUserDefaults] objectForKey:SET_BEAUTIFUL] boolValue];
    _beautifulBtn.selected = beauti;
    
    if(!self.isScreenLandScape) {
        [_contentBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(130));
        }];
        
        [_publicChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.contentBtnView).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(25));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80), CCGetRealFromPt(80)));
        }];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.publicChatBtn);
            make.size.mas_equalTo(ws.publicChatBtn);
        }];
        
        [_beautifulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.closeBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.closeBtn);
            make.size.mas_equalTo(ws.closeBtn);
        }];
        
        [_micChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.beautifulBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.beautifulBtn);
            make.size.mas_equalTo(ws.beautifulBtn);
        }];
        
        [_cameraChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.micChangeBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.micChangeBtn);
            make.size.mas_equalTo(ws.micChangeBtn);
        }];
        
        [_privateChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.cameraChangeBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.cameraChangeBtn);
            make.size.mas_equalTo(ws.cameraChangeBtn);
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView.mas_top);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
        }];
        
        [self.view addSubview:self.contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
        
        [self.contentView addSubview:self.chatTextField];
        [_chatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.left.mas_equalTo(ws.contentView).offset(CCGetRealFromPt(24));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(556), CCGetRealFromPt(84)));
        }];
        
        [self.contentView addSubview:self.sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.right.mas_equalTo(ws.contentView).offset(-CCGetRealFromPt(24));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(120), CCGetRealFromPt(84)));
        }];
        
        self.contentView.hidden = YES;
        
        [_ccPrivateChatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(542));
            make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
        }];
    } else {
        [_contentBtnView setImage:[UIImage imageNamed:@"Rectangle1"]];
        [_contentBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.and.right.mas_equalTo(ws.view);
            make.width.mas_equalTo(CCGetRealFromPt(130));
        }];
        
        [_publicChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(30));
            make.right.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(30));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80), CCGetRealFromPt(80)));
        }];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.contentBtnView).offset(CCGetRealFromPt(70));
            make.right.mas_equalTo(ws.publicChatBtn);
            make.size.mas_equalTo(ws.publicChatBtn);
        }];
        
        [_beautifulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.closeBtn.mas_bottom).offset(CCGetRealFromPt(20));
            make.right.mas_equalTo(ws.closeBtn);
            make.size.mas_equalTo(ws.closeBtn);
        }];
        
        [_micChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.beautifulBtn.mas_bottom).offset(CCGetRealFromPt(20));
            make.right.mas_equalTo(ws.beautifulBtn);
            make.size.mas_equalTo(ws.beautifulBtn);
        }];
        
        [_cameraChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.micChangeBtn.mas_bottom).offset(CCGetRealFromPt(20));
            make.right.mas_equalTo(ws.micChangeBtn);
            make.size.mas_equalTo(ws.micChangeBtn);
        }];
        
        [_privateChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.cameraChangeBtn.mas_bottom).offset(CCGetRealFromPt(20));
            make.right.mas_equalTo(ws.cameraChangeBtn);
            make.size.mas_equalTo(ws.cameraChangeBtn);
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(40));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(700),CCGetRealFromPt(300)));
        }];
        
        [self.view addSubview:self.contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];

        [self.contentView addSubview:self.chatTextField];
        [_chatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.left.mas_equalTo(ws.contentView).offset(CCGetRealFromPt(30));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(1134), CCGetRealFromPt(84)));
        }];

        [self.contentView addSubview:self.sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.right.mas_equalTo(ws.contentView).offset(-CCGetRealFromPt(30));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(120), CCGetRealFromPt(84)));
        }];

        self.contentView.hidden = YES;
        
        [_ccPrivateChatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(444));
            make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(444));
        }];
    }
}

-(CCPrivateChatView *)ccPrivateChatView {
    if(!_ccPrivateChatView) {
        WS(ws)
        _ccPrivateChatView = [[CCPrivateChatView alloc] initWithCloseBlock:^{
            [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws.view);
                make.height.mas_equalTo(CCGetRealFromPt(542));
                make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if(ws.ccPrivateChatView.privateChatViewForOne) {
                    [ws.ccPrivateChatView.privateChatViewForOne removeFromSuperview];
                    ws.ccPrivateChatView.privateChatViewForOne = nil;
                }
            }];
        } isResponseBlock:^(CGFloat y) {
//            NSLog(@"PushViewController isResponseBlock y = %f",y);
            if(!ws.isScreenLandScape) {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(CCGetRealFromPt(542));
                    make.bottom.mas_equalTo(ws.view).mas_offset(-y);
                }];
            } else {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(ws.view.frame.size.height-_keyboardRect.size.height);
                    make.bottom.mas_equalTo(ws.view).offset(-_keyboardRect.size.height);
                }];
            }
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        } isNotResponseBlock:^{
            if(!ws.isScreenLandScape) {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(CCGetRealFromPt(542));
                    make.bottom.mas_equalTo(ws.view);
                }];
            } else {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(CCGetRealFromPt(444));
                    make.bottom.mas_equalTo(ws.view);
                }];
            }
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }  dataPrivateDic:[self.dataPrivateDic copy] isScreenLandScape:_isScreenLandScape];
    }
    return _ccPrivateChatView;
}

-(UIView *)informationView {
    if(!_informationView) {
        _informationView = [UIView new];
        _informationView.backgroundColor = CCRGBAColor(0, 0, 0, 0.3);
        _informationView.layer.cornerRadius = CCGetRealFromPt(90) / 2;
        _informationView.layer.masksToBounds = YES;
        WS(ws)
        [_informationView addSubview:self.hostNameLabel];
        [_hostNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.informationView).offset(CCGetRealFromPt(42));
            make.top.mas_equalTo(ws.informationView).offset(CCGetRealFromPt(13));
            make.right.mas_equalTo(ws.informationView).offset(-CCGetRealFromPt(42));
            make.height.mas_equalTo(CCGetRealFromPt(26));
        }];
        [_informationView addSubview:self.userCountLabel];
        [_userCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.mas_equalTo(ws.hostNameLabel);
            make.bottom.mas_equalTo(ws.informationView).offset(-CCGetRealFromPt(13));
        }];
    }
    return _informationView;
}

-(UILabel *)hostNameLabel {
    if(!_hostNameLabel) {
        _hostNameLabel = [UILabel new];
        _hostNameLabel.font = [UIFont systemFontOfSize:FontSize_26];
        _hostNameLabel.textAlignment = NSTextAlignmentLeft;
        _hostNameLabel.textColor = [UIColor whiteColor];
        _hostNameLabel.text = [NSString stringWithFormat:@"主播：%@",GetFromUserDefaults(LIVE_USERNAME)];
    }
    return _hostNameLabel;
}

-(UILabel *)userCountLabel {
    if(!_userCountLabel) {
        _userCountLabel = [UILabel new];
        _userCountLabel.font = [UIFont systemFontOfSize:FontSize_26];
        _userCountLabel.textAlignment = NSTextAlignmentLeft;
        _userCountLabel.textColor = [UIColor whiteColor];
        _userCountLabel.text = @"在线人数：1";
    }
    return _userCountLabel;
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)preView {
    if(!_preView) {
        _preView = [UIView new];
        _preView.backgroundColor = CCClearColor;
        _preView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPress)];
        [_preView addGestureRecognizer:singleTap];
    }
    return _preView;
}

-(void)viewPress {
    [_chatTextField resignFirstResponder];
    [_ccPrivateChatView.privateChatViewForOne.chatTextField resignFirstResponder];
    WS(ws)
    
    [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.height.mas_equalTo(CCGetRealFromPt(542));
        make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(ws.ccPrivateChatView.privateChatViewForOne) {
            [ws.ccPrivateChatView.privateChatViewForOne removeFromSuperview];
            ws.ccPrivateChatView.privateChatViewForOne = nil;
        }
    }];
}

/**
 *	@brief	正在连接网络，UI不可动
 */
- (void) isConnectionNetWork {

}
/**
 *	@brief	连接网络完成
 */
- (void) connectedNetWorkFinished {

}

/**
 *	@brief	设置连接状态
 */
- (void) setConnectionStatus:(NSInteger)status {
    switch (status) {
        case 1:
            NSLog(@"正在连接");
            break;
        case 3:
            NSLog(@"已连接");
            break;
        case 5:
            NSLog(@"未连接");
            break;
        default:
            break;
    }
}

/**
 *	@brief	推流失败
 */
-(void)pushFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    [_informationViewPop removeFromSuperview];
    _informationViewPop = [[InformationShowView alloc] initWithLabel:message];
    [self.view addSubview:_informationViewPop];
    [_informationViewPop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInformationViewPop) userInfo:nil repeats:NO];
}

-(void)removeInformationViewPop {
    [_informationViewPop removeFromSuperview];
    _informationViewPop = nil;
}

-(UIButton *)publicChatBtn {
    if(!_publicChatBtn) {
        _publicChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publicChatBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_publicChatBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_chat_nor"] forState:UIControlStateNormal];
        [_publicChatBtn addTarget:self action:@selector(publicChatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publicChatBtn;
}

-(void)publicChatBtnClicked {
    [_chatTextField becomeFirstResponder];
}

-(UIButton *)myAnswerBtn {
    if(!_privateChatBtn) {
        _privateChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privateChatBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_privateChatBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_news_nor"] forState:UIControlStateNormal];
        [_privateChatBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_newsmsg_nor"] forState:UIControlStateSelected];
        [_privateChatBtn addTarget:self action:@selector(privateChatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateChatBtn;
}

-(void)privateChatBtnClicked {
    WS(ws)
    if(!self.isScreenLandScape) {
        [_ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(542));
            make.bottom.mas_equalTo(ws.view);
        }];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(UIButton *)cameraChangeBtn {
    if(!_cameraChangeBtn) {
        _cameraChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraChangeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_cameraChangeBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_camera_nor"] forState:UIControlStateNormal];
        [_cameraChangeBtn addTarget:self action:@selector(cameraChangeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraChangeBtn;
}

-(void)cameraChangeBtnClicked {
    _cameraChangeBtn.selected = !_cameraChangeBtn.selected;
    //[[CCPushUtil sharedInstanceWithDelegate:self] setCameraFront:!_cameraChangeBtn.selected];
}

-(UIButton *)micChangeBtn {
    if(!_micChangeBtn) {
        _micChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_micChangeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_micChangeBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_sound_nor"] forState:UIControlStateNormal];
        [_micChangeBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_sound_ban"] forState:UIControlStateSelected];
        [_micChangeBtn addTarget:self action:@selector(micChangeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _micChangeBtn;
}

-(void)micChangeBtnClicked {
    _micChangeBtn.selected = !_micChangeBtn.selected;
    if(_micChangeBtn.selected) {
        //[[CCPushUtil sharedInstanceWithDelegate:self] setMicGain:0];
    } else {
        //[[CCPushUtil sharedInstanceWithDelegate:self] setMicGain:10];
    }
}

-(UIButton *)beautifulBtn {
    if(!_beautifulBtn) {
        _beautifulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautifulBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_beautifulBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_beauty_ban"] forState:UIControlStateNormal];
        [_beautifulBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_beauty_nor"] forState:UIControlStateSelected];
        [_beautifulBtn addTarget:self action:@selector(beautifulBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautifulBtn;
}

-(void)beautifulBtnClicked {
    _beautifulBtn.selected = !_beautifulBtn.selected;
    if(_beautifulBtn.selected) {
        //[[CCPushUtil sharedInstanceWithDelegate:self] setCameraBeautyFilterWithSmooth:0.5 white:0.5 pink:0.5];
    } else {
        //[[CCPushUtil sharedInstanceWithDelegate:self] setCameraBeautyFilterWithSmooth:0 white:0 pink:0];
    }
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_close_nor"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(void)closeBtnClicked {
    [self.view addSubview:self.modelView];
    WS(ws)
    [_modelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
    [_modelView addSubview:self.modeoCenterView];
    [_modeoCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(!ws.isScreenLandScape) {
            make.top.mas_equalTo(ws.modelView).offset(CCGetRealFromPt(390));
        } else {
            make.centerY.mas_equalTo(ws.modelView.mas_centerY);
        }
        make.centerX.mas_equalTo(ws.modelView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(500), CCGetRealFromPt(250)));
    }];
    [_modeoCenterView addSubview:self.cancelBtn];
    [_modeoCenterView addSubview:self.sureBtn];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(ws.modeoCenterView);
        make.height.mas_equalTo(CCGetRealFromPt(100));
        make.right.mas_equalTo(ws.sureBtn.mas_left);
        make.width.mas_equalTo(ws.sureBtn.mas_width);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(ws.modeoCenterView);
        make.height.mas_equalTo(ws.cancelBtn);
        make.left.mas_equalTo(ws.cancelBtn.mas_right);
        make.width.mas_equalTo(ws.cancelBtn.mas_width);
    }];
    
    [_modelView addSubview:self.modeoCenterLabel];
    [_modeoCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(ws.modeoCenterView);
        make.bottom.mas_equalTo(ws.sureBtn.mas_top);
    }];
    
    UIView *lineCross = [UIView new];
    lineCross.backgroundColor = CCRGBColor(221,221,221);
    [_modeoCenterView addSubview:lineCross];
    [lineCross mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.modeoCenterView);
        make.bottom.mas_equalTo(ws.cancelBtn.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    UIView *lineVertical = [UIView new];
    lineVertical.backgroundColor = CCRGBColor(221,221,221);
    [_modeoCenterView addSubview:lineVertical];
    [lineVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.cancelBtn.mas_right);
        make.top.mas_equalTo(lineCross.mas_bottom);
        make.bottom.mas_equalTo(ws.cancelBtn.mas_bottom);
        make.width.mas_equalTo(1);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled=YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

-(void)sureBtnClicked {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self removeObserver];
    [self.modelView removeFromSuperview];
    [self stopTimer];
    //[[CCPushUtil sharedInstanceWithDelegate:self] stopPush];
    [self dismissViewControllerAnimated:YES completion:^ {
        
    }];
}

-(void)cancelBtnClicked {
    [self.modelView removeFromSuperview];
}

-(UILabel *)modeoCenterLabel {
    if(!_modeoCenterLabel) {
        _modeoCenterLabel = [UILabel new];
        _modeoCenterLabel.font = [UIFont systemFontOfSize:FontSize_30];
        _modeoCenterLabel.textAlignment = NSTextAlignmentCenter;
        _modeoCenterLabel.textColor = CCRGBColor(51,51,51);
        _modeoCenterLabel.text = @"您确认结束直播吗？";
    }
    return _modeoCenterLabel;
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.chatTextField resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellPush";
    
    Dialogue *dialogue = [_tableArray objectAtIndex:indexPath.row];

    WS(ws)
    CCPublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CCPublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier dialogue:dialogue antesomeone:^(NSString *antename, NSString *anteid) {
            [ws.chatTextField resignFirstResponder];
            NSMutableArray *array = [ws.dataPrivateDic objectForKey:anteid];
            
            NSString *userName = nil;
            NSRange range = [dialogue.username rangeOfString:@": "];
            if(range.location != NSNotFound) {
                userName = [dialogue.username substringToIndex:range.location];
            } else {
                userName = dialogue.username;
            }
            
            CCLog(@"111 anteid = %@",dialogue.userid);
            
            [self.ccPrivateChatView createPrivateChatViewForOne:[array copy] anteid:dialogue.userid  anteName:userName];
            [self privateChatBtnClicked];
        }];
    } else {
        [cell reloadWithDialogue:dialogue antesomeone:^(NSString *antename, NSString *anteid) {
            [ws.chatTextField resignFirstResponder];

            NSMutableArray *array = [ws.dataPrivateDic objectForKey:anteid];
            
            NSString *userName = nil;
            NSRange range = [dialogue.username rangeOfString:@": "];
            if(range.location != NSNotFound) {
                userName = [dialogue.username substringToIndex:range.location];
            } else {
                userName = dialogue.username;
            }
            
            CCLog(@"111 anteid = %@",dialogue.userid);
            
            [self.ccPrivateChatView createPrivateChatViewForOne:[array copy] anteid:dialogue.userid anteName:userName];
            [self privateChatBtnClicked];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CCGetRealFromPt(26);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, CCGetRealFromPt(26))];
    view.backgroundColor = CCClearColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dialogue *dialogue = [self.tableArray objectAtIndex:indexPath.row];
    return dialogue.msgSize.height + 10;
}

/**
 *	@brief	点击开始推流按钮，获取liveid
 */
- (void) getLiveidBeforPush:(NSString *)liveid {
//    NSLog(@"liveid = %@",liveid);
}

- (void)room_user_count:(NSString *)str {
    self.userCountLabel.text = [@"在线人数：" stringByAppendingString:str];
}

- (void)receivePublisherId:(NSString *)str onlineUsers:(NSMutableDictionary *)dict {
    //    _publisherId = str;
    //    _onlineUsers = dict;
}

- (void)stopPushSuccessful {
    //    NSLog(@"退出推流成功！");
}

- (void)on_chat_message:(NSString *)str {
//    NSLog(@"on_chat_message = %@",str);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    Dialogue *dialogue = [[Dialogue alloc] init];
    dialogue.userid = dic[@"userid"];
    dialogue.username = [dic[@"username"] stringByAppendingString:@": "];
    dialogue.userrole = dic[@"userrole"];
    dialogue.msg = dic[@"msg"];
    dialogue.time = dic[@"time"];
    dialogue.myViwerId = _viewerId;
    
    dialogue.msgSize = [self getTitleSizeByFont:[dialogue.username stringByAppendingString:dialogue.msg] width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    dialogue.userNameSize = [self getTitleSizeByFont:dialogue.username width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    [_tableArray addObject:dialogue];
    
    if([_tableArray count] >= 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            NSIndexPath *indexPathLast = [NSIndexPath indexPathForItem:([_tableArray count]-1) inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPathLast atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

- (void)on_private_chat:(NSString *)str {
//    NSLog(@"on_private_chat = %@",str);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    Dialogue *dialogue = [[Dialogue alloc] init];
    dialogue.fromuserid = dic[@"fromuserid"] ;
    dialogue.fromusername = dic[@"fromusername"];
    dialogue.fromuserrole = dic[@"fromuserrole"];
    
    dialogue.touserid = dic[@"touserid"];
    dialogue.tousername = dic[@"tousername"];
    
    dialogue.username = dialogue.fromusername;
    dialogue.userid = dialogue.fromuserid;
    
//    dialogue.msg = [[[@" 对 " stringByAppendingString:dialogue.tousername] stringByAppendingString:@": "] stringByAppendingString:dic[@"msg"]];
    dialogue.msg = dic[@"msg"];
    dialogue.time = dic[@"time"];
    dialogue.myViwerId = _viewerId;
    
    dialogue.msgSize = [self getTitleSizeByFont:[dialogue.username stringByAppendingString:dialogue.msg] width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    dialogue.userNameSize = [self getTitleSizeByFont:dialogue.username width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    NSString *anteName = nil;
    NSString *anteid = nil;
    if([dialogue.fromuserid isEqualToString:self.viewerId]) {
        anteid = dialogue.touserid;
        anteName = dialogue.tousername;
    } else {
        anteid = dialogue.fromuserid;
        anteName = dialogue.fromusername;
    }

    NSMutableArray *array = [self.dataPrivateDic objectForKey:anteid];
    if(!array) {
        array = [[NSMutableArray alloc] init];
        [self.dataPrivateDic setValue:array forKey:anteid];
    }

    [array addObject:dialogue];
    
//    [self.ccPrivateChatView updateDatas:dialogue];
    [self.ccPrivateChatView reloadDict:[self.dataPrivateDic mutableCopy] anteName:anteName anteid:anteid];
//    [self.ccPrivateChatView updateDataArray:[array copy] anteName:anteName anteid:anteid];
}

-(CGSize)getTitleSizeByFont:(NSString *)str width:(CGFloat)width font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self chatSendMessage];
    return YES;
}

-(void)chatSendMessage {
    NSString *str = _chatTextField.text;
    if(str == nil || str.length == 0) {
        return;
    }
    
    //[[CCPushUtil sharedInstanceWithDelegate:self] chatMessage:str];
    
    _chatTextField.text = nil;
    [_chatTextField resignFirstResponder];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(privateChat:)
                                                 name:@"private_Chat"
                                               object:nil];
}

- (void) privateChat:(NSNotification*) notification
{
    NSDictionary *dic = [notification object];
    
    //[[CCPushUtil sharedInstanceWithDelegate:self]privateChatWithTouserid:dic[@"anteid"] msg:dic[@"str"]];
}

-(void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"private_Chat"
                                                  object:nil];
}

#pragma mark keyboard notification
- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.chatTextField isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardRect = [aValue CGRectValue];
    CGFloat y = _keyboardRect.size.height;
    CGFloat x = _keyboardRect.size.width;
//    NSLog(@"键盘高度是  %d",(int)y);
//    NSLog(@"键盘宽度是  %d",(int)x);
    if(!self.isScreenLandScape) {
        if ([self.chatTextField isFirstResponder]) {
            self.contentBtnView.hidden = YES;
            self.contentView.hidden = NO;
            WS(ws)
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws.view);
                make.bottom.mas_equalTo(ws.view).offset(-y);
                make.height.mas_equalTo(CCGetRealFromPt(110));
            }];
            
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(ws.contentBtnView.mas_top);
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    } else {
        if ([self.chatTextField isFirstResponder]) {
            WS(ws)
            self.contentView.hidden = NO;
            
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws.view);
                make.bottom.mas_equalTo(ws.view).offset(-y);
                make.height.mas_equalTo(CCGetRealFromPt(110));
            }];

            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(ws.view).offset(-y-CCGetRealFromPt(110));
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(700),CCGetRealFromPt(300)));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    WS(ws)
    if(!self.isScreenLandScape) {
        self.contentBtnView.hidden = NO;
        self.contentView.hidden = YES;
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView.mas_top);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
        }];
    } else {
        self.contentView.hidden = YES;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(40));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(700),CCGetRealFromPt(300)));
        }];
        
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.hidden = YES;
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(UIView *)contentView {
    if(!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = CCRGBAColor(171,179,189,0.30);
    }
    return _contentView;
}

-(CustomTextField *)chatTextField {
    if(!_chatTextField) {
        _chatTextField = [CustomTextField new];
        _chatTextField.delegate = self;
        [_chatTextField addTarget:self action:@selector(chatTextFieldChange) forControlEvents:UIControlEventEditingChanged];
        _chatTextField.rightView = self.rightView;
    }
    return _chatTextField;
}

-(void)chatTextFieldChange {
    if(_chatTextField.text.length > 300) {
//        [self.view endEditing:YES];
        
        _chatTextField.text = [_chatTextField.text substringToIndex:300];
        [_informationViewPop removeFromSuperview];
        _informationViewPop = [[InformationShowView alloc] initWithLabel:@"输入限制在300个字符以内"];
        [APPDelegate.window addSubview:_informationViewPop];
        [_informationViewPop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 200, 0));
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInformationViewPop) userInfo:nil repeats:NO];
    }
}

-(UIButton *)rightView {
    if(!_rightView) {
        _rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightView.frame = CGRectMake(0, 0, CCGetRealFromPt(48), CCGetRealFromPt(48));
        _rightView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightView.backgroundColor = CCClearColor;
        [_rightView setImage:[UIImage imageNamed:@"chat_ic_face_nor"] forState:UIControlStateNormal];
        [_rightView setImage:[UIImage imageNamed:@"chat_ic_face_hov"] forState:UIControlStateSelected];
        [_rightView addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightView;
}

- (void)faceBoardClick {
    BOOL selected = !_rightView.selected;
    _rightView.selected = selected;
    
    if(selected) {
        [_chatTextField setInputView:self.emojiView];
    } else {
        [_chatTextField setInputView:nil];
    }
    
    [_chatTextField becomeFirstResponder];
    [_chatTextField reloadInputViews];
}

-(UIButton *)sendButton {
    if(!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = CCRGBColor(255,102,51);
        _sendButton.layer.cornerRadius = CCGetRealFromPt(4);
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.borderColor = [CCRGBColor(255,71,0) CGColor];
        _sendButton.layer.borderWidth = 1;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:CCRGBColor(255,255,255) forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_sendButton addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

-(void)sendBtnClicked {
    if(!StrNotEmpty([_chatTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
        [_informationViewPop removeFromSuperview];
        _informationViewPop = [[InformationShowView alloc] initWithLabel:@"发送内容为空"];
        [APPDelegate.window addSubview:_informationViewPop];
        [_informationViewPop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 200, 0));
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInformationViewPop) userInfo:nil repeats:NO];
        return;
    }
    [self chatSendMessage];
    _chatTextField.text = nil;
    [_chatTextField resignFirstResponder];
}

-(UIImageView *)contentBtnView {
    if(!_contentBtnView) {
        _contentBtnView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
        _contentBtnView.userInteractionEnabled = YES;
        _contentBtnView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentBtnView;
}

-(UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.backgroundColor = [UIColor grayColor];
    }
    return _tableView;
}

-(NSMutableArray *)tableArray {
    if(!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}

-(UIView *)emojiView {
    if(!_emojiView) {
        if(_keyboardRect.size.width == 0 || _keyboardRect.size.height ==0) {
            _keyboardRect = CGRectMake(0, 0, 414, 271);
        }
        _emojiView = [[UIView alloc] initWithFrame:_keyboardRect];
        _emojiView.backgroundColor = CCRGBColor(242,239,237);

        CGFloat faceIconSize = CCGetRealFromPt(60);
        CGFloat xspace = (_keyboardRect.size.width - FACE_COUNT_CLU * faceIconSize) / (FACE_COUNT_CLU + 1);
        CGFloat yspace = (_keyboardRect.size.height - 26 - FACE_COUNT_ROW * faceIconSize) / (FACE_COUNT_ROW + 1);
        
        for (int i = 0; i < FACE_COUNT_ALL; i++) {
            UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.tag = i + 1;
            
            [faceButton addTarget:self action:@selector(faceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (i % FACE_COUNT_CLU + 1) * xspace + (i % FACE_COUNT_CLU) * faceIconSize;
            CGFloat y = (i / FACE_COUNT_CLU + 1) * yspace + (i / FACE_COUNT_CLU) * faceIconSize;
            
            faceButton.frame = CGRectMake(x, y, faceIconSize, faceIconSize);
            faceButton.backgroundColor = CCClearColor;
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%02d", i+1]]
                        forState:UIControlStateNormal];
            faceButton.contentMode = UIViewContentModeScaleAspectFit;
            [_emojiView addSubview:faceButton];
        }
        //删除键
        UIButton *button14 = (UIButton *)[_emojiView viewWithTag:14];
        UIButton *button20 = (UIButton *)[_emojiView viewWithTag:20];
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.contentMode = UIViewContentModeScaleAspectFit;
        [back setImage:[UIImage imageNamed:@"chat_btn_facedel"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        [_emojiView addSubview:back];
        
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button14);
            make.centerY.mas_equalTo(button20);
        }];
    }
    return _emojiView;
}

- (void) backFace {
    NSString *inputString = _chatTextField.text;
    if ( [inputString length] > 0) {
        NSString *string = nil;
        NSInteger stringLength = [inputString length];
        if (stringLength >= FACE_NAME_LEN) {
            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
            if ( range.location == 0 ) {
                string = [inputString substringToIndex:[inputString rangeOfString:FACE_NAME_HEAD options:NSBackwardsSearch].location];
            } else {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            string = [inputString substringToIndex:stringLength - 1];
        }
        _chatTextField.text = string;
    }
}

- (void)faceButtonClicked:(id)sender {
    NSInteger i = ((UIButton*)sender).tag;
    
    NSMutableString *faceString = [[NSMutableString alloc]initWithString:_chatTextField.text];
    [faceString appendString:[NSString stringWithFormat:@"[em2_%02d]",(int)i]];
    _chatTextField.text = faceString;
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

//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    if(self.isScreenLandScape){
//        bool bRet = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft));
//        return bRet;
//    }else{
//        return false;
//    }
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if(self.isScreenLandScape){
//        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

@end


