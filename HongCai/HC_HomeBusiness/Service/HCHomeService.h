//
//  HCHomeService.h
//  HongCai
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HCActivityModel;

@interface HCHomeService : NSObject
+ (void)getUserShowNewUserFloat:(void(^)(BOOL isAppear))isAppear;

+ (void)getHomeProjectData:(void(^)(NSArray * projectModels))projectModels errorMessage:(void(^)(NSString *errorMessage))errorMessage;

+ (void)getHomeData:(void(^)(NSArray *bannerModels,NSArray *noticeModels,NSArray *activiyModels,NSArray *projectModels,HCActivityModel * activityRemindingModel))homeData errorMessage:(void(^)(NSString *errorMessage))errorMessage;
+ (void)getUpdateSystemVersion:(UIViewController *)controller;
@end
