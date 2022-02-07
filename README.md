# Foggy

![image](Images/AX.jpg)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/yangKJ/Foggy)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Foggy.svg?style=flat&label=CocoaPods&colorA=28a745&&colorB=4E4E4E)](https://cocoapods.org/pods/Foggy)
![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS-4E4E4E.svg?colorA=28a745)

There are two types of Crash. 

- One is caused by [EXC_BAD_ACCESS](https://www.avanderlee.com/swift/exc-bad-access-crash). The reason is that the memory address that does not belong to the process is accessed. 
- The other is an uncaught Objective-C exception (NSException) that causes the program to crash by sending a SIGABRT signal to itself

This paper mainly introduces the second kind of automatic Crash protection function during APP running:

- Container
- String
- Failure to find the corresponding function
- Crash caused by NSNull returned in the background
- Timer
- KVO
- Failure to update UI in the main thread

### Crash
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

### Effect
```
2020-12-29 15:49:27. 649011 + 0800 Foggy (7987-427289)
************ Crash log ************
🍉🍉 crash: ViewController class fails to find method
The test_UnrecognizedSelector 🚗🚗 class method did not find 🚗🚗
Exception address: -[ViewController testUnrecognizedSelector]
The 2020-12-29 15:49:27. 651701 + 0800 KJExceptionDemo (7987-427289)
************ Crash log ************
🍉🍉 crash: ViewController class fails to find instance method
Cause: testCrash:xx: 🚗🚗 The instance method is not found 🚗🚗
Exception address: -[ViewController testUnrecognizedSelector]
The 2020-12-29 15:49:27. 654808 + 0800 KJExceptionDemo (7987-427289)
************ Crash log ************
Title: 🍉🍉 crash: Array insert data is empty
*** -[__NSArrayM insertObject:atIndex:]: Object cannot be nil
-[ViewController testContainer]
The 2020-12-29 15:49:27. 657423 + 0800 KJExceptionDemo (7987-427289)
************ Crash log ************
Title: 🍉🍉 crash: Array change index out of bounds
Abnormal reasons: * * * - [__NSArrayM setObject: atIndexedSubscript:] : index 4 beyond bounds [2] 0..
-[ViewController testContainer]
The 2020-12-29 15:49:27. 661423 + 0800 KJExceptionDemo (7987-427289)
************ Crash log ************
Title: 🍉🍉 crash: The string length is insufficient
*** -[__NSCFConstantString kj_substringFromIndex:]: Index 10 out of bounds; string length 3
-[ViewController testString]
```

### Cocoapods
```
pod 'Foggy'
```

### Remarks

> The general process is almost like this, the Demo is also written in great detail, you can check it out for yourself.🎷
>
> [**FoggyDemo**](https://github.com/yangKJ/Foggy)
>
> Tip: If you find it helpful, please help me with a star. If you have any questions or needs, you can also issue.
>
> Thanks.🎇

### About the author
- 🎷 **E-mail address: [yangkj310@gmail.com](yangkj310@gmail.com) 🎷**
- 🎸 **GitHub address: [yangKJ](https://github.com/yangKJ) 🎸**

-----

### License
Foggy is available under the [MIT](LICENSE) license. See the [LICENSE](LICENSE) file for more info.

-----
