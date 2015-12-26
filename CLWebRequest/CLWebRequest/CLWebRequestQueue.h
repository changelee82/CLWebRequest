//
//  CLWebRequestQueue.h
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLWebRequest.h"



/**
 *  网络请求队列，用于把串行或并行的网络请求连接成一个网络请求组
 */
@interface CLWebRequestQueue : CLWebRequest


/** 向列队中添加网络请求 */
- (void)addSubRequest:(CLWebRequest *)request;

/** 停止执行网络请求 */
- (void)stopRequest;


@end
