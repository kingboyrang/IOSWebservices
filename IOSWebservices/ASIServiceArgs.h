//
//  ASIServiceArgs.h
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
//请求方式(ServiceHttpSoap1与ServiceHttpSoap12的区别在于请求头不一样)
typedef enum{
    ASIServiceHttpGet=0,
    ASIServiceHttpPost=1,
    ASIServiceHttpSoap1=2,
    ASIServiceHttpSoap12=3
}ASIServiceHttpWay;

@interface ASIServiceArgs : NSObject
@property(nonatomic,readonly) ASIHTTPRequest *request;
@property(nonatomic,readonly) NSURL *webURL;
@property(nonatomic,readonly) NSString *defaultSoapMesage;
@property(nonatomic,assign)   ASIServiceHttpWay httpWay;//请求方式,默认为ServiceHttpSoap12请求
@property(nonatomic,assign)   NSTimeInterval timeOutSeconds;//请求超时时间,默认60秒
@property(nonatomic,copy)     NSString *serviceURL;//webservice访问地址
@property(nonatomic,copy)     NSString *serviceNameSpace;//webservice命名空间
@property(nonatomic,copy)     NSString *methodName;//调用的方法名
@property(nonatomic,copy)     NSString *bodyMessage;//请求字符串
@property(nonatomic,copy)     NSString *soapHeader;//有认证的请求头设置
@property(nonatomic,retain)   NSDictionary *headers;//请求头
@property(nonatomic,retain)   NSArray *soapParams;//参数设置

-(NSURL*)requestURL;
+(ASIServiceArgs*)serviceMethodName:(NSString*)methodName;
+(ASIServiceArgs*)serviceMethodName:(NSString*)methodName soapMessage:(NSString*)soapMsg;
//webservice访问设置
+(void)setNameSapce:(NSString*)space;
+(void)setWebServiceURL:(NSString*)url;
@end
