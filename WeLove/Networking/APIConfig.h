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
//发送验证码
#define Send_VeriCode_Url @""
//检验验证码
#define Check_VeriCode_Url @""
//注册
#define Register_Url @""
//重置密码
#define Reset_Password_Url @""
//获取用户信息
#define User_Info_Url @""
//修改密码
#define Update_Password_Url @""
//版本更新
#define Version_Update_Url @""
//田块常规信息
#define Field_Base_Info_Url @""
//田块农事列表
#define Field_Activity_List_Url @""
//天气预报
#define Weather_Url @"/noa/weather/forcast"
//农作物列表
#define Crop_List_Url @""
//农场信息
#define Farm_Info_Url @""
//编辑农场信息
#define Farm_Info_Edit_Url @""
//图片上传
#define Upload_Pic_Url @""
//追溯作物列表
#define Trace_Crop_List_Url @""
//追溯详情
#define Trace_Detail_Url @""
//气象传感器数据
#define Weather_Sensor_Url @""
//传感器列表
#define Sensor_List_Url @""
//田块传感器数据
#define Field_Sensor_List_Url @""
//追溯传感器数据
#define Track_Sensor_List_Url @""
//水质传感器类型
#define Water_Quality_Sensor_Type_Url @""
//水质传感器数据
#define Water_Quality_Sensor_List_Url @""
//活动作物列表
#define Activity_Crop_List_Url @"/api/activity/crops"
//农事活动投入品
#define Activity_Inputs_List_Url @""
//农事活动二级投入品
#define Activity_SubInputs_List_Url @""
//农事活动额外信息
#define Activity_Addtional_Info_Url @""
//农事活动操作员
#define Activity_Operator_List_Url @""
//视频通道
#define Video_List_Url @""
//视频上传
#define Video_Upload_Url @""
//田块列表
#define Field_List_Url @""
//农事活动类型
#define Activity_Type_List_Url @""
//添加农事活动
#define Add_Activity_Url @""
//投入品
#define Inputs_List_Url @""
//投入品类型
#define Inputs_Type_List_Url @""
//新增投入品
#define Add_Inputs_Url @""
//农事活动
#define Farm_Activity_List_Url @""

#endif /* APIConfig_h */
