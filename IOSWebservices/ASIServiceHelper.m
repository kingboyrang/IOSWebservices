//
//  ASIServiceHelper.m
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ASIServiceHelper.h"
#import "ASINetworkQueue.h"

@interface ASIServiceHelper ()
@property(nonatomic,retain) ASINetworkQueue *networkQueue;
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
    Block_release(_failedBlock);
    Block_release(_finishBlock);
    Block_release(_completeBlock);
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
     //Block_release(_finishBlock);
    //_finishBlock=Block_copy(aFinishBlock);
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
    Block_release(_failedBlock);
    Block_release(_finishBlock);
    Block_release(_completeBlock);
    
    _finishBlock=Block_copy(finish);
    _failedBlock=Block_copy(failed);
    _completeBlock=Block_copy(finishQueue);
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
    if (_completeBlock) {
        _completeBlock(_queueResults);
    }
    [self clearAndDelegate];
}
-(void)requestFetchComplete:(ASIHTTPRequest*)request{
    if (_finishBlock) {
        _finishBlock(request);
    }
    if (_queueResults) {
        [_queueResults addObject:request];
    }
}
-(void)requestFetchFailed:(ASIHTTPRequest*)request{
    if (_failedBlock) {
        _failedBlock([request error],[request userInfo]);
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
