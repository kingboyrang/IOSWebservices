//
//  ServiceResult.m
//  TPLibrary
//
//  Created by rang on 13-8-6.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ServiceResult.h"
@implementation ServiceResult

-(NSString*)nameSpace{
    if (_request) {
            NSString *soapAction=[[_request requestHeaders] objectForKey:@"SOAPAction"];
            NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
            if(range.location!=NSNotFound){
                int pos=range.location;
                return [soapAction substringWithRange:NSMakeRange(0, pos+1)];
            }
    }
    return @"";
}
-(NSString*)methodName{
        if (_request) {
            int len=[self.nameSpace length];
            NSString *soapAction=[[_request requestHeaders] objectForKey:@"SOAPAction"];
            if(len>0){
                return [soapAction stringByReplacingCharactersInRange:NSMakeRange(0,len) withString:@""];
            }
        }
   
    return @"";
        
}
-(NSDictionary*)userInfo{
        if (_request) {
           return [_request userInfo];
        }
   
    return [NSDictionary dictionary];
}
-(NSString*)xmlString{
        if (_request) {
            NSString *temp=[_request responseString];
            int statusCode = [_request responseStatusCode];
            NSError *error=[_request error];
            //如果发生错误，就返回空
            if (error||statusCode!=200) {
                temp=@"";
            }
            return temp;
        }
    
    return @"";
}
-(NSString*)xmlnsAttr{
    return [NSString stringWithFormat:@"xmlns=\"%@\"",[self nameSpace]];
}
-(NSString*)searchName{
    NSString *name=[self methodName];
    if ([name length]>0) {
        return [NSString stringWithFormat:@"%@Result",name];
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
    NSString *xml=[self xmlString];
    if ([xml length]>0) {
        return [xml stringByReplacingOccurrencesOfString:[self xmlnsAttr] withString:@""];
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
-(BOOL)success{
    if ([[self xmlString] length]>0)return YES;
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
