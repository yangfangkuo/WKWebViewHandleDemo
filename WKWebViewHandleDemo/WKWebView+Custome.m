//
//  WKWebView+Custome.m
//  WKWebViewHandleDemo
//
//  Created by xiaosengkongkong on 2019/12/25.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "WKWebView+Custome.h"

#import <objc/runtime.h>


@implementation WKWebView (Custome)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod1 = class_getClassMethod(self, @selector(handlesURLScheme:));
        Method swizzledMethod1 = class_getClassMethod(self, @selector(yyhandlesURLScheme:));
        method_exchangeImplementations(originalMethod1, swizzledMethod1);

    });

}
+ (BOOL)yyhandlesURLScheme:(NSString *)urlScheme {
    if ([urlScheme isEqualToString:@"http"] || [urlScheme isEqualToString:@"https"]) {
        return NO;  //这里让返回NO,应该是默认不走系统断言或者其他判断啥的
    } else {
        return [self yyhandlesURLScheme:urlScheme];
    }
}
@end
