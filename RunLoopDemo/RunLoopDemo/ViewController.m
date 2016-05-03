//
//  ViewController.m
//  RunLoopDemo
//
//  Created by Biao on 16/5/2.
//  Copyright © 2016年 Bobby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)btnClick:(id)sender
{
    NSLog(@"*******btnClick*******");
}

        /* Run Loop Observer Activities */
//    kCFRunLoopEntry = (1UL << 0),             即将进入Loop
//    kCFRunLoopBeforeTimers = (1UL << 1),      即将处理Timer
//    kCFRunLoopBeforeSources = (1UL << 2),     即将处理Source
//    kCFRunLoopBeforeWaiting = (1UL << 5),     即将进入休眠
//    kCFRunLoopAfterWaiting = (1UL << 6),      刚从休眠中唤醒
//    kCFRunLoopExit = (1UL << 7),              即将退出Loop
//    kCFRunLoopAllActivities = 0x0FFFFFFFU     所有监听动作
//};



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self timer];
    [self observer];
    
}

- (void)observer
{
    /**
     *  @author Biao, 16-05-03 00:05:54  
     *
     *  参数一:CFAllocatorGetDefault():默认值
     *  参数二:监听什么状态
     *  参数三:是否重复监听
     *  参数四:0
     *  参数五:block代码块
     */
    
    /**
     *  @author Biao, 16-05-03 00:05:14
     *
     *  创建Observer
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"*****监听到RunLoop状态发送改变------>%zd",activity);
    });
    
    /**
     *  @author Biao, 16-05-03 00:05:28
     *
     *  添加观察者:监听RunLoop的状态
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    /**
     *  @author Biao, 16-05-03 00:05:14
     *
     *  释放Observer
     */
    CFRelease(observer);
}

/*
 CF的内存管理（Core Foundation）
 1.凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
 * 比如CFRunLoopObserverCreate
 2.release函数：CFRelease(对象);
 */



- (void)timer2
{
    // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 修改模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 定时器只运行在NSDefaultRunLoopMode下，一旦RunLoop进入其他模式，这个定时器就不会工作
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    // 定时器只运行在UITrackingRunLoopMode下，一旦RunLoop进入其他模式，这个定时器就不会工作
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    // 定时器会跑在标记为common modes的模式下
    // 标记为common modes的模式：UITrackingRunLoopMode和NSDefaultRunLoopMode
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)run
{
    NSLog(@"------->run<-------");
}



@end
