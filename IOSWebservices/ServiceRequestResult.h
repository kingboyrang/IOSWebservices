//
//  ServiceURLConnectionResult.h
//  IOSWebservices
//
//  Created by aJia on 2014/2/18.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceArgs.h"
@interface ServiceRequestResult : NSObject
@property(nonatomic,retain) ServiceArgs *args;
@property(nonatomic,retain) NSURLRequest *request;
@property(nonatomic,retain) NSDictionary *userInfo;
@property(nonatomic,readonly) NSString *xmlnsAttr;//xmlns="命名空间"
@property(nonatomic,readonly) NSString *searchName;//方法名+Result
@property(nonatomic,readonly) NSString *xpath;//==>两斜扛+方法名+Result
@property(nonatomic,copy) NSString *xmlString;
+(id)resultWithRequest:(NSURLRequest*)httpRequest params:(ServiceArgs*)param;
@end
