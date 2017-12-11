//
//  HCUserMessageModel.h
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCUserMessageModel : NSObject<YYModel>
@property (nonatomic, copy  ) NSString * content;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic, strong) NSNumber * messageId;
@property (nonatomic, strong) NSNumber * msgId;
@property (nonatomic, assign) BOOL readableMsg;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, copy  ) NSString * title;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, strong) NSNumber * userId;
@end
