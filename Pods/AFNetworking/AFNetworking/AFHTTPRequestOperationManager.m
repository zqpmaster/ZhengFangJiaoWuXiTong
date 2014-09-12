// AFHTTPRequestOperationManager.m
//
// Copyright (c) 2013-2014 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"

#import <Availability.h>
#import <Security/Security.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#endif

@interface AFHTTPRequestOperationManager ()
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@end

@implementation AFHTTPRequestOperationManager

+ (instancetype)manager {
    return [[self alloc] initWithBaseURL:nil];
}

- (instancetype)init {
    return [self initWithBaseURL:nil];    
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }

    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }

    self.baseURL = url;

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    self.securityPolicy = [AFSecurityPolicy defaultPolicy];

    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];

    self.operationQueue = [[NSOperationQueue alloc] init];

    self.shouldUseCredentialStorage = YES;

    return self;
}

#pragma mark -

#ifdef _SYSTEMCONFIGURATION_H
#endif

- (void)setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer {
    NSParameterAssert(requestSerializer);

    _requestSerializer = requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);

    _responseSerializer = responseSerializer;
}

#pragma mark -

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;

    [operation setCompletionBlockWithSuccess:success failure:failure];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;

    return operation;
}

#pragma mark -
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    //以下为后加的代码
    
    
    if(self.cookieDictionary) {
        NSMutableDictionary*newDictionary=[self.cookieDictionary mutableCopy];
        
        [newDictionary setValue:@"http://gdjwgl.bjut.edu.cn/xs_main.aspx?xh=11021235" forKey:@"Referer"];
        
        //
        //         NSEnumerator * enumeratorValue = [newDictionary objectEnumerator];
        //         //快速枚举遍历所有Value和Key
        //         NSLog(@"Cookie输出开始");
        //
        //         for (NSObject *object in enumeratorValue) {
        //         NSLog(@"遍历Value的值: %@",object);
        //         }
        //         NSEnumerator * enumeratorKey = [newDictionary keyEnumerator];
        //
        //         for (NSObject *object in enumeratorKey) {
        //         NSLog(@"遍历KEY的值: %@",object);
        //         }
        //
        
        
        //        [request setAllHTTPHeaderFields:newDictionary];
        //        [request setHTTPShouldHandleCookies:NO];
        [request setAllHTTPHeaderFields:newDictionary];
        
    }
    
    //结束 提交Cookie
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *requestOperation, __unused id responseObject) {
        if (success) {
            success(requestOperation);
        }
    } failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    //
    //    if(self.cookieDictionary) {
    //        [request setHTTPShouldHandleCookies:NO];
    //        [request setAllHTTPHeaderFields:self.cookieDictionary];
    //    }
    ////
    
    if(self.cookieDictionary) {
        
        NSMutableDictionary*newDictionary=[self.cookieDictionary mutableCopy];
        //        [newDictionary setValue:@"http://gdjwgl.bjut.edu.cn/xscjcx.aspx?xh=11024132&xm=%D5%C5%C8%AB%C5%F4&gnmkdm=N121605" forKey:@"Referer"];
        
        [newDictionary setValue:@"http://gdjwgl.bjut.edu.cn/xs_main.aspx?xh=11111111" forKey:@"Referer"];
        
        
        
        //
        //         NSEnumerator * enumeratorValue = [newDictionary objectEnumerator];
        //         //快速枚举遍历所有Value和Key
        //         NSLog(@"Cookie输出开始");
        //
        //         for (NSObject *object in enumeratorValue) {
        //         NSLog(@"遍历Value的值: %@",object);
        //         }
        //         NSEnumerator * enumeratorKey = [newDictionary keyEnumerator];
        //
        //         for (NSObject *object in enumeratorKey) {
        //         NSLog(@"遍历KEY的值: %@",object);
        //         }
        //
        
        
        //        [request setAllHTTPHeaderFields:newDictionary];
        //        [request setHTTPShouldHandleCookies:NO];
        [request setAllHTTPHeaderFields:newDictionary];
        
    }
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    //以下为后加的代码
    /*
     NSEnumerator * enumeratorValue = [self.cookieDictionary objectEnumerator];
     //快速枚举遍历所有Value和Key
     NSLog(@"Cookie输出开始");
     
     for (NSObject *object in enumeratorValue) {
     NSLog(@"遍历Value的值: %@",object);
     }
     NSEnumerator * enumeratorKey = [self.cookieDictionary keyEnumerator];
     
     for (NSObject *object in enumeratorKey) {
     NSLog(@"遍历KEY的值: %@",object);
     }
     */
    //
    
    //提交Cookie
    //后加的代码结束
    return operation;
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, baseURL: %@, operationQueue: %@>", NSStringFromClass([self class]), self, [self.baseURL absoluteString], self.operationQueue];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSURL *baseURL = [decoder decodeObjectForKey:NSStringFromSelector(@selector(baseURL))];

    self = [self initWithBaseURL:baseURL];
    if (!self) {
        return nil;
    }

    self.requestSerializer = [decoder decodeObjectOfClass:[AFHTTPRequestSerializer class] forKey:NSStringFromSelector(@selector(requestSerializer))];
    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.baseURL forKey:NSStringFromSelector(@selector(baseURL))];
    [coder encodeObject:self.requestSerializer forKey:NSStringFromSelector(@selector(requestSerializer))];
    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPRequestOperationManager *HTTPClient = [[[self class] allocWithZone:zone] initWithBaseURL:self.baseURL];

    HTTPClient.requestSerializer = [self.requestSerializer copyWithZone:zone];
    HTTPClient.responseSerializer = [self.responseSerializer copyWithZone:zone];
    
    return HTTPClient;
}
//后加的代码

-(NSDictionary*)cookieDictionary{
    if (!_cookieDictionary) {
        //       NSDictionary *cookieDe=[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"cookie"];
        //       if(cookieDe) return cookieDe;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gdjwgl.bjut.edu.cn/default2.aspx"]];
        //  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
        //timeoutInterval:3];
        
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:nil
                                          error:nil];
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies =[cookieJar cookies];
        _cookieDictionary= [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        //       _cookieDictionary=nil;
    }
    
    
    return _cookieDictionary;
    //获取cookie
}

@end
