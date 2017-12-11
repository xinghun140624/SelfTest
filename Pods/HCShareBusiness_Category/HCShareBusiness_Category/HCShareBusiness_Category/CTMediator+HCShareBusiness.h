//
//  CTMediator+HCShareBusiness.h
//  HCShareBusiness_Category
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HCShareBusinessType) {
    HCShareBusinessTypeWeChat = 0,
    HCShareBusinessTypeTimeLine,
    HCShareBusinessTypeQQ,
    HCShareBusinessTypeCopy,
    HCShareBusinessTypeOther
} NS_ENUM_AVAILABLE_IOS(8_0);

typedef void(^blockCallBack)(NSDictionary * info);

@interface CTMediator (HCShareBusiness)
- (UIViewController *)HCShareBusiness_shareControllerWithType:(NSInteger)type ShareButtonClickCallBack:(blockCallBack)shareButtonClickCallBack;

@end
