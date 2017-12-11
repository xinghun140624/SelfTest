//
//  HCMemberCenterHeaderView.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCMemberInfoModel;
@class HCAccountModel;
#import "HCMemberCenterController.h"
@interface HCMemberCenterHeaderView : UIView
@property (nonatomic,   weak) HCMemberCenterController * centerController;
@property (nonatomic, strong) HCMemberInfoModel * memberInfoModel;
@property (nonatomic, strong) HCAccountModel * accountModel;
@property (nonatomic,   copy) NSString * userName;
@property (nonatomic,   copy) void(^raiseButtonClickCallBack)(void);
@property (nonatomic,   copy) void(^helpButtonClickCallBack)(void);
@end
