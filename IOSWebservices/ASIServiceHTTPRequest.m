//
//  ASIServiceHTTPRequest.m
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ASIServiceHTTPRequest.h"

@interface ASIServiceHTTPRequest ()
- (void)initRequestParams;
@end

@implementation ASIServiceHTTPRequest
@synthesize ServiceResult=_sr;
-(void)dealloc{
    if (_sr) {
        [_sr release],_sr=nil;
    }
    [self clearDelegatesAndCancel];
    [super dealloc];
}
+ (id)requestWithArgs:(ASIServiceArgs*)args{
    ASIServiceHTTPRequest *req=[[[self alloc] initWithURL:[args requestURL]] autorelease];
    req.ServiceArgs=args;
    return req;
}
+ (id)requestWithMethodName:(NSString*)name{
    ASIServiceArgs *args=[ASIServiceArgs serviceMethodName:name];
    return [self requestWithArgs:args];
}
- (void)setServiceArgs:(ASIServiceArgs *)args
{
    if (_ServiceArgs!=args) {
        [_ServiceArgs release];
        _ServiceArgs=[args retain];
        _sr=nil;
    }
}
-(ASIServiceResult*)ServiceResult
{
    if (_sr==nil) {
        _sr=[[ASIServiceResult instanceWithRequest:(ASIHTTPRequest*)self ServiceArgs:self.ServiceArgs] retain];
    }
    return _sr;
}
- (void)success:(ASIBasicBlock)aCompletionBlock failure:(ASIBasicBlock)aFailedBlock{
    [self setCompletionBlock:aCompletionBlock];
    [self setFailedBlock:aFailedBlock];
    [self startAsynchronous];
}
- (NSString*)synchronousWithError:(NSError**)error{
    [self startSynchronous];
    *error=[self error];
    if ([self error]) {
        return [self responseString];
    }
    return @"";
}
- (void)startSynchronous{
    [self initRequestParams];
    [super startSynchronous];
}
- (void)startAsynchronous{
    [self initRequestParams];
    [super startAsynchronous];
}
- (void)initRequestParams{
    if (self.ServiceArgs) {
        [self setURL:[self.ServiceArgs requestURL]];
        //头部设置
        [self setRequestHeaders:(NSMutableDictionary*)[self.ServiceArgs headers]];
        //超时设置
        [self setTimeOutSeconds:self.ServiceArgs.timeOutSeconds];
        //访问方式
        [self setRequestMethod:self.ServiceArgs.httpWay==ASIServiceHttpGet?@"GET":@"POST"];
        //设置编码
        [self setDefaultResponseEncoding:self.ServiceArgs.defaultEncoding];
        //body内容
        if (self.ServiceArgs.httpWay!=ASIServiceHttpGet) {
            [self appendPostData:[self.ServiceArgs.bodyMessage dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
}
@end
