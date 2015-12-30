//
//  CLWebRequestAPI.h
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLWebRequest;



/**
 *  网络请求业务接口
 */
@interface CLWebRequestAPI : NSObject


/** 获取全部城市信息 */
+ (CLWebRequest *)requestLocationsCity;

/** 用户注册 */
+ (CLWebRequest *)requestUserRegisters:(NSDictionary *)params;

/** 用户登陆 */
+ (CLWebRequest *)requestUserLogins:(NSDictionary *)params;





/** 获取天气状况，数据来源：http://openweather.weather.com.cn */
+ (CLWebRequest *)requestWeather:(NSString *)areaid;

/** 获取空气质量，数据来源：http://aqicn.org */
+ (CLWebRequest *)requestAirQuality;


@end
