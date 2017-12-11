//
//  HCUrlArgumentsFilter.h
//  HongCai
//
//  Created by Candy on 2017/7/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"
@interface HCUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>
+ (HCUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;
@end
