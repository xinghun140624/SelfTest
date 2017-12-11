//
//  HCNoticeModel.h
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface HCNoticeModel : NSObject<YYModel>
@property (nonatomic, copy  ) NSString * content;
@property (nonatomic, copy  ) NSString * author;
@property (nonatomic, copy  ) NSString * image;
@property (nonatomic, copy  ) NSString * source;
@property (nonatomic, copy  ) NSString * title;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, strong) NSNumber * noticeId;
@property (nonatomic, strong) NSNumber * category;
@end
