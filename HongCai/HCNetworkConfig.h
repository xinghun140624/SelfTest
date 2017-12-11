//
//  HCNetworkConfig.h
//  HongCai
//
//  Created by Candy on 2017/8/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#ifndef HCNetworkConfig_h
#define HCNetworkConfig_h


#if 1
//测试服务器 0是测试服务器 1是正是服务器 上传AppStore 一定看看是不是正是服务器的地址
#define baseURL     @"http://m.test321.hongcai.com/hongcai/"
#define WebBaseURL  @"http://vue.test321.hongcai.com/"
#define CGBaseURL   @"http://101.200.54.92/"

#else
//线上服务器

#define baseURL     @"https://m.hongcai.com/hongcai/"
#define WebBaseURL  @"https://app.hongcai.com/"
#define CGBaseURL   @"https://cg2.unitedbank.cn/"

#endif



#endif /* HCNetworkConfig_h */
