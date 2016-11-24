//
//  APIConfig.h
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

//测试环境
#define ANZ_DEBUG
//生产环境
//#define ANZ_PRODUCT

#ifndef APIConfig_h
#define APIConfig_h

#ifdef ANZ_DEBUG
#define API_BASE_URL @""       //测试环境地址
#elif defined ANZ_PRODUCT
#endif

//登录
#define Login_Url @""

//获取用户信息
#define User_Info_Url @""

#endif /* APIConfig_h */
