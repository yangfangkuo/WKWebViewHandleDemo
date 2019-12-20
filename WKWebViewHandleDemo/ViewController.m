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
    NSMutableDictionary *handlers = [configuration valueForKey:@"_urlSchemeHandlers"];
    handlers[@"https"] = handler;//修改handler,将HTTP和HTTPS也一起拦截
    handlers[@"http"] = handler;
    WKWebView *wk = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200) configuration:configuration];
    [self.view addSubview:wk];
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];


}


@end
