//
//  CLNetworkingApi.h
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


/**
 *  封装 AFNetworking 的网络请求接口
 */
@interface CLNetworkingApi : NSObject

/**
 *  获取网络状态
 */
+ (AFNetworkReachabilityStatus)getNetWorkState;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/**
 *  post 上传图片
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constractingBodyBlock success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/**
 *  post 上传图片 带进度
 */
+(void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constractingBodyBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure uploadProgress:(void(^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;




@end
