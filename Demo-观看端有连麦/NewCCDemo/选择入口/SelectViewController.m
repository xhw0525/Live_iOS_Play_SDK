//
//  SelectViewController.m
//  NewCCDemo
//
//  Created by cc on 2016/11/21.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "SelectViewController.h"
#import "UIButtonImageLabel.h"
#import "LiveViewController.h"
#import "PlayBackViewController.h"
#import "PlayViewController.h"

@interface SelectViewController ()

@property(nonatomic,strong)UIButtonImageLabel       *playBtn;
@property(nonatomic,strong)UIButtonImageLabel       *playBackBtn;
@property(nonatomic,strong)UIButtonImageLabel       *liveBtn;
@property(nonatomic,strong)UILabel                  *versionLabel;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.view addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(gotoPlayViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBackBtn];
    [self.playBackBtn addTarget:self action:@selector(gotoPlayBackViewController:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.liveBtn];
//    [self.liveBtn addTarget:self action:@selector(gotoLiveViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.versionLabel];
}

-(void)gotoPlayViewController:(UIButton *)sender {
    PlayViewController * playViewController = [[PlayViewController alloc] init];
    [self.navigationController pushViewController:playViewController animated:YES];
}

-(void)gotoPlayBackViewController:(UIButton *)sender {
    PlayBackViewController * playBackViewController = [[PlayBackViewController alloc] init];
    [self.navigationController pushViewController:playBackViewController animated:YES];
}

-(void)gotoLiveViewController:(UIButton *)sender {
    LiveViewController * liveViewController = [[LiveViewController alloc] init];
    [self.navigationController pushViewController:liveViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NavigationBarHiddenYES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NavigationBarHiddenNO;
}

-(UIButtonImageLabel *)liveBtn {
    if(_liveBtn == nil) {
        _liveBtn = [UIButtonImageLabel buttonImage:@"default_ic_go_nor" Label:@"我要直播" frame:CGRectMake(CCGetRealFromPt(125), CCGetRealFromPt(668), CCGetRealFromPt(500), CCGetRealFromPt(100))];
    }
    return _liveBtn;
}

-(UIButtonImageLabel *)playBtn {
    if(_playBtn == nil) {
        _playBtn = [UIButtonImageLabel buttonImage:@"default_ic_go_nor" Label:@"观看直播" frame:CGRectMake(CCGetRealFromPt(125), CCGetRealFromPt(718), CCGetRealFromPt(500), CCGetRealFromPt(100))];
    }
    return _playBtn;
}

-(UIButtonImageLabel *)playBackBtn {
    if(_playBackBtn == nil) {
        _playBackBtn = [UIButtonImageLabel buttonImage:@"default_ic_go_nor" Label:@"观看回放" frame:CGRectMake(CCGetRealFromPt(125), CCGetRealFromPt(868),CCGetRealFromPt(500), CCGetRealFromPt(100))];
    }
    return _playBackBtn;
}

-(UILabel *)versionLabel {
    if(_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CCGetRealFromPt(344), CCGetRealFromPt(1252),CCGetRealFromPt(60), CCGetRealFromPt(40))];
        [_versionLabel setBackgroundColor:CCRGBColor(248, 248, 248)];
        [_versionLabel setTextColor:CCRGBColor(221, 221, 221)];
        [_versionLabel setFont:[UIFont systemFontOfSize:FontSize_24]];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        [_versionLabel setText:@"v1.0"];
    }
    return _versionLabel;
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
