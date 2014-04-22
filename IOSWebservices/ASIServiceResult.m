//
//  ASIServiceResult.m
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ASIServiceResult.h"

@implementation ASIServiceResult
-(NSString*)xmlnsAttr{
    if (self.args&&self.args.serviceNameSpace&&[self.args.serviceNameSpace length]>0) {
        return [NSString stringWithFormat:@"xmlns=\"%@\"",[self.args serviceNameSpace]];
    }
    return @"";
}
-(NSString*)searchName{
    NSString *name=[self.args methodName];
    if ([name length]>0) {
        return [NSString stringWithFormat:@"%@Result",name];
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
-(NSString*)xpath{
    NSString *str=[self searchName];
    if ([str length]>0) {
        return [NSString stringWithFormat:@"//%@",str];
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
-(BOOL)success{
    if (_request) {
        int statusCode = [_request responseStatusCode];
        NSError *error=[_request error];
        //如果发生错误，就返回空
        if (error||statusCode!=200) {
            return NO;
        }
    }
    return YES;
}
- (id)json{
    XmlNode *node=[self methodNode];
    if (node!=nil&&[node.InnerText length]>0) {
        return [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
    }
    return nil;
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
+(ASIServiceResult*)instanceWithRequest:(ASIHTTPRequest*)httpRequest ServiceArgs:(ASIServiceArgs*)args{
    ASIServiceResult *sr=[[ASIServiceResult alloc] init];
    sr.request=httpRequest;
    sr.args=args;
    XmlParseHelper *_helper=[[[XmlParseHelper alloc] initWithData:sr.xmlString] autorelease];
    sr.xmlParse=_helper;
    sr.xmlValue=[_helper soapMessageResultXml:sr.args.methodName];
    return [sr autorelease];
}
@end
