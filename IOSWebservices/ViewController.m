//
//  ViewController.m
//  IosWebService
//
//  Created by rang on 13-6-29.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "ASIServiceHelper.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)dealloc{
    [super dealloc];
    [_helper release],_helper=nil;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /***WebService2与WebService二选一使用,最好使用WebService2***/
    
    _helper=[[ServiceHelper alloc] init];
    
    /*********注意事项***************
   
    (1)如果返回的是json字符串，则可以调用以下方法直接转换成json对象
     
     id json=[result json];

    (2)如果发现返回的soap xml字符串不能解析,则执行以下操作进行解析
     
     [result.xmlParse setDataSource:result.filterXml];
     NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//查询的字符串"];
     
    (3)如果发现还是不能解析，请查看XmlParseHelper解析类或者了解一下 google GDataXML类库的使用
     
    (4)最后还是不懂如何使用，请下载自已所熟悉的xml解析类库去处理
     ***/
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//同步请求
- (IBAction)SyncClick:(id)sender {
    [self showLoadingAnimatedWithTitle:@"正在同步..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithMethodName:@"getForexRmbRate"];
    [request startSynchronous];
    NSLog(@"header=%@\n",request.ServiceArgs.headers);
    NSLog(@"soap=%@\n",request.ServiceArgs.bodyMessage);
    NSLog(@"同步请求xml=%@\n",request.responseString);
    ASIServiceResult *sr=[request ServiceResult];
    /***
     如果不懂得使用解析类，请自行下载所熟悉的解析类库去处理解析
     ***/
    NSLog(@"解析xml结果=%@\n",[sr.xmlParse selectNodes:@"//ForexRmbRate"]);
    [self hideLoadingSuccessWithTitle:@"同步完成!" completed:nil];
    
}
//异步请求deletegated
- (IBAction)asyncDelegatedClick:(id)sender {
    [self showLoadingAnimatedWithTitle:@"正在执行异步请求deletegated,请稍等..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithMethodName:@"getForexRmbRate"];
    [request setDelegate:self];
    [request startAsynchronous];
}
//异步请求block
- (IBAction)asyncBlockClick:(id)sender {
    [self showLoadingAnimatedWithTitle:@"正在执行异步block请求,请稍等..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithMethodName:@"getForexRmbRate"];
    //设置请求方式
    //request.ServiceArgs.httpWay=ASIServiceHttpPost;
    [request success:^{
        NSLog(@"请求头=%@",request.ServiceArgs.headers);
        NSLog(@"请求body=%@",request.ServiceArgs.bodyMessage);
        if (request.ServiceResult.success) {
            [self hideLoadingSuccessWithTitle:@"block请求成功!" completed:nil];
            NSArray *arr=[request.ServiceResult.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
            NSLog(@"解析xml结果=%@\n",arr);
        }else{
            [self hideLoadingFailedWithTitle:@"block请求失败" completed:nil];
        }
    } failure:^{
        NSLog(@"error=%@\n",request.error.description);
        [self hideLoadingFailedWithTitle:@"block请求失败!" completed:nil];
    }];
}
//队列请求
- (IBAction)queueClick:(id)sender {
    /***
    ServiceHelper *helper=[ServiceHelper sharedInstance];
    //添加队列1
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequest:[ServiceArgs serviceMethodName:@"getForexRmbRate"]];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"request1",@"name", nil]];
    [helper addQueue:request1];
    //添加队列2
    ServiceArgs *args1=[[[ServiceArgs alloc] init] autorelease];
    args1.serviceURL=@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";
    args1.serviceNameSpace=@"http://WebXml.com.cn/";
    args1.methodName=@"getDatabaseInfo";
    ASIHTTPRequest *request2=[ServiceHelper commonSharedRequest:args1];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"request2",@"name", nil]];
    [helper addQueue:request2];

     [self showLoadingAnimatedWithTitle:@"正在执行队列请求,请稍等..."];
    //执行队列
    [helper startQueue:^(ServiceResult *result) {
        NSString *name=[result.userInfo objectForKey:@"name"];
        NSLog(@"%@请求成功，xml=%@",name,result.xmlString);
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSString *name=[userInfo objectForKey:@"name"];
        NSLog(@"%@请求失败，失败原因:%@",name,[error description]);
    } complete:^(NSArray *results) {
        NSLog(@"排队列请求完成！\n");
        [self hideLoadingSuccessWithTitle:@"排队列请求完成！" completed:nil];
    }];
     ***/
    
    
    ASIServiceHelper *helper=[[ASIServiceHelper alloc] init];
    //添加队列1
    ASIHTTPRequest *request1=[[ASIServiceArgs serviceMethodName:@"getForexRmbRate"] request];
    //ASIServiceHTTPRequest *request1=[ASIServiceHTTPRequest requestWithMethodName:@"getForexRmbRate"];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"request1",@"name", nil]];
    [helper addQueue:request1];
    //添加队列2
    ASIServiceArgs *args1=[[[ASIServiceArgs alloc] init] autorelease];
    args1.serviceURL=@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";
    args1.serviceNameSpace=@"http://WebXml.com.cn/";
    args1.methodName=@"getDatabaseInfo";
    ASIHTTPRequest *request2=[args1 request];
    //ASIServiceHTTPRequest *request2=[ASIServiceHTTPRequest requestWithArgs:args1];
    [request2 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"request2",@"name", nil]];
    [helper addQueue:request2];
    
    [self showLoadingAnimatedWithTitle:@"正在执行队列请求,请稍等..."];
    //执行队列
    [helper startQueue:^(ASIHTTPRequest *request) {
        NSString *name=[request.userInfo objectForKey:@"name"];
        NSLog(@"%@请求成功，xml=%@",name,request.responseString);
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSString *name=[userInfo objectForKey:@"name"];
        NSLog(@"%@请求失败，失败原因:%@",name,[error description]);
    } complete:^(NSArray *results) {
        NSLog(@"排队列请求完成！\n");
        [self hideLoadingSuccessWithTitle:@"排队列请求完成！" completed:nil];
    }];
}
#pragma mark -
#pragma mark ServiceHelperDelegate Methods
- (void)requestFinished:(ASIServiceHTTPRequest *)request{
    
    NSArray *arr=[request.ServiceResult.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
    if (request.ServiceResult.success) {
        [self hideLoadingSuccessWithTitle:@"deletegated请求成功!" completed:nil];
    }else{
        [self hideLoadingFailedWithTitle:@"deletegated请求失败!" completed:nil];
    }
}
- (void)requestFailed:(ASIServiceHTTPRequest *)request{
 NSLog(@"error=%@\n",[request.error description]);
   [self hideLoadingFailedWithTitle:@"deletegated请求失败!" completed:nil];
}
@end
