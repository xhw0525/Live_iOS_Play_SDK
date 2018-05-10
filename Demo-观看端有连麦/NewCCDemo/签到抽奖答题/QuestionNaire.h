//
//  QuestionNaire.h
//  NewCCDemo
//
//  Created by ubuntu on 2018/3/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseBtnClicked)();

@interface QuestionNaire : UIView

-(instancetype) initWithTitle:(NSString *)title url:(NSString *)url isScreenLandScape:(BOOL)isScreenLandScape closeblock:(CloseBtnClicked)closeblock ;

@end
