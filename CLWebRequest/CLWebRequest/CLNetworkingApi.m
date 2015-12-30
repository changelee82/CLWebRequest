//
//  CLNetworkingApi.m
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLNetworkingApi.h"
#import "AFNetworking.h"


/**  请求超时时间 */
static const NSInteger kTimeoutSeconds = 15;

/**  最大请求次数 */
//static const NSInteger kTimeoutTimes = 3;

static AFNetworkReachabilityStatus _status;
static AFNetworkReachabilityManager *_reachability;


@implementation CLNetworkingApi

+(void)initialize
{
    //监测网络
    _reachability=[AFNetworkReachabilityManager sharedManager];
    _status=_reachability.networkReachabilityStatus;
    [self Reachablity];
}

/**
 *  获取网络状态
 */
+ (AFNetworkReachabilityStatus)getNetWorkState
{
    return _status;
}

/**
 *  网络监测
 */
+(void)Reachablity
{
    [_reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                _status=AFNetworkReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status=AFNetworkReachabilityStatusReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status=AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusUnknown:
                _status=AFNetworkReachabilityStatusUnknown;
                break;
        }
    }];
    [_reachability startMonitoring];
}

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.requestSerializer setTimeoutInterval:kTimeoutSeconds];
    
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.requestSerializer setTimeoutInterval:kTimeoutSeconds];

    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
              if (success)
              {
                  success(responseObject);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure)
              {
                  failure(error);
              }
          }];
}

/**
 *  post 上传
 */
+(void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constractingBodyBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [self post:url params:params constructingBodyWithBlock:constractingBodyBlock success:success failure:failure uploadProgress:nil];
}
/**
 *  post 上传 设置进度
 */
+ (void)                 post:(NSString *)url
                       params:(NSDictionary *)params
    constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constractingBodyBlock
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure
               uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock
{
    
    //设置参数

//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
//    
//    
//    // 1.创建请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    [mgr.requestSerializer setTimeoutInterval:15];
//    
//    // 2.发送请求
//    AFHTTPRequestSerializer *op=[mgr POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        if(constractingBodyBlock)
//        {
//            constractingBodyBlock(formData);
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        if (success)
//        {
//            success(responseObject);
//            
//        }
//        //        if (success) {
//        //            success(responseObject);
//        //        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (failure) {
//            failure(error);
//        }
//    }];
//    if (uploadProgressBlock) {
//        [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            uploadProgressBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//        }];
//    }
}


@end
