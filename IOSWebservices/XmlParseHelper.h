//
//  XmlParseHelper.h
//  IOSWebservices
//
//  Created by rang on 13-8-8.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"
@class GDataXMLNode;
@class GDataXMLDocument;
@interface XmlParseHelper : NSObject

@property(nonatomic,retain) GDataXMLDocument *document;
@property(nonatomic,readonly) XmlNode *xmlNode;

-(void)setDataSource:(id)data;
-(id)initWithData:(id)xml;
//返回webservice内容
-(NSString*)soapMessageResultXml:(NSString*)methodName;
//查询
-(XmlNode*)selectSingleNode:(NSString*)xpath;
-(XmlNode*)selectSingleNode:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
-(NSArray*)selectNodes:(NSString*)xpath;
-(NSArray*)selectNodes:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
-(NSArray*)selectNodes:(NSString*)xpath forObject:(Class)cls;
-(NSArray*)selectNodes:(NSString*)xpath nameSpaces:(NSDictionary*)spaces forObject:(Class)cls;
//将某个节点下子节点转换成对象
-(id)nodeToObject:(GDataXMLNode*)node forObject:(Class)cls;
//对于webservice返回soap xml内容的查询
-(XmlNode*)soapXmlSelectSingleNode:(NSString*)xpath;
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath;
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath forObject:(Class)cls;
//取得节点属性
-(NSDictionary*)getXmlNodeAttrs:(GDataXMLNode*)node;
-(NSDictionary*)selectSingleNodeAttrs:(NSString*)xpath;
-(NSDictionary*)selectSingleNodeAttrs:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
-(NSArray*)selectNodeAttrs:(NSString*)xpath;
-(NSArray*)selectNodeAttrs:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
//取得节点值
-(NSString*)getXmlNodeValue:(GDataXMLNode*)node;
-(NSString*)selectSingleNodeValue:(NSString*)xpath;
-(NSString*)selectSingleNodeValue:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
-(NSArray*)selectNodeValues:(NSString*)xpath;
-(NSArray*)selectNodeValues:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;

-(NSArray*)childNodesToObject:(Class)cls;
-(NSArray*)childNodesToArray;
//辅助方法
-(id)childsNodeToObject:(GDataXMLNode*)node forObject:(Class)cls;
-(NSArray*)nodesChildsNodesToObjects:(GDataXMLNode*)node forObject:(Class)cls;
@end
