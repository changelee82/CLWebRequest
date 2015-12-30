//
//  CLWebRequestAPI.m
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLWebRequestAPI.h"
#import "CLWebRequest.h"
#import "CLDes3Encrypt.h"



/** 服务器地址 */
static NSString *const kHOST = @"https://api.15ring.com/";

/** 中国气象局，appid */
static NSString *const kWeatherAppId = @"d03cb0b2221a4500";
/** 中国气象局，PrivateKey */
static NSString *const kWeatherPrivateKey = @"d98042_SmartWeatherAPI_bfffc92";




@implementation CLWebRequestAPI

/**
 *  获取天气状况，数据来源：http://openweather.weather.com.cn
 *  该接口是从中国气象局网站获取天气信息，所获取的信息中没有空气质量
 *
 *  @param areaid 地区编码
 *
 *  @return 单一请求
 */
+ (CLWebRequest *)requestWeather:(NSString *)areaid
{
    // 创建网络请求
    CLWebRequest *request = [[CLWebRequest alloc] init];
    __weak CLWebRequest *weakRequest = request;
    
    // 为网络请求准备参数的Block
    request.requestWillStartBlock = ^()
    {
        // 设置日期格式
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyyMMddHHmm"];
        
        // 获取公钥和私钥
        NSString *publicKey = [NSString stringWithFormat:@"http://open.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@",
                               areaid, @"forecast_v", [form stringFromDate:[NSDate date]], kWeatherAppId];
        NSString *privateKey = kWeatherPrivateKey;
        
        // 获得Key
        NSString *key = [CLDes3Encrypt hmacSha1WithPublicKey:(NSString*)publicKey privateKey:(NSString*)privateKey];

        NSString *url = [NSString stringWithFormat:@"http://open.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@&key=%@",
         areaid, @"forecast_v", [form stringFromDate:[NSDate date]], [kWeatherAppId substringToIndex:6], key];

        
        // 网络请求名称
        weakRequest.requestName = @"获取常规天气数据";
        
        // 网络请求类型
        weakRequest.requestType = CLWebRequestTypeGet;
        
        // 网络请求地址
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        weakRequest.requestUrl = url;
    };
    
    return request;
}

/**
 *  获取空气质量，数据来源：http://aqicn.org
 *
 *  @return 单一请求
 */
+ (CLWebRequest *)requestAirQuality
{
    // 创建网络请求
    CLWebRequest *request = [[CLWebRequest alloc] init];
    __weak CLWebRequest *weakRequest = request;
    
    // 为网络请求准备参数的Block
    request.requestWillStartBlock = ^()
    {
        // 网络请求名称
        weakRequest.requestName = @"获取空气质量";
        
        // 网络请求类型
        weakRequest.requestType = CLWebRequestTypeGet;
        
        // 网络请求地址
        weakRequest.requestUrl = [NSString stringWithFormat:@"%@", @"http://aqicn.org/publishingdata/json"];
        
        // 网络请求参数
        //NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
    };
    
    return request;
}


/** 获取全部城市信息 */
+ (CLWebRequest *)requestLocationsCity
{
    // 创建网络请求
    CLWebRequest *request = [[CLWebRequest alloc] init];
    __weak CLWebRequest *weakRequest = request;
    
    // 网络请求名称
    weakRequest.requestName = @"获取全部城市信息";
    
    // 网络请求类型
    weakRequest.requestType = CLWebRequestTypeGet;
    
    // 网络请求地址
    weakRequest.requestUrl = [NSString stringWithFormat:@"%@%@", kHOST, @"locations/city"];
    
    return request;
}

/** 用户注册 */
+ (CLWebRequest *)requestUserRegisters:(NSDictionary *)params
{
    // 创建网络请求
    CLWebRequest *request = [[CLWebRequest alloc] init];
    __weak CLWebRequest *weakRequest = request;
    
    // 网络请求名称
    weakRequest.requestName = @"用户注册";
    
    // 网络请求类型
    weakRequest.requestType = CLWebRequestTypePost;
    
    // 网络请求地址
    weakRequest.requestUrl = [NSString stringWithFormat:@"%@%@", kHOST, @"userregisters"];
    
    // 网络请求参数
    weakRequest.requestParams = [params copy];
    
    return request;
}

/** 用户登陆 */
+ (CLWebRequest *)requestUserLogins:(NSDictionary *)params
{
    // 创建网络请求
    CLWebRequest *request = [[CLWebRequest alloc] init];
    __weak CLWebRequest *weakRequest = request;
    
    // 网络请求名称
    weakRequest.requestName = @"用户登陆";
    
    // 网络请求类型
    weakRequest.requestType = CLWebRequestTypePost;
    
    // 网络请求地址
    weakRequest.requestUrl = [NSString stringWithFormat:@"%@%@", kHOST, @"userlogins/login"];
    
    // 网络请求参数
    weakRequest.requestParams = [params copy];
    
    return request;
}






@end
