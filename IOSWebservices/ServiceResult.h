//
//  ServiceResult.h
//  TPLibrary
//
//  Created by rang on 13-8-6.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "XmlParseHelper.h"
#import "XmlNode.h"
@interface ServiceResult : NSObject
@property(nonatomic,retain) ASIHTTPRequest *request;
@property(nonatomic,readonly) NSDictionary *userInfo;
@property(nonatomic,readonly) NSString *nameSpace;//命名空间
@property(nonatomic,readonly) NSString *methodName;//方法名
@property(nonatomic,readonly) NSString *xmlnsAttr;//xmlns="命名空间"
@property(nonatomic,readonly) NSString *filterXml;//替换悼命名空名的xml
@property(nonatomic,readonly) NSString *searchName;//方法名+Result
@property(nonatomic,readonly) NSString *xpath;//==>//方法名+Result
@property(nonatomic,readonly) XmlNode *methodNode;//取得方法节点的内容
@property(nonatomic,readonly) BOOL hasSuccess;//是否成功
@property(nonatomic,readonly) id json;//将返回结果转换成json对象[说明:如返回的是json字符串就使用这个对象]
//xml转换类
@property(nonatomic,retain) XmlParseHelper *xmlParse;
//原始返回的soap字符串
@property(nonatomic,readonly) NSString *xmlString;
//调用webservice方法里面的值
@property(nonatomic,copy) NSString *xmlValue;
+(id)requestResult:(ASIHTTPRequest*)httpRequest;
@end
