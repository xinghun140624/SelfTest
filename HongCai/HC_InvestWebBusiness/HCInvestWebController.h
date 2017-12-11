//
//  HCInvestWebController.h
//  HongCai
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "AXWebViewController.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <GrowingIO/Growing.h>

@interface HCInvestWebController : UIViewController
@property (nonatomic, strong) WebViewJavascriptBridge *webViewJavascriptBridge;
@property (nonatomic, strong) NSString *projectNumber;
@property (nonatomic, strong) NSString * webTitle;
- (instancetype)initWithAddress:(NSString *)address;

@end
