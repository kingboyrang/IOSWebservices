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
+(id)requestResult:(ASIHTTPRequest*)httpRequest{
    ServiceResult *entity=[[ServiceResult alloc] init];
    entity.request=httpRequest;
    entity.userInfo=[httpRequest userInfo];
    //entity.xmlString=[httpRequest responseString];
    NSString *temp=[httpRequest responseString];
    int statusCode = [httpRequest responseStatusCode];
    NSError *error=[httpRequest error];
    //如果发生错误，就返回空
    if (error||statusCode!=200) {
        temp=@"";
    }
    NSString *soapAction=[[httpRequest requestHeaders] objectForKey:@"SOAPAction"];
    NSString *methodName=@"";
    NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.location!=NSNotFound){
        int pos=range.location;
        methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0, pos+1) withString:@""];
    }
    entity.xmlString=temp;
    XmlParseHelper *_helper=[[[XmlParseHelper alloc] initWithData:temp] autorelease];
    entity.xmlParse=_helper;
    entity.xmlValue=[_helper soapMessageResultXml:methodName];
  
    return [entity autorelease];
}
@end
