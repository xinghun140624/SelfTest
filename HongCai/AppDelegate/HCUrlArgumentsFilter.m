//
//  HCUrlArgumentsFilter.m
//  HongCai
//
//  Created by Candy on 2017/7/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUrlArgumentsFilter.h"
#import "AFURLRequestSerialization.h"

@implementation HCUrlArgumentsFilter
 {
    NSDictionary *_arguments;
}

+ (HCUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return [self urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}

- (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *paraUrlString = AFQueryStringFromParameters(parameters);
    
    if (!(paraUrlString.length > 0)) {
        return originUrlString;
    }

    NSURLComponents *components = [NSURLComponents componentsWithString:originUrlString];
    NSString *queryString = components.query ?: @"";
    NSString *newQueryString = [queryString stringByAppendingFormat:queryString.length > 0 ? @"&%@" : @"%@", paraUrlString];
    
    components.query = newQueryString;
    
    return components.URL.absoluteString;

}

@end
