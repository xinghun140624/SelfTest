//
//  CTMediator+HCShareBusiness.m
//  HCShareBusiness_Category
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCShareBusiness.h"

@implementation CTMediator (HCShareBusiness)
- (UIViewController *)HCShareBusiness_shareControllerWithType:(NSInteger)type ShareButtonClickCallBack:(blockCallBack)shareButtonClickCallBack {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (shareButtonClickCallBack) {
        params[@"shareButtonClickCallBack"] = shareButtonClickCallBack;
        params[@"shareType"] = @(type);
    }
    
    return [self performTarget:@"HCShareBusiness" action:@"shareController" params:params shouldCacheTarget:NO];
}
@end
