//
//  LocationManager.m
//  anz
//
//  Created by KevinCao on 16/7/9.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "LocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface LocationManager ()
@property(nonatomic,assign,readwrite)double latitude;
@property(nonatomic,assign,readwrite)double longitude;
@property(nonatomic,strong)BMKLocationService *locationService;
@property(nonatomic,strong)BMKPoiSearch *poiSearch;
@property(nonatomic,strong)BMKGeoCodeSearch *geoSearch;
@property (nonatomic, assign, readwrite) LocationManagerLocationResult locationResult;
@property (nonatomic, assign, readwrite) LocationManagerLocationServiceStatus locationStatus;
//定位成功之后就不需要再通知到外面了，防止外面的数据变化。
@property (nonatomic) BOOL shouldNotifyOtherObjects;
@end

@implementation LocationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t AJKHDLocationManagerOnceToken;
    static LocationManager *sharedInstance = nil;
    dispatch_once(&AJKHDLocationManagerOnceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
        sharedInstance.shouldNotifyOtherObjects = YES;
    });
    return sharedInstance;
}

- (BOOL)checkLocationAndShowingAlert:(BOOL)showingAlert;
{
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    LocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == LocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }else if (authorizationStatus == LocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (serviceEnable && result) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (result == NO) {
        [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
    }
    
    if (showingAlert && result == NO) {
        NSString *message = @"请到“设置->隐私->定位服务”中开启定位";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
        [alert show];
    }
    
    return result;
}

- (void)startLocation
{
    if ([self checkLocationAndShowingAlert:NO]) {
        self.locationResult = LocationManagerLocationResultLocating;
        [self.locationService startUserLocationService];
    } else {
        [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

- (void)stopLocation
{
    if ([self checkLocationAndShowingAlert:NO]) {
        [self.locationService stopUserLocationService];
    }
}

- (void)poiSearchNearbyWithDelegate:(id)delegate coordinate:(CLLocationCoordinate2D)coordinate keyword:(NSString *)keyword
{
    __weak typeof(delegate) weakDelegate = delegate;
    self.poiSearch.delegate = weakDelegate;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = coordinate;
    option.keyword = keyword;
    BOOL flag = [self.poiSearch poiSearchNearBy:option];
    if(flag)
    {
        //周边检索发送成功
    }
    else
    {
        //周边检索发送失败
    }
}

- (void)poiDetailSearchWithDelegate:(id)delegate poiUid:(NSString *)poiUid
{
    __weak typeof(delegate) weakDelegate = delegate;
    self.poiSearch.delegate = weakDelegate;
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = poiUid;
    BOOL flag = [self.poiSearch poiDetailSearch:option];
    if(flag)
    {
        //详情检索发送成功
    }
    else
    {
        //详情检索发送失败
    }
}

- (void)geoSearchNearbyWithDelegate:(id)delegate coordinate:(CLLocationCoordinate2D)coordinate
{
    __weak typeof(delegate) weakDelegate = delegate;
    self.geoSearch.delegate = weakDelegate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [self.geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      //反geo检索发送成功
    }
    else
    {
      //反geo检索发送失败
    }
}

#pragma mark - private
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = LocationManagerLocationServiceStatusOK;
        return YES;
    } else {
        self.locationStatus = LocationManagerLocationServiceStatusUnknownError;
        return NO;
    }
}

- (LocationManagerLocationServiceStatus)locationServiceStatus
{
    self.locationStatus = LocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = LocationManagerLocationServiceStatusNotDetermined;
                break;
             
            case kCLAuthorizationStatusAuthorizedAlways:
                self.locationStatus = LocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = LocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusDenied:
                self.locationStatus = LocationManagerLocationServiceStatusNoAuthorization;
                break;
                
            default:
                if (![self isReachable]) {
                    self.locationStatus = LocationManagerLocationServiceStatusNoNetwork;
                }
                break;
        }
    } else {
        self.locationStatus = LocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

- (void)failedLocationWithResultType:(LocationManagerLocationResult)result statusType:(LocationManagerLocationServiceStatus)status
{
    self.locationResult = result;
    self.locationStatus = status;
    [self didFailToLocateUserWithError:nil];
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location.coordinate.latitude == self.coordinate.latitude && userLocation.location.coordinate.longitude == self.coordinate.longitude) {
        return;
    }
    self.userLocation = userLocation;
    self.coordinate = userLocation.location.coordinate;
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    self.locationResult = LocationManagerLocationResultSuccess;
    self.shouldNotifyOtherObjects = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdatedSuccessNotification object:nil];
    [self stopLocation];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    //之前如果有定位成功的话，以后的定位失败就都不通知到外面了
    if (!self.shouldNotifyOtherObjects) {
        return;
    }
    //如果用户还没选择是否允许定位，则不认为是定位失败
    if (self.locationStatus == LocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    //如果正在定位中，那么也不会通知到外面
    if (self.locationResult == LocationManagerLocationResultLocating) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationFailedNotification object:nil userInfo:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

#pragma mark - getters and setters
- (BMKLocationService *)locationService
{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = (id)self;
    }
    return _locationService;
}

- (BMKPoiSearch *)poiSearch
{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc]init];
    }
    return _poiSearch;
}

- (BMKGeoCodeSearch *)geoSearch
{
    if (!_geoSearch) {
        _geoSearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geoSearch;
}

@end
