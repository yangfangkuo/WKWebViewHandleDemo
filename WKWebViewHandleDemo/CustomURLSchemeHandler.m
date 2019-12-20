//
//  CustomURLSchemeHandler.m
//  testWebview
//
//  Created by 杨方阔 on 2019/12/9.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "CustomURLSchemeHandler.h"
#import <WebKit/WebKit.h>
#import "AFHTTPSessionManager.h"
#import "AFURLSessionManager.h"
static AFHTTPSessionManager *manager ;

@implementation CustomURLSchemeHandler

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
