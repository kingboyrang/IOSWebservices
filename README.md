IOSWebservices
==============
1.添加类库引用<br/>
libz.dylib<br/>
MobileCoreServices.framework<br/>
libxml2.dylib<br/>
CFNetwork.framework<br/>
SystemConfiguration.framework<br/>

2.Project->Edit Project Seeting->切换到buddle选项卡->在seetings中<br/>
(1)查找到Search paths中的Header Search Paths 点击它添加${SDKROOT}/usr/include/libxml2<br/>

3.修改webservice访问配置<br/>
在项目中找到ServiceArgs类，把defaultWebSerivceUrl与defaultWebServiceNameSpace的值修改成自已的内容<br/>

4.使用说明<br/>
(1)同步请求<br/>
a.无参数的同步请求<br/>
=============================================================================================
  ServiceResult *result=[ServiceHelper syncMethodName:@"getForexRmbRate"];
    NSLog(@"同步请求xml=%@\n",result.xmlString);
    NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
    NSLog(@"解析xml结果=%@\n",arr);
==============================================================================================
b.有参数的同步请求
==============================================================================================
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
==============================================================================================
(2)异步请求
a.无参数的异步请求
==============================================================================================
 [ServiceHelper asynMethodName:@"getForexRmbRate" completed:^(ServiceResult *result) {
        //查询xml节点
        NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
        NSLog(@"解析xml结果=%@\n",arr);
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"error=%@\n",[error description]);
    }];
==============================================================================================
b.有参数的异步请求
==============================================================================================
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
[ServiceHelper asynService:args completed:^(ServiceResult *result) {
       NSArray *arr=[result.xmlParse soapXmlSelectNodes:@"//ForexRmbRate"];
        NSLog(@"解析xml结果=%@\n",arr);
        
    } failed:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"error=%@\n",[error description]);
    }]; 
