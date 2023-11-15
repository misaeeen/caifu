//
//  Aes.m
//  MusicTest
//
//  Created by LZZ on 2021/1/31.
//  Copyright © 2021 CF. All rights reserved.
//

#import "Aes.h"
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import "GTMBase64.h"
#import "NSData+AES.h"

#import <CommonCrypto/CommonCryptor.h>

#define GIV             @"AbG67fH[2021]V69" //自行修改

@implementation Aes


+(NSString *)AES128Encrypt:(NSString *)plainText{
    NSData *data = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKey:GIV gIv:GIV];
    return [GTMBase64 stringByEncodingData:data];
}
 
+(NSString *)AES128Decrypt:(NSString *)encryptText{
    NSData *data = [[GTMBase64 decodeString:encryptText] AES128DecryptWithKey:GIV gIv:GIV];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
