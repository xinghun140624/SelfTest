//
//  HCProjectModel.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "HCProjectSubModel.h"

@interface HCProjectModel : NSObject<YYModel>
@property (nonatomic, strong) NSArray <HCProjectSubModel *>*projectList;
@property (nonatomic, strong) NSNumber *pageCount;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSNumber *serverTime;
@property (nonatomic, strong) NSDictionary *projectStatusMap;
@end
