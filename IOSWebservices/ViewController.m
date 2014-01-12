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
-(void)dealloc{
    [super dealloc];
    [_helper release],_helper=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _helper=[[ServiceHelper alloc] init];
    
  
   
  
    
    /**
     [result.xmlParse setDataSource:result.filterXml];
     NSArray *arr=[result.xmlParse soapXmlSelectNodes:result.xpath];
     NSLog(@"result=%@",arr);
     ***/
    
    
    /*********注意事项***************/
    
    /***(1)如果返回的是json字符串，则可以调用以下方法直接转换成json对象
     
     id json=[result json];
     
    ***/
    
    /***(2)如果发现返回的soap xml字符串不能解析,则执行以下操作进行解析
     
     [result.xmlParse setDataSource:result.filterXml];
     NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//查询的字符串"];
     
     ***/

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//同步请求
- (IBAction)SyncClick:(id)sender {
    /**(1)调用其它的webservice并有参数**
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"道道香食府",@"userName", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123456",@"passWord", nil]];
    ServiceArgs *args1=[[[ServiceArgs alloc] init] autorelease];
    args1.serviceURL=@"http://117.27.136.236:9000/WebServer/Phone/PHoneWebServer.asmx";
    args1.serviceNameSpace=@"http://www.race.net.cn";
    args1.methodName=@"EnterpriseLogin";
    args1.soapParams=params;
    NSLog(@"soap=%@\n",args1.soapMessage);
    ServiceResult *result=[ServiceHelper syncService:args1];
    NSLog(@"xml=%@\n",[result.request responseString]);
    ***/
  
    /**(2)调用无参数的webservice**/
    [self showLoadingAnimatedWithTitle:@"正在同步..."];
    ServiceResult *result=[ServiceHelper syncMethodName:@"getForexRmbRate"];
    NSLog(@"同步请求xml=%@\n",result);
   
    /********[--如果无法解析，请启用以下两句--]**********
     NSString* xml=[result.xmlString stringByReplacingOccurrencesOfString:result.xmlnsAttr withString:@""];
     [result.xmlParse setDataSource:xml];
     ****/
    NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
    [self hideLoadingSuccessWithTitle:@"同步完成!" completed:nil];
    
}
//异步请求deletegated
- (IBAction)asyncDelegatedClick:(id)sender {
    [self showLoadingAnimatedWithTitle:@"正在执行异步请求deletegated,请稍等..."];
    [_helper asynServiceMethodName:@"getForexRmbRate" delegate:self];
}
//异步请求block
- (IBAction)asyncBlockClick:(id)sender {
    NSLog(@"异步请求block\n");
    [self showLoadingAnimatedWithTitle:@"正在执行异步block请求,请稍等..."];
    [_helper asynServiceMethodName:@"getForexRmbRate" success:^(ServiceResult *result) {
        BOOL boo=strlen([result.xmlString UTF8String])>0?YES:NO;
        if (boo) {
            [self hideLoadingSuccessWithTitle:@"block请求成功!" completed:nil];
        }else{
            [self hideLoadingFailedWithTitle:@"block请求失败!" completed:nil];
        }
        NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
        NSLog(@"解析xml结果=%@\n",arr);
        
        
        
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"error=%@\n",[error description]);
        [self hideLoadingFailedWithTitle:@"block请求失败!" completed:nil];
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
        [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
            [self showSuccessViewWithHide:^(AnimateErrorView *errorView) {
                errorView.labelTitle.text=@"排队列请求完成！";
            } completed:nil];
        }];
    }];
}
#pragma mark -
#pragma mark ServiceHelperDelegate Methods
-(void)finishSoapRequest:(ServiceResult*)result{
    
    NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
    BOOL boo=strlen([result.xmlString UTF8String])>0?YES:NO;
    if (boo) {
        [self hideLoadingSuccessWithTitle:@"deletegated请求成功!" completed:nil];
    }else{
        [self hideLoadingFailedWithTitle:@"deletegated请求失败!" completed:nil];
    }
}
-(void)failedSoapRequest:(NSError*)error userInfo:(NSDictionary*)dic{
 NSLog(@"error=%@\n",[error description]);
   [self hideLoadingFailedWithTitle:@"deletegated请求失败!" completed:nil];
}
@end
