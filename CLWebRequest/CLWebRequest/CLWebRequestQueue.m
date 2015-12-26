//
//  CLWebRequestQueue.m
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLWebRequestQueue.h"
#import "CLWebRequest.h"


@interface CLWebRequestQueue ()

/** 网络请求任务队列 */
@property (nonatomic, strong) NSMutableArray *requestArray;

/** 是否停止请求 */
@property (nonatomic, assign) BOOL isStopRequest;


/**
 *  队列内子请求完成后，执行此方法通知所属的请求队列对象
 */
- (void)subRequestFinish:(CLWebRequest *)request;

@end



@implementation CLWebRequestQueue

- (instancetype)init
{
    if(self = [super init])
    {
        self.requestName = @"未命名队列";
        _requestArray = [NSMutableArray array];
        _isStopRequest = FALSE;
    }
    return self;
}


/**
 *  向列队中添加网络请求
 *
 *  @param request 网络请求
 */
- (void)addSubRequest:(CLWebRequest *)request
{
    __weak CLWebRequest *weakRequest = request;
    request.requestQueue = self;
    request.manageRequestFinishBlock = ^()
    {
        if (weakRequest.requestQueue)
        {
            [weakRequest.requestQueue subRequestFinish:weakRequest];
        }
    };
    [self.requestArray addObject:request];
}


/**
 *  开始网络请求
 */
- (void)startRequest
{
    // 请求即将开始，准备请求参数
    if (self.requestWillStartBlock)
        self.requestWillStartBlock();
    
    NSLog(@"%@ Queue请求：开始", self.requestName);
    
    // 处理没有子请求的情况
    if (self.requestArray.count == 0)
    {
        NSLog(@"%@ Queue请求：没有可执行的子请求，直接返回", self.requestName);
        
        // 用户的回调Block
        if (self.requestFinishBlock)
            self.requestFinishBlock(nil, nil);
        
        // 框架的回调Block
        if (self.manageRequestFinishBlock)
            self.manageRequestFinishBlock();
        
        // 释放内存
        [self.requestArray removeAllObjects];
        self.requestArray = nil;
        
        return;
    }
    
    CLWebRequest *request = [self.requestArray firstObject];
    if (request != nil)
    {
        // 从第一个请求开始执行
        [request startRequest];
    }
}

/** 停止网络请求 */
- (void)stopRequest
{
    self.isStopRequest = YES;
}

/**
 *  队列中的请求返回后调用此方法
 *  私有方法，请求完成后回调此方法，用户不要调用
 *
 *  @param request 执行完毕的请求
 */
- (void)subRequestFinish:(CLWebRequest *)request
{
    // 最后一个请求完成，队列执行完毕
    if (request == [self.requestArray lastObject])
    {
        NSLog(@"%@ Queue请求：全部子请求完成", self.requestName);
        
        // 设置错误信息
        NSMutableArray *errorArray = [NSMutableArray array];
        for (CLWebRequest *request in self.requestArray)
        {
            if (request.error != nil)
            {
                [errorArray addObject:request.error];
            }
        }
        
        // 用户的回调Block
        if (self.requestFinishBlock)
            self.requestFinishBlock(nil, [errorArray copy]);
        
        // 框架的回调Block
        if (self.manageRequestFinishBlock)
            self.manageRequestFinishBlock();
        
        // 释放内存
        [self.requestArray removeAllObjects];
        self.requestArray = nil;
        
        return;
    }
    
    if (self.isStopRequest == YES)
    {
        NSLog(@"%@ Queue请求：请求终止", self.requestName);
        
        // 用户的回调Block
        if (self.requestFinishBlock)
            self.requestFinishBlock(nil, nil);
        
        // 框架的回调Block
        if (self.manageRequestFinishBlock)
            self.manageRequestFinishBlock();
        
        // 释放内存
        [self.requestArray removeAllObjects];
        self.requestArray = nil;
        
        return;
    }
    
    // 执行下一个请求
    NSUInteger index = [self.requestArray indexOfObject:request];
    CLWebRequest *nextRequest = self.requestArray[++index];
    [nextRequest startRequest];
}

@end
