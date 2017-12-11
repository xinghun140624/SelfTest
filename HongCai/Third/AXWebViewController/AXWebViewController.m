//
//  AXWebViewController.m
//  AXWebViewController
//
//  Created by ai on 15/12/22.
//  Copyright © 2015年 devedbox. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "AXWebViewController.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@interface HCWebButton : UIButton

@end

@implementation HCWebButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}


@end
@interface AXWebViewController ()
{
    BOOL _loading;
    UIBarButtonItem * __weak _doneItem;
    
    NSString *_HTMLString;
    NSURL *_baseURL;
    WKWebViewConfiguration *_configuration;
    
    WKWebViewDidReceiveAuthenticationChallengeHandler _challengeHandler;
    AXSecurityPolicy *_securityPolicy;
    NSURLRequest *_request;
    
    
    
}


/// Back bar button item of tool bar.
@property(strong, nonatomic) UIBarButtonItem *backBarButtonItem;
/// Forward bar button item of tool bar.
@property(strong, nonatomic) UIBarButtonItem *forwardBarButtonItem;
/// Refresh bar button item of tool bar.
@property(strong, nonatomic) UIBarButtonItem *refreshBarButtonItem;
/// Stop bar button item of tool bar.
@property(strong, nonatomic) UIBarButtonItem *stopBarButtonItem;
/// Action bar button item of tool bar.
@property(strong, nonatomic) UIBarButtonItem *actionBarButtonItem;
/// URL from label.
@property(strong, nonatomic) UILabel *backgroundLabel;
@property (nonatomic, strong) UILabel * titleView;
@end

@interface UIProgressView (WebKit)
/// Hidden when progress approach 1.0 Default is NO.
@property(assign, nonatomic) BOOL ax_hiddenWhenProgressApproachFullSize;
/// The web view controller.
@property(strong, nonatomic) AXWebViewController *ax_webViewController;
@end

@interface AXWebViewController ()
/// Current web view url navigation.
@property(strong, nonatomic) WKNavigation *navigation;
/// Progress view.
@property(strong, nonatomic) UIProgressView *progressView;
/// Container view.
@property(readonly, nonatomic) UIView *containerView;
@end

@interface _AXWebContainerView: UIView { dispatch_block_t _hitBlock; } @end
@interface _AXWebContainerView (HitTests)
@property(copy, nonatomic) dispatch_block_t hitBlock;
@end
@implementation _AXWebContainerView
- (dispatch_block_t)hitBlock { return _hitBlock; } - (void)setHitBlock:(dispatch_block_t)hitBlock { _hitBlock = [hitBlock copy]; }
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // if (_hitBlock != NULL) _hitBlock();
    // id view = [super hitTest:point withEvent:event];
    // if ([view isKindOfClass:NSClassFromString(@"WKCompositingView")]) {
    //     NSLog(@"View: %@", view);
    // }
    return [super hitTest:point withEvent:event];
}
@end

/// Tag value for container view.
static NSUInteger const kContainerViewTag = 0x893147;

static NSUInteger const _kiOS8_0 = 8000;
static NSUInteger const _kiOS9_0 = 9000;
static NSUInteger const _kiOS10_0 = 10000;

#ifndef kAX_WEB_VIEW_CONTROLLER_DEBUG_LOGGING
#define kAX_WEB_VIEW_CONTROLLER_DEBUG_LOGGING 0
#endif

#ifndef kAX_WEB_VIEW_CONTROLLER_USING_NUMBER_COMPARING
#define kAX_WEB_VIEW_CONTROLLER_USING_NUMBER_COMPARING 1
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
static inline BOOL AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(NSUInteger plfm) {
    NSString *systemVersion = [[UIDevice currentDevice].systemVersion copy];
    NSArray *comp = [systemVersion componentsSeparatedByString:@"."];
    if (comp.count == 0 || comp.count == 1) {
        systemVersion = [NSString stringWithFormat:@"%@.0.0", systemVersion];
    } else if (comp.count == 2) {
        systemVersion = [NSString stringWithFormat:@"%@.0", systemVersion];
    }
#if kAX_WEB_VIEW_CONTROLLER_USING_NUMBER_COMPARING
    NSString *currentSystemVersion = [systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSUInteger currentSysVe = [[NSString stringWithFormat:@"%.5ld", (long)[currentSystemVersion integerValue]*10] integerValue];
    NSUInteger platform = [[NSString stringWithFormat:@"%.5ld", (unsigned long)plfm] integerValue];
#if kAX_WEB_VIEW_CONTROLLER_DEBUG_LOGGING
    // Log for the versions.
    NSLog(@"CurrentSysVe: %@", @(currentSysVe));
    NSLog(@"Platform: %@", @(platform));
#endif
    return currentSysVe >= platform;
#else
    NSString *plat = [NSString stringWithFormat:@"%@.0.0", @(plfm/1000)];
    NSComparisonResult result = [systemVersion compare:plat options:NSNumericSearch];
    return result == NSOrderedSame || result == NSOrderedDescending;
#endif
}

static inline BOOL AX_WEB_VIEW_CONTROLLER_NEED_USING_WEB_KIT() {
    return AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS8_0);
}

static inline BOOL AX_WEB_VIEW_CONTROLLER_NOT_USING_WEB_KIT() {
    return !AX_WEB_VIEW_CONTROLLER_NEED_USING_WEB_KIT();
}

BOOL AX_WEB_VIEW_CONTROLLER_iOS8_0_AVAILABLE() { return AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS8_0); }
BOOL AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE() { return AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS9_0); }
BOOL AX_WEB_VIEW_CONTROLLER_iOS10_0_AVAILABLE() { return AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS10_0); }

#pragma clang diagnostic pop

@implementation AXWebViewController
#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    // Set up default values.
    _showsToolBar = YES;
    _showsBackgroundLabel = YES;
    _maxAllowedTitleLength = 10;
    /*
    #if !AX_WEB_VIEW_CONTROLLER_USING_WEBKIT
        _timeoutInternal = 30.0;
        _cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    #endif

    #if AX_WEB_VIEW_CONTROLLER_USING_WEBKIT
        // Change auto just scroll view insets to NO to fix issue: https://github.com/devedbox/AXWebViewController/issues/10
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        // Using contraints to view instead of bottom layout guide.
        // self.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight;
    #endif
    */
    if (AX_WEB_VIEW_CONTROLLER_NEED_USING_WEB_KIT()) {
        // Change auto just scroll view insets to NO to fix issue: https://github.com/devedbox/AXWebViewController/issues/10
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        /* Using contraints to view instead of bottom layout guide.
         self.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight;
         */
    } else {
        _timeoutInternal = 30.0;
        _cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    }
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    if(self = [self init]) {
        _URL = pageURL;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
    if (self = [self init]) {
        _request = request;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL configuration:(WKWebViewConfiguration *)configuration {
    if (self = [self initWithURL:URL]) {
        _configuration = configuration;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request configuration:(WKWebViewConfiguration *)configuration {
    if (self = [self initWithRequest:request]) {
        _request = request;
        _configuration = configuration;
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    if (self = [self init]) {
        _HTMLString = HTMLString;
        _baseURL = baseURL;
    }
    return self;
}
- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    [self setupSubviews];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self.URL
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    NSString *param1 = [self valueForKey:@"navigationTranslucent"
                          fromQueryItems:queryItems];
    if (param1) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }else {
        [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"0xff611d"]] forBarMetrics:UIBarMetricsDefault];

    }
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    if (_request) {
        [self loadURLRequest:_request];
    } else if (_URL) {
        [self loadURL:_URL];
    } else if (_baseURL && _HTMLString) {
        [self loadHTMLString:_HTMLString baseURL:_baseURL];
    }

    self.view.backgroundColor = [UIColor whiteColor];
    self.progressView.progressTintColor = self.navigationController.navigationBar.tintColor;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    // [_webView.scrollView addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        [self updateFrameOfProgressView];
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
    
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }
    
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
    
    if (self.navigationController && [self.navigationController isBeingPresented]) {
        UIImage * closeImage =  [NSBundle webBusiness_ImageWithName:@"Registration_icon_close_White_nor"];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:closeImage forState:UIControlStateNormal];
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit];
        // 让按钮的内容往左边偏移10
        button.frame  = CGRectMake(0, 0, 30, 30);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIBarButtonItem  * closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.navigationItem.leftBarButtonItem = closeButton;
        else
            self.navigationItem.rightBarButtonItem = closeButton;
        self.navigationItem.leftBarButtonItem = nil;

    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && _showsToolBar && _navigationType == AXWebViewControllerNavigationToolItem) {
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
}
- (void)closeButtonClicked:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // [self updateNavigationItems];
    
    //----- SETUP DEVICE ORIENTATION CHANGE NOTIFICATION -----
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.navigationController) {
        [_progressView removeFromSuperview];
    }
    
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self.navigationItem setLeftBarButtonItems:nil animated:NO];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && _showsToolBar && _navigationType == AXWebViewControllerNavigationToolItem) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (_navigationType == AXWebViewControllerNavigationBarItem) [self updateNavigationItems];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if ([super respondsToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    if (_navigationType == AXWebViewControllerNavigationBarItem) [self updateNavigationItems];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    // Should not pop. It appears clicked the back bar button item. We should decide the action according to the content of web view.
    if ([self.navigationController.topViewController isKindOfClass:[AXWebViewController class]]) {
        AXWebViewController* webVC = (AXWebViewController*)self.navigationController.topViewController;
        // If web view can go back.
        if (webVC.webView.canGoBack) {
            // Stop loading if web view is loading.
            if (webVC.webView.isLoading) {
                [webVC.webView stopLoading];
            }
            // Go back to the last page if exist.
            [webVC.webView goBack];
            // Should not pop items.
            return NO;
        }else{
            if (webVC.navigationType == AXWebViewControllerNavigationBarItem && webVC.navigationItem.leftBarButtonItems.count >2) { // Navigation items did not refresh.
                [webVC updateNavigationItems];
                return NO;
            }
            // Pop view controlers directly.
            return YES;
        }
    }else{
        // Pop view controllers directly.
        return YES;
    }
}

- (void)dealloc {
    [_webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"scrollView.contentOffset"];
    [_webView removeObserver:self forKeyPath:@"title"];
    // [_webView.scrollView removeObserver:self forKeyPath:@"backgroundColor"];

#if kAX_WEB_VIEW_CONTROLLER_DEBUG_LOGGING
    NSLog(@"One of AXWebViewController's instances was destroyed.");
#endif
}



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // Add progress view to navigation bar.
        if (self.navigationController && self.progressView.superview != self.navigationController.navigationBar) {
            [self updateFrameOfProgressView];
            [self.navigationController.navigationBar addSubview:self.progressView];
        }
        float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        if (progress >= _progressView.progress) {
            [_progressView setProgress:progress animated:YES];
        } else {
            [_progressView setProgress:progress animated:NO];
        }
    } else if ([keyPath isEqualToString:@"backgroundColor"]) {
        // #if AX_WEB_VIEW_CONTROLLER_USING_WEBKIT
        /*
         if (![_webView.scrollView.backgroundColor isEqual:[UIColor clearColor]]) {
         _webView.scrollView.backgroundColor = [UIColor clearColor];
         }
         */
        // #endif
    } else if ([keyPath isEqualToString:@"scrollView.contentOffset"]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self.URL
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *param1 = [self valueForKey:@"navigationTranslucent"
                              fromQueryItems:queryItems];
        if (param1) {
            if (contentOffset.y<=100) {
                [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithRGB:0xff611d alpha:contentOffset.y/100.0]] forBarMetrics:UIBarMetricsDefault];
                
            }else{
                [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"0xff611d"]] forBarMetrics:UIBarMetricsDefault];
            }
        }
        _backgroundLabel.transform = CGAffineTransformMakeTranslation(0, -contentOffset.y-_webView.scrollView.contentInset.top);
    } else if ([keyPath isEqualToString:@"title"]) {
        // Update title of vc.
        [self _updateTitleOfWebVC];
        // And update navigation items if needed.
        if (_navigationType == AXWebViewControllerNavigationBarItem) [self updateNavigationItems];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Getters
- (WKWebView *)webView {
    if (_webView) return _webView;
    WKWebViewConfiguration *config = _configuration;
    if (!config) {
        config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 9.0;
        /*
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
                if ([config respondsToSelector:@selector(setApplicationNameForUserAgent:)]) {
                    [config setApplicationNameForUserAgent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
                }
                if ([config respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
                    [config setAllowsInlineMediaPlayback:YES];
                }
        #endif
         */
        if ([config respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
            [config setAllowsInlineMediaPlayback:YES];
        }
        if (AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS9_0)) {
            if ([config respondsToSelector:@selector(setApplicationNameForUserAgent:)]) {
                [config setApplicationNameForUserAgent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
            }
        }
        if (AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS10_0) && [config respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]) {
            [config setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
        } else if (AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS9_0) && [config respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
            [config setRequiresUserActionForMediaPlayback:NO];
        } else if (AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS8_0) && [config respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
            [config setMediaPlaybackRequiresUserAction:NO];
        }
    }
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    // Set auto layout enabled.
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    if (_enabledWebViewUIDelegate) _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    // Obverse the content offset of the scroll view.
    [_webView addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    // Obverse title. Fix issue: https://github.com/devedbox/AXWebViewController/issues/35
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView) return _progressView;
    CGFloat progressBarHeight = 2.0f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.ax_hiddenWhenProgressApproachFullSize = YES;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    // Set the web view controller to progress view.
    __weak typeof(self) wself = self;
    _progressView.ax_webViewController = wself;
    return _progressView;
}

- (UIView *)containerView { return [self.view viewWithTag:kContainerViewTag]; }


- (UIBarButtonItem *)backBarButtonItem {
    if (_backBarButtonItem) return _backBarButtonItem;
    _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AXWebViewController.bundle/AXWebViewControllerBack"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(goBackClicked:)];
    _backBarButtonItem.width = 18.0f;
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (_forwardBarButtonItem) return _forwardBarButtonItem;
    _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AXWebViewController.bundle/AXWebViewControllerNext"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(goForwardClicked:)];
    _forwardBarButtonItem.width = 18.0f;
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (_refreshBarButtonItem) return _refreshBarButtonItem;
    _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (_stopBarButtonItem) return _stopBarButtonItem;
    _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    return _stopBarButtonItem;
}



- (UILabel *)backgroundLabel {
    if (_backgroundLabel) return _backgroundLabel;
    _backgroundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    /*
    #if  AX_WEB_VIEW_CONTROLLER_USING_WEBKIT
        _backgroundLabel.textColor = [UIColor colorWithRed:0.180 green:0.192 blue:0.196 alpha:1.00];
    #else
        _backgroundLabel.textColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
    #endif
     */
    if (AX_WEB_VIEW_CONTROLLER_NEED_USING_WEB_KIT()) {
        _backgroundLabel.textColor = [UIColor colorWithRed:0.180 green:0.192 blue:0.196 alpha:1.00];
    } else {
        _backgroundLabel.textColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
    }
    _backgroundLabel.font = [UIFont systemFontOfSize:12];
    _backgroundLabel.numberOfLines = 0;
    _backgroundLabel.textAlignment = NSTextAlignmentCenter;
    _backgroundLabel.backgroundColor = [UIColor clearColor];
    _backgroundLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_backgroundLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _backgroundLabel.hidden = !self.showsBackgroundLabel;
    return _backgroundLabel;
}

- (UILabel *)descriptionLabel {
    return self.backgroundLabel;
}
#pragma mark - Setter
- (void)setEnabledWebViewUIDelegate:(BOOL)enabledWebViewUIDelegate {
    _enabledWebViewUIDelegate = enabledWebViewUIDelegate;
    if (AX_WEB_VIEW_CONTROLLER_iOS8_0_AVAILABLE()) {
        if (_enabledWebViewUIDelegate) {
            _webView.UIDelegate = self;
        } else {
            _webView.UIDelegate = nil;
        }
    }
}
- (void)setTimeoutInternal:(NSTimeInterval)timeoutInternal {
    _timeoutInternal = timeoutInternal;
    NSMutableURLRequest *request = [_request mutableCopy];
    request.timeoutInterval = _timeoutInternal;
    _navigation = [_webView loadRequest:request];
    _request = [request copy];

}

- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    NSMutableURLRequest *request = [_request mutableCopy];
    request.cachePolicy = _cachePolicy;
    _navigation = [_webView loadRequest:request];
    _request = [request copy];

}

- (void)setShowsToolBar:(BOOL)showsToolBar {
    _showsToolBar = showsToolBar;
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }
}
- (void)setShowsBackgroundLabel:(BOOL)showsBackgroundLabel{
    _backgroundLabel.hidden = !showsBackgroundLabel;
    _showsBackgroundLabel = showsBackgroundLabel;
}

- (void)setMaxAllowedTitleLength:(NSUInteger)maxAllowedTitleLength {
    _maxAllowedTitleLength = maxAllowedTitleLength;
    [self _updateTitleOfWebVC];
}

#pragma mark - Public
- (void)loadURL:(NSURL *)pageURL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pageURL];
    request.timeoutInterval = _timeoutInternal;
    request.cachePolicy = _cachePolicy;
    _navigation = [_webView loadRequest:request];

}

- (void)loadURLRequest:(NSURLRequest *)request {
    NSMutableURLRequest *__request = [request mutableCopy];
    _navigation = [_webView loadRequest:__request];

}

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    _baseURL = baseURL;
    _HTMLString = HTMLString;
    _navigation = [_webView loadHTMLString:HTMLString baseURL:baseURL];

}
- (void)willGoBack{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerWillGoBack:)]) {
        [_delegate webViewControllerWillGoBack:self];
    }
}
- (void)willGoForward{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerWillGoForward:)]) {
        [_delegate webViewControllerWillGoForward:self];
    }
}
- (void)willReload{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerWillReload:)]) {
        [_delegate webViewControllerWillReload:self];
    }
}
- (void)willStop{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerWillStop:)]) {
        [_delegate webViewControllerWillStop:self];
    }
}
- (void)didStartLoad{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerDidStartLoad:)]) {
        [_delegate webViewControllerDidStartLoad:self];
    }
    _loading = YES;
}
- (void)didStartLoadWithNavigation:(WKNavigation *)navigation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self didStartLoad];
#pragma clang diagnostic pop
    // FIXME: Handle the navigation of WKWebView.
    // ...
}
/// Did start load.
- (void)_didStartLoadWithObj:(id)object {
    // Get WKNavigation class:
    Class WKNavigationClass = NSClassFromString(@"WKNavigation");
    if (WKNavigationClass == NULL) {
        if (![object isKindOfClass:WKNavigationClass] || object == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self didStartLoad];
#pragma clang diagnostic pop
            return;
        }
    }
    if (AX_WEB_VIEW_CONTROLLER_NEED_USING_WEB_KIT() && [object isKindOfClass:WKNavigationClass]) [self didStartLoadWithNavigation:object];
}

- (void)didFinishLoad{

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }
    
    [self _updateTitleOfWebVC];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundle = ([infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"])?:[infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *host;
    host = _webView.URL.host;

    _backgroundLabel.text = [NSString stringWithFormat:@"网页由%@提供.", host?:bundle];
    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerDidFinishLoad:)]) {
        [_delegate webViewControllerDidFinishLoad:self];
    }
    _loading = NO;
}

- (void)didFailLoadWithError:(NSError *)error{

    _backgroundLabel.text = [NSString stringWithFormat:@"%@%@",@"加载失败",error.localizedDescription];
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(webViewController:didFailLoadWithError:)]) {
        [_delegate webViewController:self didFailLoadWithError:error];
    }
    [_progressView setProgress:0.9 animated:YES];
}

+ (void)clearWebCacheCompletion:(dispatch_block_t)completion {
    /*
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:completion];
#else
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    // iOS8.0 WebView Cache path
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    
    // iOS7.0 WebView Cache path
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    if (completion) {
        completion();
    }
#endif
     */
    if (AX_WEB_VIEW_CONTROLLER_AVAILABLE_ON(_kiOS9_0)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:completion];
    } else {
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        
        NSError *error;
        /* iOS8.0 WebView Cache path */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        
        /* iOS7.0 WebView Cache path */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Actions
- (void)goBackClicked:(UIBarButtonItem *)sender {
    [self willGoBack];
    if ([_webView canGoBack]) {
        
        _navigation = [_webView goBack];
    }

}
- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [self willGoForward];
    if ([_webView canGoForward]) {
        _navigation = [_webView goForward];
    }

}
- (void)reloadClicked:(UIBarButtonItem *)sender {
    [self willReload];
    _navigation = [_webView reload];

}
- (void)stopClicked:(UIBarButtonItem *)sender {
    [self willStop];
    [_webView stopLoading];

}


- (void)navigationItemHandleBack:(UIBarButtonItem *)sender {
    if ([_webView canGoBack]) {
        [AXWebViewController clearWebCacheCompletion:^{
            _navigation = [_webView goBack];

        }];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationIemHandleClose:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        if (navigationAction.request) {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (void)webViewDidClose:(WKWebView *)webView {
}
#endif
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // Get host name of url.
    NSString *host = webView.URL.host;
    // Init the alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:host?:@"消息" message:message preferredStyle: UIAlertControllerStyleAlert];
    // Init the cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler != NULL) {
            completionHandler();
        }
    }];
    // Init the ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler();
        }
    }];
    
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    // Get the host name.
    NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:host?:@"消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler(NO);
        }
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler(YES);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    // Get the host of url.
    NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:prompt?:@"消息" message:host preferredStyle:UIAlertControllerStyleAlert];
    // Add text field.
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText?:@"输入";
        textField.font = [UIFont systemFontOfSize:12];
    }];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // Disable all the '_blank' target in page's target.
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }

    // Update the items.
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }
    // Call the decision handler to allow to load web page.
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self _didStartLoadWithObj:navigation];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {


}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {


}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {



}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    
    [self didFinishLoad];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        [webView reloadFromOrigin];
        return;
    }
    // id _request = [navigation valueForKeyPath:@"_request"];
    [self didFailLoadWithError:error];
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    // !!!: Do add the security policy if using a custom credential.
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if (self.challengeHandler) {
        disposition = self.challengeHandler(webView, challenge, &credential);
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
    // completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // Get the host name.
    NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:host?:@"消息" message:@"终止" preferredStyle:UIAlertControllerStyleAlert];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
}
#endif


#pragma mark - Helper
- (void)_updateTitleOfWebVC {
    NSString *title = self.title;
    title = title.length>0 ? title: [_webView title];

    NSString * myTitle = title.length>0 ? title : @"";

    if (myTitle.length>0) {
        self.titleView.attributedText = [[NSAttributedString alloc]initWithString:myTitle attributes:[UINavigationBar appearance].titleTextAttributes];
        [self.titleView sizeToFit];
        
        self.navigationItem.titleView = self.titleView;
    }
  

}
- (UILabel *)titleView {
    if (!_titleView) {
        _titleView =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
        _titleView.textAlignment = NSTextAlignmentCenter;
    }
    return _titleView;
}
- (void)updateFrameOfProgressView {
    CGFloat progressBarHeight = 2.0f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView.frame = barFrame;
}


- (void)setupSubviews {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self.URL
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *param1 = [self valueForKey:@"navigationTranslucent"
                              fromQueryItems:queryItems];
        if (param1) {
            if (@available(iOS 11.0,*)) {
                make.top.mas_equalTo(-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-CGRectGetHeight(self.navigationController.navigationBar.frame));

            }else{
                make.top.mas_equalTo(self.mas_topLayoutGuideTop);
            }

        }else{
            make.top.mas_equalTo(self. mas_topLayoutGuideBottom);
        }
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0,*)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    
    
    self.progressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2);
    [self.view addSubview:self.progressView];
    [self.view bringSubviewToFront:self.progressView];
}

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    self.actionBarButtonItem.enabled = !self.self.webView.isLoading;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fixedSpace.width = 35.0f;
        
        NSArray *items = [NSArray arrayWithObjects:fixedSpace, refreshStopBarButtonItem, fixedSpace, self.backBarButtonItem, fixedSpace, self.forwardBarButtonItem, fixedSpace, self.actionBarButtonItem, nil];
        
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    
    else {
        NSArray *items = [NSArray arrayWithObjects: fixedSpace, self.backBarButtonItem, flexibleSpace, self.forwardBarButtonItem, flexibleSpace, refreshStopBarButtonItem, flexibleSpace, self.actionBarButtonItem, fixedSpace, nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationController.toolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
        self.toolbarItems = items;
    }
}

- (void)updateNavigationItems {

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -16;

    if (self.webView.canGoBack/* || self.webView.backForwardList.backItem*/) {// Web view can go back means a lot requests exist.

        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[space,self.navigationBackItem,self.navigationCloseItem] animated:NO];

    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = self.navigationBackItem.enabled;
        [self.navigationItem setLeftBarButtonItems:@[space,self.navigationBackItem] animated:NO];
    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//
//    if (self.navigationController) {
//        [[self valueForKey:@"_progressView"] removeFromSuperview];
//    }
//
//    if (self.navigationType == AXWebViewControllerNavigationBarItem) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//
//    //    [self.navigationItem setLeftBarButtonItems:nil animated:NO];
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && self.showsToolBar && self.navigationType == AXWebViewControllerNavigationToolItem) {
//        [self.navigationController setToolbarHidden:YES animated:animated];
//    }
//
//    UIDevice *device = [UIDevice currentDevice]; //Get the device object
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
//}
//- (void)updateNavigationItems {

//
//}
- (UIBarButtonItem *)navigationBackItem {
    if (_navigationBackItem ) return _navigationBackItem;
    HCWebButton *button = [HCWebButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[NSBundle webBusiness_ImageWithName:@"Registration_icon_return_White_nor"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    // 让按钮的内容往左边偏移10
    button.frame  = CGRectMake(8, 0, 38.5, 40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigationItemHandleBack:) forControlEvents:UIControlEventTouchUpInside];
    UIView *backBtnView = [[UIView alloc] initWithFrame:button.bounds];
    [backBtnView addSubview:button];

    self.navigationItem.leftBarButtonItems = nil;
    // 修改导航栏左边的item
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    _navigationBackItem = item;
    return _navigationBackItem;
}

- (UIBarButtonItem *)navigationCloseItem {
    if (_navigationCloseItem) return _navigationCloseItem;
    UIImage * closeImage =  [NSBundle webBusiness_ImageWithName:@"Registration_icon_close_White_nor"];

    HCWebButton * button = [HCWebButton buttonWithType:UIButtonTypeCustom];
    [button setImage:closeImage forState:UIControlStateNormal];
    // 让按钮内部的所有内容左对齐
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    //        [button sizeToFit];
    // 让按钮的内容往左边偏移10
    button.frame  = CGRectMake(0, 0, 30, 40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigationIemHandleClose:) forControlEvents:UIControlEventTouchUpInside];

    UIView *backBtnView = [[UIView alloc] initWithFrame:button.bounds];
    [backBtnView addSubview:button];


    _navigationCloseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    return _navigationCloseItem;
}


- (void)orientationChanged:(NSNotification *)note  {
    // Update tool bar items of navigation tpye is tool item.
    if (_navigationType == AXWebViewControllerNavigationToolItem) { [self updateToolbarItems]; return; }
    // Otherwise update navigation items.
    [self updateNavigationItems];
}
@end

@implementation AXWebViewController (Security)
- (WKWebViewDidReceiveAuthenticationChallengeHandler)challengeHandler {
    return _challengeHandler;
}

- (AXSecurityPolicy *)securityPolicy {
    return _securityPolicy;
}

- (void)setChallengeHandler:(WKWebViewDidReceiveAuthenticationChallengeHandler)challengeHandler {
    _challengeHandler = [challengeHandler copy];
}

- (void)setSecurityPolicy:(AXSecurityPolicy *)securityPolicy {
    _securityPolicy = securityPolicy;
}
@end

@implementation UIProgressView (WebKit)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Inject "-popViewControllerAnimated:"
        Method originalMethod = class_getInstanceMethod(self, @selector(setProgress:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(ax_setProgress:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        originalMethod = class_getInstanceMethod(self, @selector(setProgress:animated:));
        swizzledMethod = class_getInstanceMethod(self, @selector(ax_setProgress:animated:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)ax_setProgress:(float)progress {
    [self ax_setProgress:progress];
    
    [self checkHiddenWhenProgressApproachFullSize];
}

- (void)ax_setProgress:(float)progress animated:(BOOL)animated {
    [self ax_setProgress:progress animated:animated];
    
    [self checkHiddenWhenProgressApproachFullSize];
}

- (void)checkHiddenWhenProgressApproachFullSize {
    if (!self.ax_hiddenWhenProgressApproachFullSize) {
        return;
    }
    
    float progress = self.progress;
    if (progress < 1) {
        if (self.hidden) {
            self.hidden = NO;
        }
    } else if (progress >= 1) {
        [UIView animateWithDuration:0.35 delay:0.15 options:7 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.hidden = YES;
                self.progress = 0.0;
                self.alpha = 1.0;
                // Update the navigation itmes if the delegate is not being triggered.
                if (self.ax_webViewController.navigationType == AXWebViewControllerNavigationBarItem) {
                    [self.ax_webViewController updateNavigationItems];
                } else {
                    [self.ax_webViewController updateToolbarItems];
                }
            }
        }];
    }
}

- (BOOL)ax_hiddenWhenProgressApproachFullSize {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAx_hiddenWhenProgressApproachFullSize:(BOOL)ax_hiddenWhenProgressApproachFullSize {
    objc_setAssociatedObject(self, @selector(ax_hiddenWhenProgressApproachFullSize), @(ax_hiddenWhenProgressApproachFullSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AXWebViewController *)ax_webViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAx_webViewController:(AXWebViewController *)ax_webViewController {
    // Using assign to fix issue: https://github.com/devedbox/AXWebViewController/issues/23
    objc_setAssociatedObject(self, @selector(ax_webViewController), ax_webViewController, OBJC_ASSOCIATION_ASSIGN);
}
@end

