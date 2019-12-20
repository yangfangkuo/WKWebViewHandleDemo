# WKWebViewHandleDemo

####webView 使用URLProtocol解决
UIWebView的请求可以通过NSURLPtotol拦截，既可以拦截，也可以用本地的资源直接返回，可以实现资源本地化等各种需求，网上好多这种文章，所以此次不过多提及，主要针对WKWebView（仅考虑iOS11及以上）

####WKWebView实现类似URLProtocol方法
#####通过继承WKURLSchemeHandler的对象实现拦截
WKWebViewConfiguration类有如下方法：
![image.png](https://upload-images.jianshu.io/upload_images/5505686-aa4a4253ca84123e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
可以让我们通过自定义的协议去实现拦截，但是默认是不允许设置Http及Https以及FTP等请求的，所以需要我们自己修改一下（系统是否支持，需要我们自己
调用+[WKWebView handlesURLScheme:]来测试一下），
步骤如下：
###### 1. WKWebViewConfiguration设置自定义WKURLSchemeHandler
~~~
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    CustomURLSchemeHandler *handler = [CustomURLSchemeHandler new];
    NSMutableDictionary *handlers = [configuration valueForKey:@"_urlSchemeHandlers"];
    handlers[@"https"] = handler;//修改handler,将HTTP和HTTPS也一起拦截
    handlers[@"http"] = handler; //有人说这是私有方法，但是我感觉还好吧
    WKWebView *wk = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200) configuration:configuration];
    [self.view addSubview:wk];
    self.wk = wk;
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
~~~
自己写一个继承WKURLSchemeHandler协议的对象
~~~#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CustomURLSchemeHandler : NSObject <WKURLSchemeHandler>

@end

NS_ASSUME_NONNULL_END
~~~
~~~
//这里拦截到URLScheme为customScheme的请求后，根据自己的需求,返回结果，并返回给WKWebView显示
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask{
    NSURLRequest *request = urlSchemeTask.request;
    NSLog(@"request = %@",request);
    
    //如果是我们替对方去处理请求的时候
    if (!manager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        //这个acceptableContentTypes类型自己补充,demo不写太多
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    NSURLSessionDataTask *task = [manager  dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:responseObject];
        [urlSchemeTask didFinish];
    }];
    [task resume];

    //如果是返回本地资源的话
//    UIImage *image = [UIImage imageNamed:@"yang.jpg"];
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
//    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL MIMEType:@"image/jpeg" expectedContentLength:data.length textEncodingName:nil];
//    [urlSchemeTask didReceiveResponse:response];
//    [urlSchemeTask didReceiveData:data];
//    [urlSchemeTask didFinish];
}

- (void)webView:(WKWebView *)webVie stopURLSchemeTask:(id)urlSchemeTask {
    NSLog(@"stop = %@",urlSchemeTask);
}
@end
~~~
然后就可以实现拦截，以访问的百度网页为例，打印如下：
![image.png](https://upload-images.jianshu.io/upload_images/5505686-64786701367738c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
即可拦截或者替换本地资源

demo地址：
