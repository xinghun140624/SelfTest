//
//  HCMyDealFilterView.h
//  HongCai
//
//  Created by Candy on 2017/7/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMyDealFilterView : UIView
@property (nonatomic, strong, readonly) UICollectionView * collectionView;

@property (nonatomic, copy) void(^selectCallback)(NSString * buttonTitles);
@end
