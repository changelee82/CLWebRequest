//
//  CLWebRequestGroup.m
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLWebRequestGroup.h"


@interface CLWebRequestGroup ()

/**
 *  组内网络请求队列
 */
@property (nonatomic, strong) NSMutableArray *requestArray;

/**
 *  组内当前已经完成的子请求数量
 */
@property (nonatomic, assign) NSUInteger subRequestFinishedCount;

/**
 *  组内子请求完成后，执行此方法通知所属的请求组对象
 */
- (void)subRequestFinish;

@end



@implementation CLWebRequestGroup

- (instancetype)init
{
    if(self = [super init])
    {
        self.requestName = @"未命名组";
        _requestArray = [NSMutableArray array];
    }
    return self;
}

/**
 *  向组内添加网络请求
 *
 *  @param request 网络请求
 */
- (void)addSubRequest:(CLWebRequest *)request
{
    // 当前的网络请求
    [self.requestArray addObject:request];
    
    // 设置请求结束的Block
    request.manageRequestFinishBlock = ^()
    {
        // 通知当前组，此请求完成
        [self subRequestFinish];
    };
}

/**
 *  执行网络请求组
 */
- (void)startRequest
{
    // 请求即将开始，准备请求参数
    if (self.requestWillStartBlock)
        self.requestWillStartBlock();
    
    NSLog(@"%@ Group请求：开始", self.requestName);
    
    // 处理没有子请求的情况
    if (self.requestArray.count == 0)
    {
        NSLog(@"%@ Group请求：没有可执行的子请求，直接返回", self.requestName);
        
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
    
    // 同时开启所有子请求
    self.subRequestFinishedCount = 0;
    for (CLWebRequest *requestTask in self.requestArray)
    {
        [requestTask startRequest];
    }
}


/**
 *  组内子请求完成后，执行此方法通知所属的请求组对象
 */
- (void)subRequestFinish
{
    self.subRequestFinishedCount++;
    
    // 组内请求全部完成
    if (self.subRequestFinishedCount == self.requestArray.count)
    {
        NSLog(@"%@ Group请求：全部子请求完成", self.requestName);
        
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
    }
}

@end
