//
//  CLWebRequestGroup.h
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLWebRequest.h"



/**
 *  网络请求组，组中的请求并行执行，全部返回后调用请求组结束的Block
 */
@interface CLWebRequestGroup : CLWebRequest


/** 向组内添加网络请求 */
- (void)addSubRequest:(CLWebRequest *)request;


@end
