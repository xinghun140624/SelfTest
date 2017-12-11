//
//  HCBannerModel.h
//  HongCai
//
//  Created by Candy on 2017/6/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCBannerModel : NSObject<YYModel>
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSNumber *bannerId;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic, assign) BOOL        isShow;
@property (nonatomic,   copy) NSString *linkUrl;
@property (nonatomic, strong) NSNumber *sortNo;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;


@end
