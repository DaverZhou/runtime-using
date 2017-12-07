//
//  UIScrollView+RTForwarding.m
//  RTForwarding
//
//  Created by wbx_iMac on 2017/12/7.
//  Copyright © 2017年 DaverZhou. All rights reserved.
//

#import "UIScrollView+RTForwarding.h"

@implementation UIScrollView (RTForwarding)
//重写runtime方法
//1.为即将转发的消息返回一个对应的方法签名(该签名后面用于对转发消息对象(NSInvocation *)anInvocation进行编码用)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector { // 1
    NSMethodSignature *signature = nil;
    
    if (aSelector == @selector(setContentInsetAdjustmentBehavior:)) {
        
        signature = [UIViewController instanceMethodSignatureForSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)];
    }else {
        
        signature = [super methodSignatureForSelector:aSelector];
    }
    
    return signature;
}
//2.开始消息转发((NSInvocation *)anInvocation封装了原有消息的调用，包括了方法名，方法参数等)
- (void)forwardInvocation:(NSInvocation *)anInvocation { // 2
    
    BOOL automaticallyAdjustsScrollViewInsets  = NO;
    UIViewController *topmostViewController = [self getTopmostViewController];
    //3.由于转发调用的API与原始调用的API不同，这里我们新建一个用于消息调用的NSInvocation对象viewControllerInvocatio并配置好对应的target与selector
    NSInvocation *viewControllerInvocation = [NSInvocation invocationWithMethodSignature:anInvocation.methodSignature]; // 3
    [viewControllerInvocation setTarget:topmostViewController];
    [viewControllerInvocation setSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)];
    //4.配置所需参数:由于每个方法实际是默认自带两个参数的:self和_cmd，所以我们要配置其他参数时是从第三个参数开始配置
    [viewControllerInvocation setArgument:&automaticallyAdjustsScrollViewInsets atIndex:2]; // 4
    //5.消息转发
    [viewControllerInvocation invokeWithTarget:topmostViewController]; // 5
}

//获取栈顶控制器
- (UIViewController *)getTopmostViewController {
    
    UIViewController *resultVC;
    resultVC = [self getTopmostViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self getTopmostViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
- (UIViewController *)getTopmostViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getTopmostViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getTopmostViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

@end
