//
//  ServiceURLConnectionResult.m
//  IOSWebservices
//
//  Created by aJia on 2014/2/18.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ServiceRequestResult.h"

@implementation ServiceRequestResult

- (NSString*)xmlnsAttr{
    if (_args) {
        return [NSString stringWithFormat:@"xmlns=\"%@\"",[_args serviceNameSpace]];
    }
    return @"";
}
-(NSString*)searchName{
    if (_args) {
        NSString *name=[_args methodName];
        if ([name length]>0) {
            return [NSString stringWithFormat:@"%@Result",name];
        }
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
+(id)resultWithRequest:(NSURLRequest*)httpRequest params:(ServiceArgs*)param{
    ServiceRequestResult *result=[[ServiceRequestResult alloc] init];
    result.request=httpRequest;
    result.args=param;
    return [result autorelease];
}
@end
