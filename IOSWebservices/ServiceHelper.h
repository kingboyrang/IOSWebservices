//
//  ServiceHelper.h
//  HttpRequest
//
//  Created by aJia on 2012/10/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ServiceArgs.h"
#import "ServiceResult.h"
#import "XmlParseHelper.h"
//block
typedef void (^progressRequestBlock)(ASIHTTPRequest *request);
typedef void (^finishBlockRequest)(ServiceResult *result);
typedef void (^failedBlockRequest)(NSError *error,NSDictionary *userInfo);
typedef void (^finishBlockQueueComplete)(NSArray *results);
//protocol
@protocol ServiceHelperDelegate<NSObject>
@optional
-(void)progressRequest:(ASIHTTPRequest*)request;
-(void)finishSoapRequest:(ServiceResult*)result;
-(void)failedSoapRequest:(NSError*)error userInfo:(NSDictionary*)dic;
-(void)finishQueueComplete:(NSArray*)results;
@end

@interface ServiceHelper : NSObject{
@private
    finishBlockRequest _finishBlock;
    failedBlockRequest _failedBlock;
    finishBlockQueueComplete _finishQueueBlock;
    progressRequestBlock _progressBlock;
    
    NSMutableArray *_queueResults;
    NSMutableArray *_requestList;
     
}
@property(nonatomic,assign) id<ServiceHelperDelegate> delegate;
@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
@property(nonatomic,retain) ASINetworkQueue *networkQueue;
//单例模式
+ (ServiceHelper *)sharedInstance;
//初始化
-(id)initWithDelegate:(id<ServiceHelperDelegate>)theDelegate;

/******设置公有的请求****/
-(ASIHTTPRequest*)commonSharedRequest:(ServiceArgs*)args;
+(ASIHTTPRequest*)commonSharedRequest:(ServiceArgs*)args;
/*****同步请求***/
-(ServiceResult*)syncService:(ServiceArgs*)args;
-(ServiceResult*)syncService:(ServiceArgs*)args error:(NSError**)error;
-(ServiceResult*)syncServiceMethodName:(NSString*)methodName;
-(ServiceResult*)syncServiceMethodName:(NSString*)methodName error:(NSError**)error;
+(ServiceResult*)syncService:(ServiceArgs*)args;
+(ServiceResult*)syncService:(ServiceArgs*)args error:(NSError**)error;
+(ServiceResult*)syncMethodName:(NSString*)methodName;
+(ServiceResult*)syncMethodName:(NSString*)methodName error:(NSError**)error;
/*****异步请求***/
-(void)asynService:(ServiceArgs*)args;
-(void)asynService:(ServiceArgs*)args delegate:(id<ServiceHelperDelegate>)theDelegate;
-(void)asynService:(ServiceArgs*)args success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
-(void)asynService:(ServiceArgs*)args progress:(void(^)(ASIHTTPRequest*))progress success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
-(void)asynServiceMethodName:(NSString*)methodName delegate:(id<ServiceHelperDelegate>)theDelegate;
-(void)asynServiceMethodName:(NSString*)methodName success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
-(void)asynServiceMethodName:(NSString*)methodName progress:(void(^)(ASIHTTPRequest*))progress success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
+(void)asynService:(ServiceArgs*)args delegate:(id<ServiceHelperDelegate>)theDelegate;
+(void)asynService:(ServiceArgs*)args success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
+(void)asynService:(ServiceArgs*)args progress:(void(^)(ASIHTTPRequest*))progress success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
+(void)asynMethodName:(NSString*)methodName delegate:(id<ServiceHelperDelegate>)theDelegate;
+(void)asynMethodName:(NSString*)methodName success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
+(void)asynMethodName:(NSString*)methodName progress:(void(^)(ASIHTTPRequest*))progress success:(void(^)(ServiceResult* result))finished failed:(void(^)(NSError *error,NSDictionary *userInfo))failed;
/*****队列请求***/
-(void)addQueue:(ASIHTTPRequest*)request;
-(void)addRangeQueue:(NSArray*)requests;
-(void)startQueue;
-(void)startQueue:(id<ServiceHelperDelegate>)theDelegate;
-(void)startQueue:(finishBlockRequest)finish failed:(failedBlockRequest)failed complete:(finishBlockQueueComplete)finishQueue;
@end
