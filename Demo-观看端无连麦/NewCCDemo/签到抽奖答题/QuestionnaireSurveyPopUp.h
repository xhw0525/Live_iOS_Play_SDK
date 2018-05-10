//
//  QuestionnaireSurveyPopUp.h
//  NewCCDemo
//
//  Created by cc on 2017/8/16.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBtnBlock)();

@interface QuestionnaireSurveyPopUp : UIView

-(instancetype)initIsScreenLandScape:(BOOL)isScreenLandScape SureBtnBlock:(SureBtnBlock)sureBtnBlock;

@end
