//
//  ServiceArgs.m
//  CommonLibrary
//
//  Created by aJia on 13/2/20.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ServiceArgs.h"

@interface ServiceArgs()
-(NSString*)paramsFormatString:(NSArray*)params;
@end

static NSString *defaultWebServiceUrl=@"http://webservice.webxml.com.cn/WebServices/ForexRmbRateWebService.asmx";
static NSString *defaultWebServiceNameSpace=@"http://webxml.com.cn/";

@implementation ServiceArgs
@synthesize serviceURL,serviceNameSpace;
@synthesize methodName,soapMessage;
@synthesize webURL,headers,defaultSoapMesage;
@synthesize soapParams;


+(void)setWebServiceURL:(NSString*)url
{
    if (defaultWebServiceUrl!=url) {
        [defaultWebServiceUrl release];
        defaultWebServiceUrl=[url retain];
    }
}
+(void)setNameSapce:(NSString*)space
{
    if (defaultWebServiceNameSpace!=space) {
        [defaultWebServiceNameSpace release];
        defaultWebServiceNameSpace=[space retain];
    }
}

#pragma mark -
#pragma mark 属性重写
-(NSString*)defaultSoapMesage{
    NSString *soapBody=@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>%@</soap:Body></soap:Envelope>";
    return soapBody;
}
-(NSURL*)webURL{
    return [NSURL URLWithString:[self serviceURL]];
}
-(NSString*)serviceURL{
    if (serviceURL) {
        return serviceURL;
    }
    return defaultWebServiceUrl;
}
-(NSString*)serviceNameSpace{
    if (serviceNameSpace) {
        return serviceNameSpace;
    }
    return defaultWebServiceNameSpace;
}
-(NSString*)soapMessage{
    if (soapMessage) {
        return soapMessage;
    }
    return [self stringSoapMessage:[self soapParams]];
}
-(NSMutableDictionary*)headers{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setValue:[[self webURL] host] forKey:@"Host"];
    [dic setValue:@"text/xml; charset=utf-8" forKey:@"Content-Type"];
    [dic setValue:[NSString stringWithFormat:@"%d",[[self soapMessage] length]] forKey:@"Content-Length"];
    [dic setValue:[NSString stringWithFormat:@"%@%@",[self serviceNameSpace],[self methodName]] forKey:@"SOAPAction"];
    return dic;
}
#pragma mark -
#pragma mark 私有方法
-(NSString*)paramsFormatString:(NSArray*)params{
    NSMutableString *xml=[NSMutableString stringWithFormat:@""];
    for (NSDictionary *item in params) {
        NSString *key=[[item allKeys] objectAtIndex:0];
        [xml appendFormat:@"<%@>",key];
        [xml appendString:[item objectForKey:key]];
        [xml appendFormat:@"</%@>",key];
    }
    return xml;
}
#pragma mark -
#pragma mark 公有方法
-(NSString*)stringSoapMessage:(NSArray*)params{
    if (params) {
        NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\" >",[self methodName],[self serviceNameSpace]];
        
        [soap appendString:[self paramsFormatString:params]];
        [soap appendFormat:@"</%@>",[self methodName]];
        
        return [NSString stringWithFormat:[self defaultSoapMesage],soap];
    }
    NSString *body=[NSString stringWithFormat:@"<%@ xmlns=\"%@\" />",[self methodName],[self serviceNameSpace]];
    return [NSString stringWithFormat:[self defaultSoapMesage],body];
}
+(ServiceArgs*)serviceMethodName:(NSString*)methodName{
    return [self serviceMethodName:methodName soapMessage:nil];
}
+(ServiceArgs*)serviceMethodName:(NSString*)name soapMessage:(NSString*)msg{
    ServiceArgs *args=[[[ServiceArgs alloc] init] autorelease];
    args.methodName=name;
    if (msg&&[msg length]>0) {
        args.soapMessage=msg;
    }else{
        args.soapMessage=[args stringSoapMessage:nil];
    }
    return args;
}
@end
