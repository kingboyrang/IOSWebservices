//
//  ASIServiceHTTPRequest.h
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIServiceArgs.h"
#import "ASIServiceResult.h"
@interface ASIServiceHTTPRequest : ASIHTTPRequest{
    ASIServiceResult *_sr;
}
@property(nonatomic,retain) ASIServiceArgs *ServiceArgs;
@property(nonatomic,readonly) ASIServiceResult *ServiceResult;
+(ASIServiceHTTPRequest*)requestWithArgs:(ASIServiceArgs*)args;
@end
