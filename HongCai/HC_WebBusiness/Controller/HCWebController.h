//
//  HCWebController.h
//  HC_WebBusiness
//
//  Created by Candy on 2017/6/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "AXWebViewController.h"

#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

@interface HCWebController : AXWebViewController
@property (nonatomic, strong) WKWebViewJavascriptBridge *webViewJavascriptBridge;
@property (nonatomic, copy) NSString * rightBarButtonTitle;
@end
