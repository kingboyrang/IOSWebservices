//
//  ServiceResult.m
//  TPLibrary
//
//  Created by rang on 13-8-6.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ServiceResult.h"
@implementation ServiceResult
@synthesize request;
@synthesize userInfo;
@synthesize xmlParse;
@synthesize xmlString;
@synthesize xmlValue;
@synthesize nameSpace;
@synthesize methodName;
@synthesize xmlnsAttr;
-(NSString*)nameSpace{
    if (!nameSpace) {
        if (self.request) {
            NSString *soapAction=[[self.request requestHeaders] objectForKey:@"SOAPAction"];
            NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
            if(range.location!=NSNotFound){
                int pos=range.location;
                nameSpace=[soapAction substringWithRange:NSMakeRange(0, pos+1)];
            }
        }

    }
    return nameSpace;
}
-(NSString*)methodName{
    if (!methodName) {
        if (self.request) {
            int len=[self.nameSpace length];
            NSString *soapAction=[[self.request requestHeaders] objectForKey:@"SOAPAction"];
            if(len>0){
                methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0,len) withString:@""];
            }
        }
    }
    return methodName;
        
}
-(NSDictionary*)userInfo{
    if (!userInfo) {
        if (self.request) {
            userInfo=[self.request userInfo];
        }
    }
    return userInfo;
}
-(NSString*)xmlString{
    if (!xmlString) {
        if (self.request) {
            NSString *temp=[self.request responseString];
            int statusCode = [self.request responseStatusCode];
            NSError *error=[self.request error];
            //如果发生错误，就返回空
            if (error||statusCode!=200) {
                temp=@"";
            }
            xmlString=temp;
        }
    }
    return xmlString;
}
-(NSString*)xmlnsAttr{
    return [NSString stringWithFormat:@"xmlns=\"%@\"",[self nameSpace]];
}
-(NSString*)searchName{
    if (methodName&&[methodName length]>0) {
        return [NSString stringWithFormat:@"%@Result",[self methodName]];
    }
    return @"";
}
-(NSString*)xpath{
    NSString *str=[self searchName];
    if ([str length]>0) {
        return [NSString stringWithFormat:@"//%@",str];
    }
    return @"";
}
-(NSString*)filterXml{
    if (xmlString&&[xmlString length]>0) {
        return [xmlString stringByReplacingOccurrencesOfString:[self xmlnsAttr] withString:@""];
    }
    return @"";
}
-(XmlNode*)methodNode{
    NSString *xml=[self filterXml];
    if ([xml length]>0) {
        //XmlParseHelper *_helper=[[[XmlParseHelper alloc] initWithData:xml] autorelease];
        [self.xmlParse setDataSource:xml];
        return [self.xmlParse soapXmlSelectSingleNode:[self xpath]];
    }
    return nil;
}
- (id)json{
    XmlNode *node=[self methodNode];
    if (node!=nil&&[node.InnerText length]>0) {
        return [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
    }
    return nil;
}
-(BOOL)hasSuccess{
    if (xmlString&&[xmlString length]>0)return YES;
    return NO;
}
+(id)requestResult:(ASIHTTPRequest*)httpRequest{
    ServiceResult *entity=[[ServiceResult alloc] init];
    entity.request=httpRequest;
    XmlParseHelper *_helper=[[[XmlParseHelper alloc] initWithData:entity.xmlString] autorelease];
    entity.xmlParse=_helper;
    entity.xmlValue=[_helper soapMessageResultXml:entity.methodName];
    return [entity autorelease];
}
@end
