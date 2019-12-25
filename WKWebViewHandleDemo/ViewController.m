//
//  ViewController.m
//  WKWebViewHandleDemo
//
//  Created by xiaosengkongkong on 2019/12/20.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "CustomURLSchemeHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    CustomURLSchemeHandler *handler = [CustomURLSchemeHandler new];
    
    //支持https和http的方法1  这个需要去hook +[WKwebview handlesURLScheme]的方法,可以去看WKWebView+Custome类的实现
    [configuration setURLSchemeHandler:handler forURLScheme:@"https"];
    [configuration setURLSchemeHandler:handler forURLScheme:@"http"];
    
    //hook系统的方法2   xcode11可能会运行直接崩溃,因为用到了私有变量
//    NSMutableDictionary *handlers = [configuration valueForKey:@"_urlSchemeHandlers"];
//    handlers[@"https"] = handler;//修改handler,将HTTP和HTTPS也一起拦截
//    handlers[@"http"] = handler;
    
    WKWebView *wk = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200) configuration:configuration];
    [self.view addSubview:wk];
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];


    
}


@end
