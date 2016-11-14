//
//  SensorListManager.h
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface FieldSensorListManager : BaseAPIManager <APIManager>
@property(nonatomic,copy)SensorListModel *sensorListData;
@end
