//
//  HCMemberInfoModel.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "HCUserMemberModel.h"
@interface HCMemberInfoModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) HCUserMemberModel * currentLevel;
@property (nonatomic, strong) HCUserMemberModel * nextLevel;
@end
