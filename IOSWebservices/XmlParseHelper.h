//
//  XmlParseHelper.h
//  IOSWebservices
//
//  Created by rang on 13-8-8.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"
#import "GDataXMLNode.h"
@interface XmlParseHelper : NSObject

@property(nonatomic,retain) GDataXMLDocument *document;
@property(nonatomic,readonly) XmlNode *xmlNode;

-(id)initWithData:(id)xml;
//返回webservice内容
-(NSString*)soapMessageResultXml:(NSString*)methodName;
//查询
-(XmlNode*)selectSingleNode:(NSString*)xpath;
-(XmlNode*)selectSingleNode:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
-(NSArray*)selectNodes:(NSString*)xpath;
-(NSArray*)selectNodes:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
-(NSArray*)selectNodes:(NSString*)xpath className:(NSString*)className;
-(NSArray*)selectNodes:(NSString*)xpath nameSpaces:(NSDictionary*)spaces className:(NSString*)className;
//对于webservice返回soap xml内容的查询
-(XmlNode*)soapXmlSelectSingleNode:(NSString*)xpath;
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath;
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath className:(NSString*)className;
@end
