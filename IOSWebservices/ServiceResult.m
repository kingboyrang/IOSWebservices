//
//  ServiceResult.m
//  TPLibrary
//
//  Created by rang on 13-8-6.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ServiceResult.h"
@implementation ServiceResult
@synthesize request,userInfo;
@synthesize xmlParse;
@synthesize xmlValue,xmlString;
@synthesize nameSpace,methodName;
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
+(id)requestResult:(ASIHTTPRequest*)httpRequest{
    ServiceResult *entity=[[ServiceResult alloc] init];
    entity.request=httpRequest;
    XmlParseHelper *_helper=[[[XmlParseHelper alloc] initWithData:entity.xmlString] autorelease];
    entity.xmlParse=_helper;
    entity.xmlValue=[_helper soapMessageResultXml:entity.methodName];
    return [entity autorelease];
}
@end
