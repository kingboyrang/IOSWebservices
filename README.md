IOSWebservices
==============
1.添加类库引用
------------
libz.dylib<br/>
MobileCoreServices.framework<br/>
libxml2.dylib<br/>
CFNetwork.framework<br/>
SystemConfiguration.framework<br/>

2.libxml2.dylib类库设置
------------
(1)Project->build Setting<br/>
(2)查找到Search paths中的Header Search Paths 点击它添加${SDKROOT}/usr/include/libxml2<br/>

如果添加了${SDKROOT}/usr/include/libxml2还是会报libxml/tree.h的错则把它修改成/usr/include/libxml2<br/>

3.修改webservice访问配置
------------
在项目中找到ServiceArgs类，把defaultWebSerivceUrl与defaultWebServiceNameSpace的值修改成自已的内容<br/>

4.使用说明
------------
### (1)同步请求<br/>
a.无参数的同步请求<br/>
<pre><code>
  ServiceResult *result=[ServiceHelper syncMethodName:@"getForexRmbRate"];
    NSLog(@"同步请求xml=%@\n",result.xmlString);
    NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
</code></pre>
b.有参数的同步请求
<pre><code>
 //参数
NSMutableArray *params=[NSMutableArray array];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"queryBFlist",@"tradeCode", nil]];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"account", nil]];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"password", nil]];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"01",@"accountType", nil]];
     
//设置传递对象
ServiceArgs *args=[[[ServiceArgs alloc] init] autorelease];
args.methodName=@"AddMethod";//webservice方法名
args.soapParams=params;//方法参数
//调用
ServiceResult *result=[ServiceHelper syncService:args];
NSLog(@"同步请求xml=%@\n",result.xmlString);
//查询节点
NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];    
NSLog(@"解析xml结果=%@\n",arr);
</code></pre>
### (2)异步请求
a.无参数的异步请求
<pre><code>
 [ServiceHelper asynMethodName:@"getForexRmbRate" success:^(ServiceResult *result) {
        //查询xml节点
        NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
        NSLog(@"解析xml结果=%@\n",arr);
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"error=%@\n",[error description]);
    }];
</code></pre>
b.有参数的异步请求
<pre><code>
//参数
NSMutableArray *params=[NSMutableArray array];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"queryBFlist",@"tradeCode", nil]];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"account", nil]];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"password", nil]];
[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"01",@"accountType", nil]];
     
//设置传递对象
ServiceArgs *args=[[[ServiceArgs alloc] init] autorelease];
args.methodName=@"AddMethod";//webservice方法名
args.soapParams=params;//方法参数
//调用
[ServiceHelper asynService:args success:^(ServiceResult *result) {
       NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
        NSLog(@"解析xml结果=%@\n",arr);
        
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"error=%@\n",[error description]);
    }]; 
</code></pre>
### (3)队列请求<br/>
<pre><code>
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
</code></pre>
### (4)直接设置url与命名空间请求<br/>
<pre><code>
ServiceArgs *args1=[[[ServiceArgs alloc] init] autorelease];
args1.serviceURL=@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";//webservice地址
args1.serviceNameSpace=@"http://WebXml.com.cn/";//webservice命名空间
args1.methodName=@"getDatabaseInfo";
//调用
[ServiceHelper asynService:args1 success:^(ServiceResult *result) {        
   NSLog(@"xml结果=%@\n",result.XMLString);
} 
failed:^(NSError *error, NSDictionary *userInfo) {
    NSLog(@"error=%@\n",[error description]);
}];
</code></pre>

