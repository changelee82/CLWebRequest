//
//  CLWebRequest.m
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLWebRequest.h"
#import "CLNetworkingApi.h"



@interface CLWebRequest ()

/**
 *  开始异步网络请求
 */
- (void)startAsynRequest;

@end



/**
 *  网络请求
 */
@implementation CLWebRequest

- (instancetype)init
{
    if(self = [super init])
    {
        // 默认请求名称
        _requestName = @"未命名";
    }
    return self;
}

/**
 *  立即开始执行网络请求，使用异步并行线程请求
 */
- (void)startRequest
{
    // 使用新线程执行网络请求
    dispatch_queue_t concurrentQueue = dispatch_queue_create("CLWebRequest", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        [self startAsynRequest];
    });
}


/**
 *  开始异步网络请求
 */
- (void)startAsynRequest
{
    // 清空请求失败信息
    self.error = nil;
    
    // 请求即将开始，准备请求参数
    if (self.requestWillStartBlock)
        self.requestWillStartBlock();
    
    // 根据不同的网络请求类型分别做处理
    switch (self.requestType)
    {
        case CLWebRequestTypeGet:
        {
            // get请求
            NSLog(@"%@ Get请求：开始", self.requestName);
            
            [CLNetworkingApi get:self.requestUrl
                          params:self.requestParams
                         success:^(id json)
                         {
                             NSLog(@"%@ Get请求：成功返回", self.requestName);
                             
                             // 用户的回调Block
                             if (self.requestFinishBlock)
                                 self.requestFinishBlock(json, nil);

                             // 框架的回调Block
                             if (self.manageRequestFinishBlock)
                                 self.manageRequestFinishBlock();
                         }
                         failure:^(NSError *error)
                         {
                             NSLog(@"%@ Get请求：失败，%@", self.requestName, error.localizedDescription);
                             
                             // 设置错误信息
                             self.error = [[CLWebRequestError alloc] init];
                             self.error.requestName = self.requestName;
                             self.error.errorCode = error.code;
                             self.error.errorMessage = error.localizedDescription;
                             
                             // 用户的回调Block
                             if (self.requestFinishBlock)
                                 self.requestFinishBlock(nil, self.error);
                             
                             // 框架的回调Block
                             if (self.manageRequestFinishBlock)
                                 self.manageRequestFinishBlock();
                         }];
            break;
        }
            
        case CLWebRequestTypePost:
        {
            // post请求
            NSLog(@"%@ Post请求：开始", self.requestName);
            
            [CLNetworkingApi post:self.requestUrl
                           params:self.requestParams
                          success:^(id json)
                         {
                             NSLog(@"%@ Post请求：成功返回", self.requestName);
                             
                             // 用户的回调Block
                             if (self.requestFinishBlock)
                                 self.requestFinishBlock(json, nil);
                             
                             // 框架的回调Block
                             if (self.manageRequestFinishBlock)
                                 self.manageRequestFinishBlock();
                         }
                          failure:^(NSError *error)
                         {
                             NSLog(@"%@ Post请求：失败，%@", self.requestName, error.localizedDescription);
                             
                             // 设置错误信息
                             self.error = [[CLWebRequestError alloc] init];
                             self.error.requestName = self.requestName;
                             self.error.errorCode = error.code;
                             self.error.errorMessage = error.localizedDescription;
                             
                             // 用户的回调Block
                             if (self.requestFinishBlock)
                                 self.requestFinishBlock(nil, self.error);
                             
                             // 框架的回调Block
                             if (self.manageRequestFinishBlock)
                                 self.manageRequestFinishBlock();
                         }];
            break;
        }
            
        case CLWebRequestTypePostImage:
        {
            // 上传图片
            NSLog(@"%@ PostImage请求：开始", self.requestName);
            
            [CLNetworkingApi post:self.requestUrl
                           params:self.requestParams
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                         {
                             [formData appendPartWithFileData:self.imageData name:@"file" fileName:@"123" mimeType:@"image/jpeg"];
                         }
                          success:^(id json)
                         {
                             NSLog(@"%@ PostImage请求：成功返回", self.requestName);
                             
                             // 用户的回调Block
                             if (self.requestFinishBlock)
                                 self.requestFinishBlock(json, nil);
                             
                             // 框架的回调Block
                             if (self.manageRequestFinishBlock)
                                 self.manageRequestFinishBlock();

                         }
                          failure:^(NSError *error)
                         {
                             NSLog(@"%@ PostImage请求：失败，%@", self.requestName, error.localizedDescription);
                             
                             // 设置错误信息
                             self.error = [[CLWebRequestError alloc] init];
                             self.error.requestName = self.requestName;
                             self.error.errorCode = error.code;
                             self.error.errorMessage = error.localizedDescription;
                             
                             // 用户的回调Block
                             if (self.requestFinishBlock)
                                 self.requestFinishBlock(nil, self.error);
                             
                             // 框架的回调Block
                             if (self.manageRequestFinishBlock)
                                 self.manageRequestFinishBlock();
                         }];
            break;
        }
    }
}


@end
