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
/**(注:webservice通过soap字符串传递请求返回的是xml,而我们想要的内容是＝＝》请求的方法名+Result==>这个节点里面的内容)
 @param methodName:webserivce请求的方法名
 @return 返回webservice请求内容
 */
-(NSString*)soapMessageResultXml:(NSString*)methodName;
/** 查询单个节点的信息
 @param  xpath:表示要查询的节点如("//name")
 @return 获取节点内容,节点名以及其它
 */
-(XmlNode*)selectSingleNode:(NSString*)xpath;
/** 查询单个节点的信息(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点(如:"//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @return 获取节点内容,节点名以及其它
 */
-(XmlNode*)selectSingleNode:(NSString*)xpath namespaces:(NSDictionary*)spaces;
/** 根据路径查询节点的信息(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点如("//name")
 @return 获取节点内容,节点名以及其它
 */
-(NSArray*)selectNodes:(NSString*)xpath;
/** 根据路径查询节点的信息(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点(如:"//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @return 获取查询节点内容,节点名以及其它
 */
-(NSArray*)selectNodes:(NSString*)xpath namespaces:(NSDictionary*)spaces;
/** 根据路径查询节点的信息
 @param  xpath:表示要查询的节点(如:"//name")
 @param  forObject:将节点的子节点转换成对象
 @return 获取查询的节点转换成对象保存在数组中
 */
-(NSArray*)selectNodes:(NSString*)xpath forObject:(Class)cls;
/** 根据路径查询节点的信息
 @param  xpath:表示要查询的节点(如:"//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @param  forObject:将节点的子节点转换成对象
 @return 获取查询的节点转换成对象保存在数组中
 */
-(NSArray*)selectNodes:(NSString*)xpath namespaces:(NSDictionary*)spaces forObject:(Class)cls;
/** 将某个节点下子节点转换成对象
 @param  node:当前要转换的节点
 @param  forObject:将节点的子节点转换成对象
 @return 获取节点的子元素转换成对象
 */
-(id)nodeToObject:(GDataXMLNode*)node forObject:(Class)cls;
/***************************对于webservice返回soap xml内容的查询****************/
/** 查询单个节点的信息
 @param  xpath:表示要查询的节点如("//name")
 @return 获取节点内容,节点名以及其它
 */
-(XmlNode*)soapXmlSelectSingleNode:(NSString*)xpath;
/** 根据路径查询节点的信息
 @param  xpath:表示要查询的节点如("//name")
 @return 获取节点内容,节点名以及其它
 */
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath;
/** 根据路径查询节点的信息
 @param  xpath:表示要查询的节点(如:"//name")
 @param  forObject:将节点的子节点转换成对象
 @return 获取查询的节点转换成对象保存在数组中
 */
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath forObject:(Class)cls;
/** 查询节点的属性值
 @param  node:节点对象
 @return 获取当前节点的属性值
 */
-(NSDictionary*)getXmlNodeAttrs:(GDataXMLNode*)node;
/** 查询单个节点的属性值
 @param  xpath:表示要查询的节点如("//name")
 @return 获取当前节点的属性值
 */
-(NSDictionary*)selectSingleNodeAttrs:(NSString*)xpath;
/** 查询单个节点的属性值(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点如("//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @return 获取当前节点的属性值
 */
-(NSDictionary*)selectSingleNodeAttrs:(NSString*)xpath namespaces:(NSDictionary*)spaces;
/** 查询节点的属性值
 @param  xpath:表示要查询的节点如("//name")
 @return 获取多个节点的属性值
 */
-(NSArray*)selectNodeAttrs:(NSString*)xpath;
/** 查询节点的属性值(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点如("//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @return 获取多个节点的属性值
 */
-(NSArray*)selectNodeAttrs:(NSString*)xpath namespaces:(NSDictionary*)spaces;
/** 取得节点的值
 @param  node:节点对象
 @return 获取节点的值
 */
-(NSString*)getXmlNodeValue:(GDataXMLNode*)node;
/** 查询单个节点的值
 @param  node:节点对象
 @return 获取节点的值
 */
-(NSString*)selectSingleNodeValue:(NSString*)xpath;
/** 查询单个节点的值(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点如("//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @return 获取单个节点的值
 */
-(NSString*)selectSingleNodeValue:(NSString*)xpath namespaces:(NSDictionary*)spaces;
/** 查询节点的值
 @param  xpath:表示要查询的节点如("//name")
 @return 获取节点的值
 */
-(NSArray*)selectNodeValues:(NSString*)xpath;
/** 查询节点的值(注：xml带有自定义的命名空间)
 @param  xpath:表示要查询的节点如("//name")
 @param  namespaces:xml命名空间集合(如:@{@"xsi":@"http://www.w3.org/2001/XMLSchema-instance",@"xsd",@"http://www.w3.org/2001/XMLSchema"})
 @return 获取多个节点的值
 */
-(NSArray*)selectNodeValues:(NSString*)xpath namespaces:(NSDictionary*)spaces;
/** 根节点子元素转换成对象
 @param  cls:表示要转换成的对象
 @return 获取根节点子素对象集合
 */
-(NSArray*)childNodesToObject:(Class)cls;
/** 根节点子元素
 @return 获取根节点子元素集合
 */
-(NSArray*)childNodesToArray;
//辅助方法
-(id)childsNodeToObject:(GDataXMLNode*)node forObject:(Class)cls;
-(NSArray*)nodesChildsNodesToObjects:(GDataXMLNode*)node forObject:(Class)cls;
@end
