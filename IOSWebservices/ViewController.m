//
//  ViewController.m
//  IosWebService
//
//  Created by rang on 13-6-29.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /********************事项说明*****************************/
    //(1)亲，可以使用XmlParseHelper类去解析返回的xml
    
    
    /*(2)***webservice有参数的方法调用写法******
     
     //参数
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"queryBFlist",@"tradeCode", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"account", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"password", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"01",@"accountType", nil]];
     
     //设置传递对象
     ServiceArgs *args=[[[ServiceArgs alloc] init] autorelease];
     args.methodName=@"AddMethod";
     args.soapParams=params;
     
     //调用webservice
     [[ServiceHelper sharedInstance] asynService:args completed:^(NSString *xml, NSDictionary *userInfo) {
     
         NSLog(@"xml=%@\n",xml);
     
     } failed:^(NSError *error, NSDictionary *userInfo) {
     
         NSLog(@"error=%@\n",[error description]);
     
     }];
     
   ***/
    
    /*(3)**非默认配置webservice方法调用写法******
     
     //参数
     NSMutableArray *params=[NSMutableArray array];
     [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"queryBFlist",@"tradeCode", nil]];
     [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"account", nil]];
     [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"password", nil]];
     [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"01",@"accountType", nil]];
     
     //设置传递对象
     ServiceArgs *args=[[[ServiceArgs alloc] init] autorelease];
     args1.serviceURL=@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";
     args1.serviceNameSpace=@"http://WebXml.com.cn/";
     args.methodName=@"AddMethod";
     args.soapParams=params;
     
     //调用webservice
     [[ServiceHelper sharedInstance] asynService:args completed:^(NSString *xml, NSDictionary *userInfo) {
     
     NSLog(@"xml=%@\n",xml);
     
     } failed:^(NSError *error, NSDictionary *userInfo) {
     
     NSLog(@"error=%@\n",[error description]);
     
     }];
     
     ***/

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//同步请求
- (IBAction)SyncClick:(id)sender {
    
    ServiceResult *result=[ServiceHelper syncMethodName:@"getForexRmbRate"];
    NSLog(@"同步请求xml=%@\n",result);
    NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
}
//异步请求deletegated
- (IBAction)asyncDelegatedClick:(id)sender {
    NSLog(@"异步请求deletegated\n");
    [ServiceHelper asynMethodName:@"getForexRmbRate" delegate:self];
}
//异步请求block
- (IBAction)asyncBlockClick:(id)sender {
    NSLog(@"异步请求block\n");
    [ServiceHelper asynMethodName:@"getForexRmbRate" completed:^(ServiceResult *result) {
        NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
        NSLog(@"解析xml结果=%@\n",arr);

    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"error=%@\n",[error description]);
    }];
}
//队列请求
- (IBAction)queueClick:(id)sender {
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

    //执行队列
    [helper startQueue:^(ServiceResult *result) {
        NSString *name=[result.userInfo objectForKey:@"name"];
        NSLog(@"%@请求成功，xml=%@",name,result.xmlString);
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSString *name=[userInfo objectForKey:@"name"];
        NSLog(@"%@请求失败，失败原因:%@",name,[error description]);
    } complete:^{
         NSLog(@"排队列请求完成！\n");
    }];
}
#pragma mark -
#pragma mark ServiceHelperDelegate Methods
-(void)finishSoapRequest:(ServiceResult*)result{
    //NSLog(@"输出xml=%@\n",xml);
    NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
}
-(void)failedSoapRequest:(NSError*)error userInfo:(NSDictionary*)dic{
 NSLog(@"error=%@\n",[error description]);
}
@end
