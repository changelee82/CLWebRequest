//
//  CLDes3EncryptForWeb.m
//  CLDes3Encrypt
//
//  Created by 李辉 on 15/12/22.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "CLDes3EncryptForWeb.h"


@implementation CLDes3EncryptForWeb


/**  单例模式 */
+ (CLDes3EncryptForWeb *)sharedInstance
{
    __strong static CLDes3EncryptForWeb* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


/**
 *  加密字符串
 *
 *  @param originalString 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
- (NSString *)encryptString:(NSString *)originalString
{
    NSString *string = [super encryptString:originalString];
    
    // 删除字符串尾部的“＝”
    while ([[string substringFromIndex:string.length - 1] isEqualToString:@"="])
    {
        string = [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    
    // 将“/”、“+”替换成”_“
    string = [string stringByReplacingOccurrencesOfString: @"/" withString: @"-"];
    string = [string stringByReplacingOccurrencesOfString: @"+" withString: @"_"];
    
    return string;
}

/**
 *  解密字符串
 *
 *  @param encryptedString 经过加密的字符串
 *
 *  @return 解密后的字符串
 */
- (NSString *)decryptString:(NSString *)encryptedString
{
    NSString *string = encryptedString;
    
    // 替换特殊符号
    string = [string stringByReplacingOccurrencesOfString:@"-" withString: @"/"];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString: @"+"];
    
    // 用0补全4位
    int num = string.length % 4;
    if (num > 0)
    {
        for (int i = 0; i < 4-num; i++ )
        {
            string = [string stringByAppendingString:@"="];
        }
    }
    
    return [super decryptString:string];
}

@end
