//
//  HCActivityModel.h
//  HongCai
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface HCActivityModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, copy) NSString * linkUrl;
@property (nonatomic, assign) NSInteger openSite;
@property (nonatomic, assign) NSInteger shareId;
@property (nonatomic, assign) NSInteger sortNo;
@property (nonatomic, strong) NSString * title;
@end
