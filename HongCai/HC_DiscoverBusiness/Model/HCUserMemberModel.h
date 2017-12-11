//
//  HCUserMemberModel.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YYModel/YYModel.h>

@interface HCUserMemberModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger userMemberId;
@property (nonatomic,   copy) NSString * name;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger levelProtection;
@property (nonatomic, assign) double  minInvestAmount;
@property (nonatomic, assign) double  maxInvestAmount;
@property (nonatomic,   copy) NSString * imageUrl;
@end
