
最近完成了正方教务管理系统的IOS客户端的小程序。现在记录一下心得。
用到的几个工具
 1.chrome的开发者工具   查看每次HTTP请求命令与参数之类的。
 2. AFnetworking    ios网络请求开源框架，同样的有ASIhttprequest 选择AFnetworking是因为它更简单，并且现在还在更新维护，ASI好像好久不更新了。
 3. TFhepple    Html分析类库。
学校的正方教务因为没有对应的JSON数据接口，所以只能模拟网页的所有行为，获取HTML 分析html。
系统用的编码是GB2312 框架获取下来的字符串虽然会自动解码，但是很不稳定，有时候会得到空字符串，但是获取下来的DATA就没有这个问题，所以就要手动解码将DATA转为NSString。。
cess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                 
                 NSData *data=responseObject;
                 NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
光转码也不行，在分析HTML的时候因为网页头部的编码信息也有问题，所以要做手动修改，这样才能被TFhepple解析。
 NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
              NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
              TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
成绩页面修改的方式有所不同
              NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta content=\"text/html; charset=gb2312\" http-equiv=\"Content-Type\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];

其他页面要怎么替换具体要看页面头部具体的信息是什么，然后写在 stringByReplacingOccurrencesOfString方法第一个参数部分就可以。

模拟登陆部分
首先是获取Cookie，这个用 NSURLRequest就能获取到，之后要在每次请求的时候加到 NSMutableURLRequest 里。AFnetworking在每次请求的时候都会建立一个NSURLRequest对象，改这个就可以。代码如下
获取cookie
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"
http://gdjwgl.bjut.edu.cn/default2.aspx
"]];
                                              //  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                            //timeoutInterval:3];
       
       [NSURLConnection sendSynchronousRequest:request
                             returningResponse:nil
                                         error:nil];
       
       NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
       NSArray *cookies =[cookieJar cookies];
       _cookieDictionary= [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];

每次post或者get带上登陆成功后保存下来的cookie 获取验证码的时候同样

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
//
    if(self.cookieDictionary) {
        [request setHTTPShouldHandleCookies:NO];
        [request setAllHTTPHeaderFields:self.cookieDictionary];


模拟登陆提交的参数有 用户名,密码，验证码还有一个viewstate，这个viewstate每次都得在登陆前获取验证码图片的时候同时获取 还是通过GET请求得到页面通过html分析工具得到对应的viwestate，具体可以看我的DEMO.然后在提交参数的时候一并提交。
NSDictionary *parameters = @{@"__VIEWSTATE":self.viewState,@"txtUserName"self.xueHao.text,@"TextBox2":self.miMa.text,@"txtSecretCode":self.yanZhengMa.text,@"RadioButtonList1":@"学生",@"Button1":@""};

登陆成功之后就可以用cookie随意访问各个页面啦。。不过在请求查询成绩页面的时候还要提交一个viewState,这个viewState参数是从登陆成功后的第一个页面获取，非常长。。。。。
并且在访问内部所有页面的时候都要在Request Header里加一个refer参数，这个参数跟提交cookie是一样的道理，学校的系统这个东西不提交不行，但是随便提交一个同学的页面地址居然就可以了。
   if(self.cookieDictionary) {
        
        NSMutableDictionary*newDictionary=[self.cookieDictionary mutableCopy];
        
        [newDictionary setValue:@"http://gdjwgl.bjut.edu.cn/xs_main.aspx?xh=11111111" forKey:@"Referer"];
        [request setAllHTTPHeaderFields:newDictionary];
        
    }
    
这部分也是加在AFHTTPRequestOperationManager类里实现文件post 和get 方法底下的。
