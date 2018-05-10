//
//  QuestionNaire.m
//  NewCCDemo
//
//  Created by ubuntu on 2018/3/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "QuestionNaire.h"

@interface QuestionNaire()

@property(nonatomic,strong)UIImageView              *questionImage;
@property(nonatomic,strong)UIView                   *bgView;
@property(nonatomic,strong)UILabel                  *label;
@property(nonatomic,strong)UIView                   *lineView;
@property(nonatomic,strong)UIButton                 *closeBtn;
@property(nonatomic,strong)UILabel                  *centerLabel;

@property(nonatomic,copy) NSString                  *title;
@property(nonatomic,copy) NSString                  *url;
@property(nonatomic,assign)BOOL                     isScreenLandScape;
@property(nonatomic,strong)UIView                   *view;
@property(nonatomic,strong)UIButton                 *submitBtn;
@property(nonatomic,copy)  CloseBtnClicked          closeblock;

@end

@implementation QuestionNaire

-(instancetype) initWithTitle:(NSString *)title url:(NSString *)url isScreenLandScape:(BOOL)isScreenLandScape closeblock:(CloseBtnClicked)closeblock {
    self = [super init];
    if(self) {
        self.isScreenLandScape  = isScreenLandScape;
        self.url                = url;
        self.title              = title;
        self.closeblock         = closeblock;
        [self initUI];
    }
    return self;
}

-(void)initUI {
    WS(ws)
    self.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
    
    _view = [[UIView alloc]init];
    _view.backgroundColor = CCRGBColor(255,81,44);
    _view.layer.cornerRadius = CCGetRealFromPt(6);
    [self addSubview:_view];
    if(!self.isScreenLandScape) {
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws).offset(CCGetRealFromPt(75));
            make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(75));
            make.top.mas_equalTo(ws).offset(CCGetRealFromPt(668));
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(166));
        }];
    } else {
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws).offset(CCGetRealFromPt(367));
            make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(367));
            make.top.mas_equalTo(ws).offset(CCGetRealFromPt(156));
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(94));
        }];
    }
    
    self.bgView = [UIView new];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    self.bgView.layer.cornerRadius = CCGetRealFromPt(6);
    [_view addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(1);
        make.top.mas_equalTo(ws.view).offset(1);
        make.right.mas_equalTo(ws.view).offset(-1);
        make.bottom.mas_equalTo(ws.view).offset(-(1 + CCGetRealFromPt(4)));
    }];
    
    [self.bgView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(70));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(80));
        make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(26));
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView addSubview:self.questionImage];
    [_questionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.bgView);
        make.bottom.mas_equalTo(ws.view.mas_top).offset(CCGetRealFromPt(54));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(110), CCGetRealFromPt(110)));
    }];
    
    [self.bgView addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.bgView);//.offset(CCGetRealFromPt(0));
        make.right.mas_equalTo(ws.bgView);//.offset(-CCGetRealFromPt(0));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80), CCGetRealFromPt(80)));
    }];
    
    [self.bgView addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.bgView);
        make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(66));
        make.height.mas_equalTo(CCGetRealFromPt(36));
    }];
    
    float textMaxWidth = self.isScreenLandScape? CCGetRealFromPt(640) : CCGetRealFromPt(540);
    NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc] initWithString:_title];
    [textAttri addAttribute:NSForegroundColorAttributeName value:CCRGBColor(51,51,51) range:NSMakeRange(0, textAttri.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = CCGetRealFromPt(20);
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize_26],NSParagraphStyleAttributeName:style};
    [textAttri addAttributes:dict range:NSMakeRange(0, textAttri.length)];
    
    CGSize textSize = [textAttri boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                              context:nil].size;
    textSize.width = ceilf(textSize.width);
    textSize.height = ceilf(textSize.height);
    
    [self.bgView addSubview:self.centerLabel];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(30));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(30));
        make.top.mas_equalTo(ws.label.mas_bottom).offset(CCGetRealFromPt(50));
        make.height.mas_equalTo(textSize.height);
    }];
    
    [self.bgView addSubview:self.submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(160));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(160));
        make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(50));
        make.height.mas_equalTo(CCGetRealFromPt(80));
    }];

    [self layoutIfNeeded];
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = CCClearColor;
        _closeBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"qs_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

-(UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = @"问卷调查";
        _label.textColor = CCRGBColor(51,51,51);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize_36];
    }
    return _label;
}

-(UILabel *)centerLabel {
    if(!_centerLabel) {
        NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc] initWithString:_title];
        [textAttri addAttribute:NSForegroundColorAttributeName value:CCRGBColor(51,51,51) range:NSMakeRange(0, textAttri.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = CCGetRealFromPt(20);
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize_26],NSParagraphStyleAttributeName:style};
        [textAttri addAttributes:dict range:NSMakeRange(0, textAttri.length)];

        _centerLabel = [UILabel new];
        _centerLabel.attributedText = textAttri;
        _centerLabel.numberOfLines = 0;
        _centerLabel.backgroundColor = CCClearColor;
        _centerLabel.textColor = CCRGBColor(51,51,51);
        _centerLabel.userInteractionEnabled = NO;
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:FontSize_26];
    }
    return _centerLabel;
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

-(UIView *)lineView {
    if(!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CCRGBAColor(255,102,51,0.5);
    }
    return _lineView;
}

-(UIImageView *)questionImage {
    if(!_questionImage) {
        _questionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_pic_nav"]];
        _questionImage.backgroundColor = CCClearColor;
        _questionImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _questionImage;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return;
}

-(UIButton *)submitBtn {
    if(_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"打开问卷" forState:UIControlStateNormal];
        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_submitBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255,102,51)] forState:UIControlStateNormal];
        [_submitBtn.layer setMasksToBounds:YES];
        [_submitBtn.layer setCornerRadius:CCGetRealFromPt(6)];
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(void)submitBtnClicked {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
}

-(void)closeBtnClicked {
    if(self.closeblock) {
        self.closeblock();
    }
}

@end
