//
//  NSURLConnectionManager.h
//  IOSWebservices
//
//  Created by aJia on 2014/2/18.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceArgs.h"
#import "ServiceRequestResult.h"
//block
typedef void (^requestFinishBlock)(ServiceRequestResult *result);
typedef void (^requestFailedBlock)(ServiceRequestResult *result,NSError *error);
typedef void (^requestSuccessBlock)(ServiceRequestResult *result,NSError *error);

@interface NSURLConnectionManager : NSURLConnection<NSURLConnectionDelegate>
@property (nonatomic,retain) NSDictionary *userInfo;
@property (readwrite, nonatomic, copy) requestFinishBlock finishBlock;
@property (readwrite, nonatomic, copy) requestFailedBlock failedBlock;
@property (readwrite, nonatomic, copy) requestSuccessBlock successBlock;
+ (id)requestWithRequest:(NSURLRequest*)request;
+ (id)requestWithArgs:(ServiceArgs*)args;
- (id)initWithRequest:(NSURLRequest*)request;
- (id)initWithArgs:(ServiceArgs*)args;
- (void)setFinishBlock:(requestFinishBlock)afinishBlock;
- (void)setFailedBlock:(requestFailedBlock)afailedBlock;
- (void)setSuccessBlock:(requestSuccessBlock)asuccessBlock;
- (NSURLRequest*)requestWithArgs:(ServiceArgs*)args;
//同步请求
- (void)startSynchronous;
//开始异步请求
- (void)startAsynchronous;
@end
