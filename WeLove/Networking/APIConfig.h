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
#define API_BASE_URL @"http://192.168.5.2:9002"       //测试环境地址
#elif defined ANZ_PRODUCT
#endif

//登录
#define Login_Url @""
//退出登录
#define Logout_Url @""

//获取用户信息
#define User_Info_Url @""

//天气预报
#define Weather_Url @"/noa/weather/forcast"

//图片上传
#define Upload_Pic_Url @""

//气象传感器数据
#define Weather_Sensor_Url @""

//活动作物列表
#define Activity_Crop_List_Url @"/api/activity/crops"

//视频通道
#define Video_List_Url @""
//视频上传
#define Video_Upload_Url @""

//农事活动
#define Farm_Activity_List_Url @""

#endif /* APIConfig_h */
