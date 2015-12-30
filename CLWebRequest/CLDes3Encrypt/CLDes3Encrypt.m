//
//  CLDes3Encrypt.m
//  CLDes3Encrypt
//
//  Created by 李辉 on 15/12/22.
//  Copyright © 2015年 李辉. All rights reserved.
//  https://github.com/changelee82/CLDes3Encrypt
//

#import "CLDes3Encrypt.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


@implementation CLDes3Encrypt

- (id)init
{
    movedBytes  = 0;
    bufferPtr   = NULL;
    _encryptKey = (_encryptKey == nil)? [self get24BitKey:@"abcd12345678901234567890"]: [self get24BitKey:_encryptKey];
    return [super init];
}

- (id)initWithKey:(NSString *)keyString
{
    _encryptKey = keyString;
    return [self init];
}

#pragma mark -- 全局方法

/**  单例模式 */
+ (CLDes3Encrypt *)sharedInstance
{
    __strong static CLDes3Encrypt* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

/**  为单例对象设置全局Key */
+ (void)setSharedKey:(NSString *)keyString
{
    [self sharedInstance].encryptKey = [[self sharedInstance] get24BitKey:keyString];
}

/**  使用全局Key，加密字符串 */
+ (NSString *)encryptString:(NSString *)originalString
{
    return [[self sharedInstance] encryptString:originalString];
}

/**  使用全局Key，解密字符串 */
+ (NSString *)decryptString:(NSString *)encryptedString
{
    return [[self sharedInstance] decryptString:encryptedString];
}


#pragma mark - hash_hmac('sha1',$public_key,$private_key,TRUE)

+ (NSString *)hmacSha1WithPublicKey:(NSString*)publicKey
                         privateKey:(NSString*)privateKey
{
    NSData* stringData = [publicKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData* secretData = [privateKey dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* dataBytes = [stringData bytes];
    const void* keyBytes = [secretData bytes];
    
    ///#define CC_SHA1_DIGEST_LENGTH   20          /* digest length in bytes */
    void* outs = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, keyBytes, [secretData length], dataBytes, [stringData length], outs);
    
    // Soluion 1
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    
    signatureData = [GTMBase64 encodeData:signatureData];
    NSString *base64String = [[NSString alloc] initWithData:signatureData encoding:NSUTF8StringEncoding];
    
    return base64String;
}


#pragma mark -- 私有方法

/**
 *  加密字符串
 *
 *  @param originalString 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
- (NSString *)encryptString:(NSString *)originalString
{
    NSData *originalStringData = [originalString dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferPtrSize = ([originalStringData length] + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                                       [_encryptKey UTF8String],
                                       kCCKeySize3DES,
                                       nil,
                                       (const void *)[originalStringData bytes],
                                       [originalStringData length],
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if(ccStatus != 0)
    {
        NSLog(@"加密错误，请检查key和加密字符串。");
        return @"";
    }
    
    NSString *string = [GTMBase64 stringByEncodingData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]];
    free(bufferPtr);
    NSMutableString *mStr = [[NSMutableString alloc]initWithString:string];
    
    // 删除字符串尾部的“＝”
//    while ([[mStr substringFromIndex:mStr.length - 1] isEqualToString:@"="])
//    {
//        mStr = [mStr substringWithRange:NSMakeRange(0, mStr.length - 1)];
//    }
    
    return mStr;
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
    NSData *encryptedStringData = [GTMBase64 decodeData:[encryptedString dataUsingEncoding:NSUTF8StringEncoding]];
    size_t stringBufferSize = [encryptedStringData length];
    size_t bufferPtrSize = (stringBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                                       [_encryptKey UTF8String],
                                       kCCKeySize3DES,
                                       nil,
                                       [encryptedStringData bytes],
                                       stringBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if(ccStatus != 0)
    {
        NSLog(@"解密错误，请检查key和加密字符串。");
        return @"";
    }
    
    NSString *string = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]
                                             encoding:NSUTF8StringEncoding];
    free(bufferPtr);
    
    return string;
}

/**
 *  对加密后的字符串进行处理
 *
 *  @param encryptedString 加密后的字符串
 *
 *  @return 处理后的字符串
 */
- (NSString *)afterEncryptString:(NSString *)encryptedString
{
    NSString *string = encryptedString;
    
    // 删除字符串尾部的“＝”
    while ([[string substringFromIndex:string.length - 1] isEqualToString:@"="])
    {
        string = [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    
    // 将“/”、“+”替换成”_“
    string = [string stringByReplacingOccurrencesOfString: @"/" withString: @"-"];
    string = [string stringByReplacingOccurrencesOfString: @"+" withString: @"_"];
    
    return string ;
}

/**
 *  在解密字符串之前对其进行处理
 *
 *  @param encryptedString 加密后的字符串
 *
 *  @return 处理后的字符串
 */
- (NSString *)beforeDecryptString:(NSString *)encryptedString
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
    
    return string;
}


/**
 *  获得24位Key
 *  如果字符串大于24位则取前24位，如果小于24位，则用0补全24位
 *
 *  @param keyString 字符串Key
 *
 *  @return 24位Key
 */
- (NSString *)get24BitKey:(NSString *)keyString
{
    if (keyString.length == 24)
        return keyString;
    
    if (keyString.length > 24)
    {
        keyString = [keyString substringWithRange:(NSRange){0, 24}];
    }
    else
    {
        keyString = [keyString stringByAppendingFormat:[NSString stringWithFormat:@"%%0%dd", 24 - keyString.length], 0];
    }
    
    return keyString;
}

@end
