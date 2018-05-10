//
//  LotteryView.m
//  NewCCDemo
//
//  Created by cc on 2017/1/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "QuestionnaireSurveyPopUp.h"
#import "UIImage+GIF.h"

//问卷弹窗
@interface QuestionnaireSurveyPopUp()

@property(nonatomic,strong)UIButton                 *sureBtn;
@property(nonatomic,strong)UIView                   *view;
@property(nonatomic,strong)UILabel                  *label;
@property(nonatomic,assign)BOOL                     isScreenLandScape;
@property(nonatomic,copy)  SureBtnBlock             sureBtnBlock;

@end

@implementation QuestionnaireSurveyPopUp

-(instancetype)initIsScreenLandScape:(BOOL)isScreenLandScape SureBtnBlock:(SureBtnBlock)sureBtnBlock {
    self = [super init];
    if(self) {
        self.isScreenLandScape  = isScreenLandScape;
        self.sureBtnBlock       = sureBtnBlock;
        [self initUI];
    }
    return self;
}

-(void)initUI {
    WS(ws)
    self.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
    _view = [[UIView alloc]init];
    _view.backgroundColor = [UIColor whiteColor];
    _view.layer.cornerRadius = CCGetRealFromPt(8);
    [self addSubview:_view];
    
    if(!self.isScreenLandScape) {
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws).offset(CCGetRealFromPt(70));
            make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(70));
            make.top.mas_equalTo(ws).offset(CCGetRealFromPt(470));
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(534));
        }];
    } else {
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws).offset(CCGetRealFromPt(362));
            make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(362));
            make.top.mas_equalTo(ws).offset(CCGetRealFromPt(210));
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(210));
        }];
    }
    
    [_view addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view);
        make.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.view);
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(122));
    }];
    
    [_view addSubview:self.sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(165));
        make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(165));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(200));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(50));
    }];
}

-(UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = @"问卷已停止回收，点击确定后关闭问卷";
        _label.textColor = CCRGBColor(51,51,51);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize_28];
    }
    return _label;
}

-(UIButton *)sureBtn {
    if(_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = CCRGBColor(255,102,51);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_sureBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_sureBtn.layer setMasksToBounds:YES];
        [_sureBtn.layer setBorderWidth:2.0];
        [_sureBtn.layer setBorderColor:[CCRGBColor(252,92,61) CGColor]];
        [_sureBtn.layer setCornerRadius:CCGetRealFromPt(6)];
        [_sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_sureBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255,102,51)] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[self createImageWithColor:CCRGBAColor(255,102,51,0.4)] forState:UIControlStateHighlighted];
    }
    return _sureBtn;
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

-(void)sureBtnClicked {
    if(self.sureBtnBlock) {
        self.sureBtnBlock();
    }
}

@end



