//
//  UIScrollView+RTForwarding.h
//  RTForwarding
//
//  Created by wbx_iMac on 2017/12/7.
//  Copyright © 2017年 DaverZhou. All rights reserved.
//
//整体流程:
//
//1.为即将转发的消息返回一个对应的方法签名(该签名后面用于对转发消息对象(NSInvocation *)anInvocation进行编码用)
//
//2.开始消息转发((NSInvocation *)anInvocation封装了原有消息的调用，包括了方法名，方法参数等)
//
//3.由于转发调用的API与原始调用的API不同，这里我们新建一个用于消息调用的NSInvocation对象viewControllerInvocatio并配置好对应的target与selector
//
//4.配置所需参数:由于每个方法实际是默认自带两个参数的:self和_cmd，所以我们要配置其他参数时是从第三个参数开始配置
//
//5.消息转发
//
//作者：KeepMoveingOn
//链接：http://www.jianshu.com/p/215eccc37f5e
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

#import <UIKit/UIKit.h>

@interface UIScrollView (RTForwarding)

@end
