//
//  HCTabBarControllerConfig.m
//  HongCai
//
//  Created by Candy on 2017/5/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCTabBarControllerConfig.h"

#import "HCHomeController.h"
#import "HCInvestmentController.h"
#import "HCDiscoverController.h"
#import "HCMineController.h"

#import "HCNavigationController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "UIImage+cropEqualScaleImage.h"
#import "HCBannerActivityApi.h"
#import "HCActivityModel.h"
#import <SDWebImage/SDWebImageDownloader.h>

@interface HCTabBarControllerConfig()
@property (nonatomic, strong, readwrite) HCTabBarController *tabBarController;

@end

@implementation HCTabBarControllerConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray * norImageArray = [NSMutableArray array];
        NSMutableArray * selectImageArray = [NSMutableArray array];
        
        HCBannerActivityApi * api = [[HCBannerActivityApi alloc] initWithToken:nil type:3 locale:6 count:4];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseObject) {
                NSArray * array = [NSArray yy_modelArrayWithClass:HCActivityModel.class json:request.responseObject[@"data"]];
                [array enumerateObjectsUsingBlock:^(HCActivityModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [norImageArray addObject:obj.imageUrl];
                    [selectImageArray addObject:obj.linkUrl];
                }];
                [norImageArray enumerateObjectsUsingBlock:^(NSString * norImageUrl, NSUInteger idx, BOOL * _Nonnull stop) {
                    UITabBarItem * item = self.tabBarController.tabBar.items[idx];
                    
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:norImageUrl] options:SDWebImageDownloaderAllowInvalidSSLCertificates progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        if (image.size.width>=60) {
                            item.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
                        }
                        image = [image bt_cropEqualScalesize:CGSizeMake(40, 40*image.size.width/image.size.height)];
                        item.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    }];
                    NSString * selectImageUrl = selectImageArray[idx];
                    
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:selectImageUrl] options:SDWebImageDownloaderAllowInvalidSSLCertificates progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        if (image.size.width>=60) {
                            item.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
                        }
                        image = [image bt_cropEqualScalesize:CGSizeMake(40, 40*image.size.width/image.size.height)];
                        item.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    }];
                }];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
    }
    return self;
}
- (void)dealloc {
    NSLog(@" tabBarConfig  dealloc");
}
- (HCTabBarController*)tabBarController {
    if (!_tabBarController){
        
        [self customizeTabBarAppearance];
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;//;
        UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
        
        HCTabBarController *tabBarController = [HCTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment];
        _tabBarController = tabBarController;
        [self customizeTabBarAppearance];
        
    }
    return _tabBarController;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance {
    
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"0x9d9d9d"];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.f];

    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"0xff611d"];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.f];

    
    
    
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [[UITabBar appearance] setTranslucent:NO];
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
     [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (NSArray *)viewControllers {
    
    HCHomeController *homeVC = [[HCHomeController alloc] init];
    HCNavigationController *messageNav = [[HCNavigationController alloc]
                                          initWithRootViewController:homeVC];
    
    UIViewController *friendVC = [[HCInvestmentController alloc] init];
    HCNavigationController *friendNav = [[HCNavigationController alloc]
                                         initWithRootViewController:friendVC];
    
    UIViewController *discoverVC = [[HCDiscoverController alloc] init];
    HCNavigationController *discoverNav = [[HCNavigationController alloc]
                                           initWithRootViewController:discoverVC];
    
    UIViewController *mineVC = [[HCMineController alloc] init];
    HCNavigationController *mineNav = [[HCNavigationController alloc]
                                       initWithRootViewController:mineVC];
    
    NSArray *viewControllers = @[
                                 messageNav,
                                 friendNav,
                                 discoverNav,
                                 mineNav
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    
    NSDictionary *messageTabBarItemsAttributes = @{
                                                   CYLTabBarItemTitle : @"首页",
                                                   CYLTabBarItemImage : @"home_icon_home_nor",  /* NSString and UIImage are supported*/
                                                   CYLTabBarItemSelectedImage : @"home_icon_home_hig", /* NSString and UIImage are supported*/
                                                   };
    NSDictionary *friendTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"投资",
                                                  CYLTabBarItemImage : @"home_icon_Investment_nor",
                                                  CYLTabBarItemSelectedImage : @"home_icon_Investment_hig",
                                                  };
    NSDictionary *discoverTabBarItemsAttributes = @{
                                                    CYLTabBarItemTitle : @"发现",
                                                    CYLTabBarItemImage : @"home_icon_find_nor",
                                                    CYLTabBarItemSelectedImage : @"home_icon_find_hig",
                                                    };
    NSDictionary *mineTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"我的",
                                                CYLTabBarItemImage : @"home_icon_mine_nor",
                                                CYLTabBarItemSelectedImage : @"home_icon_mine_hig"
                                                };
    NSArray *tabBarItemsAttributes = @[
                                       messageTabBarItemsAttributes,
                                       friendTabBarItemsAttributes,
                                       discoverTabBarItemsAttributes,
                                       mineTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}



@end
