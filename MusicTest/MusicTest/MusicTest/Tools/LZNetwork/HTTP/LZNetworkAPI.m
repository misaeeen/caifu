//
//  LZNetworkAPI.m
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZNetworkAPI.h"
#import <AFNetworking.h>
#import "LZUserManger.h"




@implementation LZNetworkAPI

+ (NSString *)baseURLString {
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"kURL_BASE_FRONT"];
    if (baseUrl.length == 0) {
        return kURL_BASE_FRONT;
    }else{
        return baseUrl;
    }
}

+ (NSTimeInterval)baseTimeout {
    return 15.f;
}

+ (AFHTTPSessionManager *)session {
    return [self initSession];
}
/// 初始化Session
+ (AFHTTPSessionManager *)initSession {
    
    // inint
    AFHTTPSessionManager *_session = [AFHTTPSessionManager manager];
    
    // 请求配置
    _session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    // 默认超时时间
    _session.requestSerializer.timeoutInterval = self.baseTimeout;
    
    // 返回配置
    _session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    _session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _session.securityPolicy.allowInvalidCertificates = YES;
    
    _session.securityPolicy.validatesDomainName = NO;
    
    // 添加响数据类型
    _session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/xml", nil];
    
    
    return _session;
}


// headers
+ (NSDictionary *)requestHeaders {
    NSMutableDictionary *headers = @{}.mutableCopy;

    // accessToken token令牌
    if ([LZUserManger authorization].length != 0) {
        [headers setObject:[LZUserManger authorization] forKey:@"Authorization"];
    }
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    return headers;
}

/// 后缀拼接
+ (NSString *)appendServicerURL:(NSString *)servicerURL {
    NSMutableString *url = self.baseURLString.mutableCopy;
    if (![servicerURL hasPrefix:@"/"]) {
        [url appendString:@"/"];
    }
    [url appendString:servicerURL];
    return url;
}

+ (NSURLSessionTask *)POST:(NSString *)urlSuffix param:(NSDictionary *)param block:(LZNetworkBlock)block{
    NSString *url = [self appendServicerURL:urlSuffix];
    if (!param) param = @{};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSMutableURLRequest *req =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    req.HTTPMethod = @"POST";

    req.timeoutInterval= self.baseTimeout;

    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([LZUserManger authorization].length != 0) {
        [req setValue:[LZUserManger authorization] forHTTPHeaderField:@"Authorization"];
    }
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;

    NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!error) {
                [self handleResult:responseObject url:url block:block];
            }else{
                [self handleResult:error url:url block:block];
            }
//        });
    }];

    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionTask *)GET:(NSString *)urlSuffix param:(NSDictionary *)param block:(LZNetworkBlock)block{
    NSString *url = [self appendServicerURL:urlSuffix];
    if (!param) param = @{};
    
    NSDictionary *headers = [self requestHeaders];
    
    return [self.session GET:url parameters:param headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResult:responseObject url:url block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleResult:error url:url block:block];
        
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)urlSuffix image:(UIImage *)image parmeters:(NSDictionary *)param block:(LZNetworkBlock)block{
    NSString *url = [self appendServicerURL:urlSuffix];
    if (!param) param = @{};
    AFHTTPSessionManager *manager = self.session;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([LZUserManger authorization].length != 0) {
        [manager.requestSerializer setValue:[LZUserManger authorization] forHTTPHeaderField:@"Authorization"];
    }
    return [manager POST:url parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:@"photo.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleResult:responseObject url:url block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleResult:error url:url block:block];
        
    }];
    
}

// 处理失败详情
+ (void)handleResult:(id)result
                       url:(NSString *)urlString
                     block:(LZNetworkBlock)block {
    NSLog(@"%@",result);
    if ([result isKindOfClass:[NSError class]]) {
        block(nil,result);
        return;
    }
    LZNetworkResult *model = [LZNetworkResult yy_modelWithJSON:result];
    if (model) {//&& [ret valueForKey:@"code"]
        block(model,nil);
    } else {
        // 处理返回数据nil的错误
        block(nil,[NSError new]);
    }
}

@end
