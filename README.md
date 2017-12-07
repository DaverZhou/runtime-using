# 消息转发

随着iOS系统版本的更新，部分性能更优异或者可读性更高的API将有可能对原有API进行废弃与更替。因此在开发中经常需要考虑、判断版本，那是不是可以考虑用runtime来进行动态处理？
下面主要是针对适配iOS 11 *contentInsetAdjustmentBehavior*与*automaticallyAdjustsScrollViewInsets*做栗子
##### 1、新建一个Category（RTForwarding）
用于调用到iOS 11属性contentInsetAdjustmentBehavior的封装处理
代码如下：
```
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
```
##### 2、调用Category（RTForwarding）
在需要使用的地方导入头文件
```
#import "UIScrollView+RTForwarding.h"
```
在使用到iOS 11属性contentInsetAdjustmentBehavior时，不需要进行判断就可以实现之前需要判断功能。
代码如下：
```
    CGSize main = [UIScreen mainScreen].bounds.size;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, main.width, main.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor orangeColor];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//无需判断，简单粗暴
    [self.view addSubview:tableView];
```
具体的可以看我[简书说明](http://www.jianshu.com/p/836f2e555b34)
