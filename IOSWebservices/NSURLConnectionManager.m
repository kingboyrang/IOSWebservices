//
//  NSURLConnectionManager.m
//  IOSWebservices
//
//  Created by aJia on 2014/2/18.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "NSURLConnectionManager.h"

@interface NSURLConnectionManager ()
@property (nonatomic,retain) NSURLRequest *request;
@property (nonatomic,retain) NSMutableData *receiveData;
@property (nonatomic,retain) ServiceArgs *params;
- (NSString*)soapAction:(NSString*)namespace methodName:(NSString*)methodName;
- (ServiceArgs*)requestToArgs:(NSURLRequest*)request;
@end

@implementation NSURLConnectionManager
-(void)dealloc{
    [self cancel];
	[super dealloc];
}
- (id)initWithRequest:(NSURLRequest*)request{
    if (self=[super init]) {
        self.request=request;
        self.params=[self requestToArgs:request];
    }
    return self;
}
- (id)initWithArgs:(ServiceArgs*)args{
    if (self=[super init]) {
        self.params=args;
        self.request=[self requestWithArgs:args];
    }
    return self;
}
+ (id)requestWithRequest:(NSURLRequest*)request{
    return [[[self alloc] initWithRequest:request] autorelease];
}
+ (id)requestWithArgs:(ServiceArgs*)args{
    return [[[self alloc] initWithArgs:args] autorelease];
}
- (void)setFinishBlock:(requestFinishBlock)afinishBlock{
    if (_finishBlock!=afinishBlock) {
        [_finishBlock release];
        _finishBlock=[afinishBlock copy];
    }
}
- (void)setFailedBlock:(requestFailedBlock)afailedBlock{
    if (_failedBlock!=afailedBlock) {
        [_failedBlock release];
        _failedBlock=[afailedBlock copy];
    }
}
- (void)setSuccessBlock:(requestSuccessBlock)asuccessBlock{
    if (_successBlock!=asuccessBlock) {
        [_successBlock release];
        _successBlock=[asuccessBlock copy];
    }
}
- (NSURLRequest*)requestWithArgs:(ServiceArgs*)args{
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:args.webURL];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [args.soapMessage length]];
    NSString *soapAction=[self soapAction:args.serviceNameSpace methodName:args.methodName];
    //头部设置
    NSDictionary *headField=[NSDictionary dictionaryWithObjectsAndKeys:[args.webURL host],@"Host",
                             @"text/xml; charset=utf-8",@"Content-Type",
                             msgLength,@"Content-Length",
                             soapAction,@"SOAPAction",nil];
    [request setAllHTTPHeaderFields:headField];
    //超时设置
    [request setTimeoutInterval: 30 ];
    //访问方式
    [request setHTTPMethod:@"POST"];
    //body内容
    [request setHTTPBody:[args.soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}
- (void)startAsynchronous{
    if (!self.receiveData) {
        self.receiveData=[NSMutableData data];
    }
    if (_receiveData) {
        [_receiveData setLength:0];
    }
    if (self.request) {
        [self cancel];//取消前一次请求
        NSURLConnection *conn=[[self class] connectionWithRequest:self.request delegate:self];
        //[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        if (conn) {
            
        }
    }
}
- (void)startSynchronous{
    if (self.request) {
       // [self cancel];//取消前一次请求
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLResponse *response=nil;
            NSError *error=nil;
            NSData *data=[[self class] sendSynchronousRequest:self.request returningResponse:&response error:&error];
            //请求完成
            NSString *xml=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ServiceRequestResult *result=[ServiceRequestResult resultWithRequest:self.request params:self.params];
            result.xmlString=xml;
            result.userInfo=self.userInfo;
            [xml release];
            if (self.successBlock) {
                self.successBlock(result,error);
            }
        });
    }
}
#pragma mark -
#pragma mark NSURLConnection delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // store data
    [_receiveData setLength:0];      //通常在这里先清空接受数据的缓存
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];    //可能多次收到数据，把新的数据添加在现有数据最后
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSMutableURLRequest *request=(NSMutableURLRequest*)connection.currentRequest;
    ServiceRequestResult *result=[ServiceRequestResult resultWithRequest:request params:self.params];
    result.xmlString=@"";
    result.userInfo=self.userInfo;
    if (self.failedBlock) {
        self.failedBlock(result,error);
    }
    //[connection cancel];
    connection=nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *xml=[[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=(NSMutableURLRequest*)connection.currentRequest;
    ServiceRequestResult *result=[ServiceRequestResult resultWithRequest:request params:self.params];
    result.xmlString=xml;
    result.userInfo=self.userInfo;
    [xml release];
    if(self.finishBlock)
    {
        self.finishBlock(result);
    }
    connection=nil;
    //[_receiveData setLength:0];//清空
}
#pragma mark -private Methods
-(NSString*)soapAction:(NSString*)namespace methodName:(NSString*)methodName{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/$" options:0 error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:namespace options:0 range:NSMakeRange(0, [namespace length])];
    //NSArray *array=[regex matchesInString:namespace options:0 range:NSMakeRange(0, [namespace length])];
    if(numberOfMatches>0){
        return [NSString stringWithFormat:@"%@%@",namespace,methodName];
    }
    return [NSString stringWithFormat:@"%@/%@",namespace,methodName];
}
-(ServiceArgs*)requestToArgs:(NSURLRequest*)request{
    NSMutableURLRequest *req=(NSMutableURLRequest*)request;
    
    NSString *soap=[[NSString alloc] initWithData:req.HTTPBody encoding:NSUTF8StringEncoding];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.soapMessage=soap;
    args.serviceURL=req.URL.absoluteString;
    
    [soap release];
    
    NSDictionary *dic=req.allHTTPHeaderFields;
    if (dic&&[dic.allKeys containsObject:@"SOAPAction"]) {
        NSString *soapAction=[dic objectForKey:@"SOAPAction"];
        NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
        if(range.location!=NSNotFound){
            int pos=range.location;
            args.serviceNameSpace=[soapAction substringWithRange:NSMakeRange(0, pos+1)];
            int len=[args.serviceNameSpace length];
            args.methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0,len) withString:@""];
        }
    }
    if (!self.userInfo) {
        self.userInfo=dic;
    }
    return [args autorelease];
}
@end
