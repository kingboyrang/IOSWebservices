//
//  ASIServiceHelper.m
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ASIServiceHelper.h"
#import "ASINetworkQueue.h"

@interface ASIServiceHelper (){
    NSMutableArray *_queueResults;
    NSMutableArray *_requestList;
}
@property(nonatomic,retain) ASINetworkQueue *networkQueue;
@property (readwrite, nonatomic, copy) queueFinishBlock finishBlock;
@property (readwrite, nonatomic, copy) queueFailedBlock failedBlock;
@property (readwrite, nonatomic, copy) queueCompleteBlock completeBlock;
-(void)resetQueue;
@end

@implementation ASIServiceHelper
-(void)dealloc{
    if (self.networkQueue) {
        [self.networkQueue reset];
        [self.networkQueue release];
    }
    if (_requestList) {
        [_requestList release];
    }
    if (_queueResults) {
        [_queueResults release];
    }
	[super dealloc];
}
- (id)init{
    if (self=[super init]) {
        _requestList=nil;
        _queueResults=nil;
    }
    return self;
}
- (void)setFinishBlock:(queueFinishBlock)aFinishBlock{
    if (_finishBlock!=aFinishBlock) {
        [_finishBlock release];
        _finishBlock=[aFinishBlock copy];
    }
}
- (void)setFailedBlock:(queueFailedBlock)aFailedBlock{
    if (_failedBlock!=aFailedBlock) {
        [_failedBlock release];
        _failedBlock=[aFailedBlock copy];
    }
}
- (void)setCompleteBlock:(queueCompleteBlock)aCompleteBlock{
    if (_completeBlock!=aCompleteBlock) {
        [_completeBlock release];
        _completeBlock=[aCompleteBlock copy];
    }
}
//添加队列
-(void)addQueue:(ASIHTTPRequest*)request{
    if (!_requestList) {
        _requestList=[[NSMutableArray alloc] init];
        if (!_queueResults) {
            _queueResults=[[NSMutableArray alloc] init];
        }else{
            [_queueResults removeAllObjects];
        }
    }
    if (![_requestList containsObject:request]) {
         [_requestList addObject:request];
    }
}
-(void)addQueues:(NSArray*)requests{
    if (!_requestList) {
        _requestList=[[NSMutableArray alloc] init];
        if (!_queueResults) {
            _queueResults=[[NSMutableArray alloc] init];
        }else{
            [_queueResults removeAllObjects];
        }
    }
    [_requestList removeAllObjects];
    [_requestList addObjectsFromArray:requests];
}
-(void)startQueue{
    [self resetQueue];
    for (ASIHTTPRequest *item in _requestList) {
        [self.networkQueue addOperation:item];
    }
    [self.networkQueue go];
}
-(void)startQueue:(queueFinishBlock)finish failed:(queueFailedBlock)failed complete:(queueCompleteBlock)finishQueue{
    
    self.finishBlock=finish;
    self.failedBlock=failed;
    self.completeBlock=finishQueue;
    [self startQueue];
}
-(void)clearAndDelegate{
    if (_requestList) {
        [_requestList removeAllObjects];
    }
    if (_queueResults) {
        [_queueResults removeAllObjects];
    }
    if (self.networkQueue) {
        [self.networkQueue reset];
    }
}
#pragma mark -Queue delegate Methods
-(void)queueFetchComplete:(ASIHTTPRequest*)request{
   
    if (self.completeBlock) {
        self.completeBlock(_queueResults);
    }
    if (_requestList) {
        [_requestList removeAllObjects];
    }
    if (_queueResults) {
        [_queueResults removeAllObjects];
    }
}
-(void)requestFetchComplete:(ASIHTTPRequest*)request{
    if (_queueResults) {
        [_queueResults addObject:request];
    }
    if (self.finishBlock) {
        if (_queueResults&&[_queueResults count]>0) {
            self.finishBlock([_queueResults lastObject]);
        }else{
           self.finishBlock(request);
        }
    }    
}
-(void)requestFetchFailed:(ASIHTTPRequest*)request{
    if (self.failedBlock) {
        self.failedBlock([request error],[request userInfo]);
    }
}
#pragma mark -private Methods
//开始排列
-(void)resetQueue{
    if (!self.networkQueue) {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }
    [self.networkQueue reset];
    //表示队列操作完成
    [self.networkQueue setQueueDidFinishSelector:@selector(queueFetchComplete:)];
    [self.networkQueue setRequestDidFinishSelector:@selector(requestFetchComplete:)];
    [self.networkQueue setRequestDidFailSelector:@selector(requestFetchFailed:)];
    [self.networkQueue setDelegate:self];
}
@end
