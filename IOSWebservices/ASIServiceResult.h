//
//  ASIServiceResult.h
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "XmlParseHelper.h"
#import "XmlNode.h"
#import "ASIServiceArgs.h"
@interface ASIServiceResult : NSObject
@property(nonatomic,retain) ASIHTTPRequest *request;
@property(nonatomic,retain) ASIServiceArgs *args;//命名空间
@property(nonatomic,readonly) NSString *xmlString;//原始返回的soap字符串
@property(nonatomic,readonly) NSString *filterXml;//替换悼命名空名的xml
@property(nonatomic,readonly) NSString *xmlnsAttr;//xmlns="命名空间"
@property(nonatomic,readonly) NSString *searchName;//方法名+Result
@property(nonatomic,readonly) NSString *xpath;//==>//方法名+Result
@property(nonatomic,readonly) XmlNode *methodNode;//取得方法节点的内容
@property(nonatomic,readonly) BOOL success;//是否成功
@property(nonatomic,readonly) id json;//将返回结果转换成json对象[如返回的是json字符串就使用这个对象]
@property(nonatomic,retain) XmlParseHelper *xmlParse;//xml转换类
@property(nonatomic,copy) NSString *xmlValue;//调用webservice方法里面的值
+(ASIServiceResult*)instanceWithRequest:(ASIHTTPRequest*)httpRequest ServiceArgs:(ASIServiceArgs*)arg;
@end
