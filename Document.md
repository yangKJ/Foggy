# Foggy

### [Crash防护](https://juejin.cn/post/6911580676559110151)
# 前言
- **Crash分为两种，一种是由EXC_BAD_ACCESS引起的，原因是访问了不属于本进程的内存地址，有可能是访问已被释放的内存；另一种是未被捕获的Objective-C异常（NSException），导致程序向自身发送了SIGABRT信号而崩溃**
- **本文主要介绍APP运行时第二种Crash自动防护功能，暂时涵盖容器，字符串，没找到对应的函数，后台返回NSNull导致的崩溃，计时器，kvo，不在主线程中更新UI等崩溃**
- **有空再来慢慢补充其他类型**

#### Demo地址：[Foggy](https://github.com/yangKJ/Foggy)

### 设计原理
利用 Objective-C 语言的动态特性，采用AOP面向切面编程的设计思想，交换方法然后拦截处理崩溃信息
![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/529e7eb738644bf2a32ddeb341a9e277~tplv-k3u1fbpfcp-watermark.image)

| 方法 | 功能 |
| :--- | :--- |
| class_getInstanceMethod | 获取实例方法 |
| class_getClassMethod | 获取类方法 |
| method_getImplementation | 获取一个方法的实现 |
| method_setImplementation | 设置一个方法的实现 |
| method_getTypeEncoding | 获取方法实现的编码类型 |
| class_addMethod | 添加方法实现 |
| class_replaceMethod | 用一个方法的实现，替换另一个方法的实现，即aIMP 指向 bIMP，但是bIMP不一定指向aIMP |
| method_exchangeImplementations | 交换两个方法的实现，即 aIMP -> bIMP, bIMP -> aIMP |

#### 交换实例方法
```
void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getInstanceMethod(clazz, original);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzled);
    if (class_addMethod(clazz, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clazz, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
```
#### 交换类方法
```
void kExceptionClassMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getClassMethod(clazz, original);
    Method swizzledMethod = class_getClassMethod(clazz, swizzled);
    Class metaclass = objc_getMetaClass(NSStringFromClass(clazz).UTF8String);
    if (class_addMethod(metaclass, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(metaclass, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
```

## 常见Crash和解决方案
### 一、没找到对应的函数 - Unrecognized Selector Sent to Instance
类型  |  原因  
:---: | :---
SEL   |  unrecognized selector sent to instance   .h定义但.m没实现
SEL   |  performSelector: 调用不存在的方法
SEL   |  delegate 回调前没有判空而是直接调用
SEL   |  id 类型没有判断类型，强行调用真实类型不存在的方法
SEL   |  copy 修饰的可变的字符串 \ 字典 \ 数组 \ 集合 \ Data，调用可变的方法
> 消息转发流程图：  
> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/25f3694cd3aa45ce8f2b90f3ab176cbb~tplv-k3u1fbpfcp-zoom-1.image)

#### 解决方案：
- 交换方法`methodSignatureForSelector:` 和 `forwardInvocation:`
- 对象调用方法经过三个阶段
  1. 消息发送：查询cache和方法列表，找到了直接调用，找不到方法会进入下个阶段
  2. 动态解析: 调用实例方法`resolveInstanceMethod`或类方法`resolveClassMethod`里面可以有一次动态添加方法的机会
  3. 消息转发：首先会判断是否有其他对象可以处理方法`forwardingTargetForSelector`返回一个新的对象，如果没有新的对象进行处理，会调用`methodSignatureForSelector`方法返回方法签名，然后调用`forwardInvocation`
- 选择在消息转发的最后一步来做处理，`methodSignatureForSelector:`消息获得函数的参数和返回值，然后`[self respondsToSelector:aSelector]`判断是否有该方法，如果没有返回函数签名，创建一个NSInvocation对象并发送给`forwardInvocation`

### 二、容器越界 - 数组和字典
类型  |  原因  
:---: | :---
NSArray  |  数组索引越界、插入空对象
NSDictionary  |  key、value 为空
> 备注：可变的都继承自不可变的，所有可变的分类中，重复的方法就不用再次替换

#### 解决方案：
- 交换方法，然后防护处理，简单举个例子，NSArray 是一个类簇，它真正的类型是`__NSArrayI`，交换方法如下  

```
Class __NSArrayI = objc_getClass("__NSArrayI");
/// 越界崩溃方式一：[array objectAtIndex:0];
kExceptionMethodSwizzling(__NSArrayI, @selector(objectAtIndex:), @selector(kj_objectAtIndex:));
/// 越界崩溃方式二：array[0];
kExceptionMethodSwizzling(__NSArrayI, @selector(objectAtIndexedSubscript:), @selector(kj_objectAtIndexedSubscript:));
```
交换后的处理  

```
- (instancetype)kj_objectAtIndex:(NSUInteger)index{
    NSArray *temp = nil;
    @try {
        temp = [self kj_objectAtIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}
```

### 三、KVO
类型  |  原因  
:---: | :---
KVO  |  添加了监听，没有移除

#### 解决方案：
- 交换`removeObserver:forKeyPath:`方法，

```
- (void)kj_removeObserver:(NSObject*)observer forKeyPath:(NSString *)keyPath{
    @try {
        [self kj_removeObserver:observer forKeyPath:keyPath];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：添加观察者后没有移除观察者导致";
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}
```

### 四、NSTimer
类型  |  原因  
:---: | :---
NSTimer  |  没有 invalidate，直接销毁
NSTimer  |  NStimer 与 target 强引用，内存泄漏

#### 解决方案：
- 交换`scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:`方法
- 定义一个抽象类`KJProxyProtector`，NSTimer实例强引用抽象类，而在抽象类中弱引用target，这样target和NSTimer之间的关系也就是弱引用，意味着target可以自由的释放，从而解决循环引用的问题

###  五、后台返回NSNull导致的崩溃
类型  |  原因  
:---: | :---
NSNull | 后台返回NSNull导致的崩溃
#### 解决方案：
- 交换方法`methodSignatureForSelector:` 和 `forwardInvocation:`

### 六、UIKit Called on Non-Main Thread
#### 解决方案：
- 交换`setNeedsLayout`、`layoutIfNeeded`、`layoutSubviews`、`setNeedsUpdateConstraints`方法
- `[NSThread isMainThread]`判断当前线程是否为主线程，如果不是则在主线程执行

## 异常收集
### 一、防护类型
目前提供以下七种

```
typedef NS_OPTIONS(NSInteger, KJCrashProtectorType) {
    KJCrashProtectorTypeContainer = 1 << 0,// 数组和字典
    KJCrashProtectorTypeString = 1 << 1,// 字符串
    KJCrashProtectorTypeUnrecognizedSelector = 1 << 2,// 没找到对应的函数
    KJCrashProtectorTypeNSNull = 1 << 3,// 后台返回NSNull导致的崩溃
    KJCrashProtectorTypeTimer = 1 << 4,// 计时器
    KJCrashProtectorTypeKVO = 1 << 5,// kvo
    KJCrashProtectorTypeUINonMain = 1 << 6,// 不在主线程中刷新UI
};
```
### 二、开启防护
采用多枚举方式，来快速设置需要开发的防护

```
/// 开启全部防护
+ (void)kj_openAllCrashProtectorManager:(kExceptionBlock)block{
    if (block) [KJCrashManager kj_crashBlock:block];
    [self kj_openCrashProtectorType:
     KJCrashProtectorTypeContainer |
     KJCrashProtectorTypeString |
     KJCrashProtectorTypeUnrecognizedSelector |
     KJCrashProtectorTypeNSNull |
     KJCrashProtectorTypeTimer |
     KJCrashProtectorTypeKVO];
}
/// 开启指定类型防护
+ (void)kj_openCrashProtectorType:(KJCrashProtectorType)type{
    if (type & KJCrashProtectorTypeContainer) {
        [NSArray kj_openCrashExchangeMethod];
        [NSMutableArray kj_openCrashExchangeMethod];
        [NSDictionary kj_openCrashExchangeMethod];
        [NSMutableDictionary kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeString) {
        [NSString kj_openCrashExchangeMethod];
        [NSMutableString kj_openCrashExchangeMethod];
        [NSAttributedString kj_openCrashExchangeMethod];
        [NSMutableAttributedString kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUnrecognizedSelector) {
        [NSObject kj_openUnrecognizedSelectorExchangeMethod];
    }
    if (type & KJCrashProtectorTypeNSNull) {
        [NSNull kj_openNullExchangeMethod];
    }
    if (type & KJCrashProtectorTypeTimer) {
        [NSTimer kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeKVO) {
        [NSObject kj_openKVOExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUINonMain) {
        [UIView kj_openCrashExchangeMethod];
    }
}
```

### 三、解析异常消息
采用正则表达式来匹配出来方法名

```
/// 解析异常消息
+ (NSString*)kj_analysisCallStackSymbols:(NSArray<NSString*>*)callStackSymbols{
    __block NSString *msg = nil;
    NSString *pattern = @"[-\\+]\\[.+\\]";// 匹配出来的格式为 +[类名 方法名] 或者 -[类名 方法名]
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    for (NSInteger i = 2; i < callStackSymbols.count; i++) {
        NSString *matchesString = callStackSymbols[i];
        [regularExp enumerateMatchesInString:matchesString options:NSMatchingReportProgress range:NSMakeRange(0, matchesString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *tempMsg = [matchesString substringWithRange:result.range];
                NSString *className = [tempMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                if (![className hasSuffix:@")"] && [NSBundle bundleForClass:NSClassFromString(className)] == [NSBundle mainBundle]) {
                    msg = tempMsg;
                }
                *stop = YES;
            }
        }];
        if (msg.length) break;
    }
    return msg;
}
```

### 熟悉又讨厌的崩溃
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]'
*** First throw call stack:(
    0   CoreFoundation                      0x0000000103dca126 __exceptionPreprocess + 242
    1   libobjc.A.dylib                     0x0000000103c54f78 objc_exception_throw + 48
    2   CoreFoundation                      0x0000000103e46cdb _CFThrowFormattedException + 194
    3   CoreFoundation                      0x0000000103e5221e -[__NSPlaceholderDictionary initWithCapacity:].cold.1 + 0
    4   CoreFoundation                      0x0000000103e351f7 -[__NSPlaceholderDictionary initWithObjects:forKeys:count:] + 227
    5   CoreFoundation                      0x0000000103dc8da3 +[NSDictionary dictionaryWithObjects:forKeys:count:] + 49
    6   KJExtensionHandler                  0x00000001033b715f -[ViewController viewDidLoad] + 815
    7   UIKitCore                           0x000000010d7ac73b -[UIViewController _sendViewDidLoadWithAppearanceProxyObjectTaggingEnabled] + 88
    8   UIKitCore                           0x000000010d7b1022 -[UIViewController loadViewIfRequired] + 1084
    9   UIKitCore                           0x000000010d6e800e -[UINavigationController _updateScrollViewFromViewController:toViewController:] + 162
    10  UIKitCore                           0x000000010d6e82f8 -[UINavigationController _startTransition:fromViewController:toViewController:] + 154
    11  UIKitCore                           0x000000010d6e9371 -[UINavigationController _startDeferredTransitionIfNeeded:] + 851
    12  UIKitCore                           0x000000010d6ea6dc -[UINavigationController __viewWillLayoutSubviews] + 150
    13  UIKitCore                           0x000000010d6caf1e -[UILayoutContainerView layoutSubviews] + 217
    14  UIKitCore                           0x000000010e43d9ce -[UIView(CALayerDelegate) layoutSublayersOfLayer:] + 2874
    15  QuartzCore                          0x0000000105546d87 -[CALayer layoutSublayers] + 258
    16  QuartzCore                          0x000000010554d239 _ZN2CA5Layer16layout_if_neededEPNS_11TransactionE + 575
    17  QuartzCore                          0x0000000105558f91 _ZN2CA5Layer28layout_and_display_if_neededEPNS_11TransactionE + 65
    18  QuartzCore                          0x0000000105499078 _ZN2CA7Context18commit_transactionEPNS_11TransactionEdPd + 496
    19  QuartzCore                          0x00000001054cfe13 _ZN2CA11Transaction6commitEv + 783
    20  UIKitCore                           0x000000010defe27a __34-[UIApplication _firstCommitBlock]_block_invoke_2 + 81
    21  CoreFoundation                      0x0000000103d385db __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__ + 12
    22  CoreFoundation                      0x0000000103d379ef __CFRunLoopDoBlocks + 434
    23  CoreFoundation                      0x0000000103d3240c __CFRunLoopRun + 899
    24  CoreFoundation                      0x0000000103d31b9e CFRunLoopRunSpecific + 567
    25  GraphicsServices                    0x000000010c7ebdb3 GSEventRunModal + 139
    26  UIKitCore                           0x000000010dee0af3 -[UIApplication _run] + 912
    27  UIKitCore                           0x000000010dee5a04 UIApplicationMain + 101
    28  KJExtensionHandler                  0x00000001033ea92a main + 122
    29  libdyld.dylib                       0x00000001065eb415 start + 1
    30  ???                                 0x0000000000000001 0x0 + 1
)
libc++abi.dylib: terminating with uncaught exception of type NSException
```
### 防崩处理之后的效果
```
2020-12-29 15:49:27.649011+0800 KJExceptionDemo[7987:427289] 
************ crash 日志 ************
标题：🍉🍉 crash：ViewController 类出现未找到类方法
异常原因：test_UnrecognizedSelector 🚗🚗类方法未找到🚗🚗
异常地址：-[ViewController testUnrecognizedSelector]
2020-12-29 15:49:27.651701+0800 KJExceptionDemo[7987:427289] 
************ crash 日志 ************
标题：🍉🍉 crash：ViewController 类出现未找到实例方法
异常原因：testCrash:xx: 🚗🚗实例方法未找到🚗🚗
异常地址：-[ViewController testUnrecognizedSelector]
2020-12-29 15:49:27.654808+0800 KJExceptionDemo[7987:427289] 
************ crash 日志 ************
标题：🍉🍉 crash：数组插入数据为空
异常原因：*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil
异常地址：-[ViewController testContainer]
2020-12-29 15:49:27.657423+0800 KJExceptionDemo[7987:427289] 
************ crash 日志 ************
标题：🍉🍉 crash：数组更改索引越界
异常原因：*** -[__NSArrayM setObject:atIndexedSubscript:]: index 4 beyond bounds [0 .. 2]
异常地址：-[ViewController testContainer]
2020-12-29 15:49:27.661423+0800 KJExceptionDemo[7987:427289]
************ crash 日志 ************
标题：🍉🍉 crash：字符串长度不够
异常原因：*** -[__NSCFConstantString kj_substringFromIndex:]: Index 10 out of bounds; string length 3
异常地址：-[ViewController testString]
```

### <a id="Cocoapods安装"></a>Cocoapods安装
```
pod 'Foggy'
```

#### 崩溃处理介绍就到此完毕，后面有相关再补充，写文章不容易，还请点个**[小星星](https://github.com/yangKJ)**传送门
