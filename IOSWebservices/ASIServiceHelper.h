//
//  ASIServiceHelper.h
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

//block
typedef void (^queueFinishBlock)(ASIHTTPRequest *request);
typedef void (^queueFailedBlock)(NSError *error,NSDictionary *userInfo);
typedef void (^queueCompleteBlock)(NSArray *results);

@interface ASIServiceHelper : NSObject
-(void)setFinishBlock:(queueFinishBlock)aFinishBlock;
-(void)setFailedBlock:(queueFailedBlock)aFailedBlock;
-(void)setCompleteBlock:(queueCompleteBlock)aCompleteBlock;
-(void)addQueue:(ASIHTTPRequest*)request;
-(void)addQueues:(NSArray*)requests;
-(void)startQueue;
-(void)startQueue:(queueFinishBlock)finish failed:(queueFailedBlock)failed complete:(queueCompleteBlock)finishQueue;
-(void)clearAndDelegate;
@end
