//
//  CLWebRequestError.h
//  CLWebRequest
//
//  Created by 李辉 on 15/12/9.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求错误信息
 */
@interface CLWebRequestError : NSObject

/** 请求名称 */
@property (nonatomic, copy) NSString *requestName;

/** 请求错误码 */
@property (nonatomic, assign) NSInteger errorCode;

/** 请求错误信息 */
@property (nonatomic, copy) NSString *errorMessage;

@end