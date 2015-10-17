
##正方教务系统IOS客户端数据请求DEMO

用到的几个工具
- chrome的开发者工具   查看每次HTTP请求命令与参数等。
- AFNetworking    ios网络请求开源框架，同样的有ASIHttprequest。选择AFnetworking是因为它更简单，并且现在还在更新维护，ASI好像好久没有更新。
- TFhepple    Html分析类库。

正方教务系统因为没有对应的JSON或者XML数据接口，所以只能模拟网页的所有行为，获取html 分析html。
正方教务系统用的编码是GB2312 框架获取下来的NSString虽然已经自动解码，但是很不稳定，有时候会得到空字符串，但是获取下来的DATA就没有这个问题，所以就要手动解码将DATA转为NSString。

 <pre><code>cess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);                 
                 NSData *data=responseObject;
                 NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];</code></pre>
光转码也不行，在分析HTML的时候因为网页头部的编码信息也有问题，所以要做手动修改，这样才能被TFhepple正确解
析。
<pre><code> 
 NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
              NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
              TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];</code></pre> 
成绩页面修改的方式有所不同
        <pre><code>  NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"content=\"text/html; charset=gb2312\" http-equiv=\"Content-Type\">" withString:@"http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];</code></pre>

其他页面要怎么替换具体要看页面头部具体的信息是什么，然后写在 stringByReplacingOccurrencesOfString方法第一个参数部分就可以。

模拟登陆部分
首先是获取Cookie，这个用 NSURLRequest就能获取到，之后要在每次请求的时候加到 NSMutableURLRequest 里。AFnetworking在每次请求的时候都会建立一个NSURLRequest对象，改这个就可以。代码如下
获取cookie
<pre><code> 
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"
http://学校的网址/default2.aspx
"]];
                                              //  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                            //timeoutInterval:3];
       
       [NSURLConnection sendSynchronousRequest:request
                             returningResponse:nil
                                         error:nil];
       
       NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
       NSArray *cookies =[cookieJar cookies];
       _cookieDictionary= [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
</code></pre> 
获取验证码的时候必须带上cookie,每次post或者get需要带上的是登陆成功后保存下来的cookie。
<pre><code> 
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
</code></pre> 


模拟登陆提交的参数有 用户名,密码，验证码还有一个viewstate，这个viewstate每次都得在登陆前获取验证码图片的时候同时获取 还是通过GET请求得到页面通过html分析工具得到对应的viwestate，具体可以看我的DEMO.然后在提交参数的时候一并提
交。
<pre><code> 
NSDictionary *parameters = @{@"__VIEWSTATE":self.viewState,@"txtUserName"self.xueHao.text,@"TextBox2":self.miMa.text,@"txtSecretCode":self.yanZhengMa.text,@"RadioButtonList1":@"学生",@"Button1":@""};
</code></pre> 
登陆成功之后就可以用cookie随意访问各个页面了。。不过在请求查询成绩页面的时候还要提交一个viewState,这个viewState参数是从登陆成功后的第一个页面获取，Very long。
并且在访问内部所有页面的时候都要在Request Header里加一个refer参数，这个参数跟提交cookie是一样的道理，学校的系统这个东西不提交不行，但是随便提交一个任何人的页面地址居然就可以了。这部分也是加在AFHTTPRequestOperationManager类里实现文件post 和get 方法底下的。
<pre><code> 
   if(self.cookieDictionary) {
        
        NSMutableDictionary*newDictionary=[self.cookieDictionary mutableCopy];
        
        [newDictionary setValue:@"http://gdjwgl.bjut.edu.cn/xs_main.aspx?xh=11111111" forKey:@"Referer"];
        
        [request setAllHTTPHeaderFields:newDictionary];
        
    }
</code></pre> 

http://blog.sheliw.com/blog/2014/10/25/zheng-fang-jiao-wu-guan-li-xi-tong-ioske-hu-duan/
