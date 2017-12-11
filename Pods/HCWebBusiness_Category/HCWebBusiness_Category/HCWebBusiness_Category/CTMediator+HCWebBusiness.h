//
//  CTMediator+HCWebBusiness.h
//  HCWebBusiness_Category
//
//  Created by Candy on 2017/6/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>


extern NSString  const* HCWebBusinessNavigationType;//默认是0 取值范围 0 or 1
extern NSString  const* HCWebBusinessUrlKey;
extern NSString  const* HCNavigationItemKey;

@interface CTMediator (HCWebBusiness)
- (UIViewController *)HCWebBusiness_viewController:(NSDictionary *)params;

@end
