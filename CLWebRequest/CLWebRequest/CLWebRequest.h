//
//  CLWebRequest.h
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLWebRequestError.h"

@class CLWebRequestQueue;


/** 请求即将开始时执行的Block */
typedef void(^RequestWillStartBlock)();

/** 请求返回后执行的Block */
typedef void(^RequestFinishBlock)(id result, id error);



// 网络请求类型
typedef NS_ENUM(NSInteger, CLWebRequestType)
{
    CLWebRequestTypeGet,      // Get请求
    CLWebRequestTypePost,     // Post请求
    CLWebRequestTypePostImage // 上传图片
};



/**
 *  网络请求
 */
@interface CLWebRequest : NSObject


/** 网络请求名称 */
@property (nonatomic, copy)   NSString *requestName;

/** 网络请求类型，包括：Get、Post、上传图片 */
@property (nonatomic, assign) CLWebRequestType requestType;

/** 网络请求地址 */
@property (nonatomic, copy)   NSString *requestUrl;

/** 网络请求参数 */
@property (nonatomic, strong) NSMutableDictionary *requestParams;

/** 需要上传的图片数据，只有当请求类型为WebRequestTypePostImage时才使用 */
@property (nonatomic, strong) NSData *imageData;

/** 网络请求失败信息，请求成功则为nil */
@property (nonatomic, strong) CLWebRequestError *error;



/** 请求即将开始时执行的Block，在这里准备请求参数 */
@property (nonatomic, copy)   RequestWillStartBlock requestWillStartBlock;

/** 请求返回后执行的Block，在这里对返回数据做处理 */
@property (nonatomic, copy)   RequestFinishBlock requestFinishBlock;



/** 立即开始执行网络请求，使用异步并行线程请求 */
- (void)startRequest;



/** 私有属性，用于管理网络请求的执行顺序，用户不要设置该属性 */
@property (nonatomic, copy) void(^manageRequestFinishBlock)();
/** 私有属性，用于管理网络请求的执行顺序，用户不要设置该属性 */
@property (nonatomic, strong)  CLWebRequestQueue *requestQueue;


@end





