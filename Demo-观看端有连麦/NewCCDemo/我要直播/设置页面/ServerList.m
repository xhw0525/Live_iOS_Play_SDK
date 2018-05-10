//
//  ServerList.m
//  NewCCDemo
//
//  Created by cc on 2016/11/28.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "ServerList.h"
#import "ServerChildItem.h"
//#import "CCPush/CCPushUtil.h"
#import "LoadingView.h"

@interface ServerList ()

@property(nonatomic,strong)UILabel                      *informationLabel;
@property(nonatomic,strong)NSMutableArray               *array;
@property(nonatomic,strong)UIBarButtonItem              *rightBarBtn;
@property(nonatomic,strong)LoadingView                  *loadingView;

@end

@implementation ServerList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.informationLabel];
    self.navigationItem.rightBarButtonItem=self.rightBarBtn;
    WS(ws);
    [_informationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
        make.top.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
        make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(CCGetRealFromPt(24));
    }];
    
    NSArray *arr = [self.dic allKeys];
    ServerChildItem *lastServer = nil;
    for (NSInteger i = 0; i < arr.count; i++) {
        ServerChildItem *server = [ServerChildItem new];
        [self.array addObject:server];
        WS(ws)
        int index = [GetFromUserDefaults(SET_SERVER_INDEX) intValue];
        [server settingWithLineLong:(i==0) leftText:arr[i] rightText:self.dic[arr[i]][@"time"] selected:(i==index) block:^{
            for (ServerChildItem *obj in self.array) {
                if(obj == server) {
                    obj.leftBtn.selected = YES;
                    NSInteger index = [self.array indexOfObject:obj];
                    SaveToUserDefaults(SET_SERVER_INDEX,[NSNumber numberWithInteger:index]);
                    //[[CCPushUtil sharedInstanceWithDelegate:self] setNodeIndex:index];
                } else {
                    obj.leftBtn.selected = NO;
                }
                [ws.navigationController popViewControllerAnimated:NO];
            }
        }];
        [self.view addSubview:server];
        
        if(i == 0) {
            [server mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(ws.view);
                make.top.mas_equalTo(ws.informationLabel.mas_bottom).with.offset(CCGetRealFromPt(22));
                make.height.mas_equalTo(CCGetRealFromPt(92));
            }];
        } else {
            [server mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(lastServer);
                make.top.mas_equalTo(lastServer.mas_bottom);
                make.height.mas_equalTo(lastServer.mas_height);
            }];
        }
        lastServer = server;
    }
    
    UIView *line = [UIView new];
    [self.view addSubview:line];
    [line setBackgroundColor:CCRGBColor(238,238,238)];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(lastServer.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

-(UIBarButtonItem *)rightBarBtn {
    if(_rightBarBtn == nil) {
        _rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"测速" style:UIBarButtonItemStylePlain target:self action:@selector(onSelectTestSpeed)];
        [_rightBarBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:FontSize_30],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
    return _rightBarBtn;
}

-(void)onSelectTestSpeed {
    _loadingView = [[LoadingView alloc] initWithLabel:@"测速中..." centerY:NO];
    [self.view addSubview:_loadingView];
    
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_loadingView layoutIfNeeded];
    //[[CCPushUtil sharedInstanceWithDelegate:self]testSpeed];
}

/**
 *	@brief	返回节点列表，节点测速时间，以及最优点索引(从0开始，如果无最优点，随机获取节点当作最优节点)
 */
- (void) nodeListDic:(NSMutableDictionary*)dic bestNodeIndex:(NSInteger)index {
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    NSArray *arr = [dic allKeys];
    for (NSInteger i = 0; i < arr.count; i++) {
        for(NSInteger j = 0;j < self.array.count;j++) {
            ServerChildItem *server = (ServerChildItem *)[self.array objectAtIndex:j];
            if([arr[i] isEqualToString:server.leftLabel.text]) {
                server.rightLabel.text = dic[arr[i]][@"time"];
                server.leftBtn.selected = (i==index);
                SaveToUserDefaults(SET_SERVER_INDEX,[NSNumber numberWithInteger:index]);
                //[[CCPushUtil sharedInstanceWithDelegate:self] setNodeIndex:index];
            }
        }
    }
}

-(NSMutableArray *)array {
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

-(UILabel *)informationLabel {
    if(_informationLabel == nil) {
        _informationLabel = [UILabel new];
        [_informationLabel setBackgroundColor:CCRGBColor(250, 250, 250)];
        [_informationLabel setFont:[UIFont systemFontOfSize:FontSize_24]];
        [_informationLabel setTextColor:CCRGBColor(102, 102, 102)];
        [_informationLabel setTextAlignment:NSTextAlignmentLeft];
        [_informationLabel setText:@"选择服务器"];
    }
    return _informationLabel;
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
