//
//  ViewController.m
//  FFRunloop
//
//  Created by 朱运 on 2021/5/8.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark runloop的概念
    /*
     一般来说,开启一个线程,在线程内执行任务,执行完任务之后线程会退出销毁.
     现在需要一种机制:令线程随时可以处理任务,并且执行任务后不会退出销毁.
     iOS开发中定义了一种这样的机制:runloop
     runloop就像是一个不会停止的do while循环
     do{
       //code
     }while(true)
     
     一个APP启动时,会有一条主线程并且主线程中默认启动runloop.
     主线程中runloop作用:
     维持了APP存活(主线程默认启动runloop,主线程不会被销毁)
     处理各种响应事件(Selector事件,线程间Port,事件响应,手势识别,UI刷新,AutoreleasePool自动释放池,NSTimer事件等等),也称为任务
     节省cpu消耗,提高程序性能(没有任务时,主线程处于休眠状态;有任务时,主线程处于活跃状态)
     
     
     */
#pragma mark runloop和线程的关系
     /*
      线程和runloop一一对应,保存在一个字典中,线程是key,runloop是value;
      主线程默认开启对应的runloop,所以主线程会一直存在;
      子线程中存在runloop但默认不开启,需要手动开启;
      子线程中的runloop手动启动之后,需要手动停止,不然线程不会退出销毁;
      */
    
#pragma mark runloop相关的类
    /*
     关于runloop有两个相关的类
     第一个是CoreFoundation框架中C语言
     第二个是Foundation框架中OC对象(是对第一个的一层对象级的封装)
     
     runloop的行为
     
     设置当前runloop的mode,启动子线程的runloop
     进入每一次do-while执行任务时,可以切换不同的mode.
     获取当前线程的runloop,包括主线程的runloop
     观察当前子线程的runloop行为
     退出当前子线程的runloop
     
     

     */
    
    
    /*
     CoreFoundation框架
     C语言:结构体和函数,枚举,const常量
     CFRunLoop.h文件
     
     1,CFRunLoopRef:获取当前线程runloop和主线程runloop;
     2,CFRunLoopModeRef:runloop运行模式,只能选择其中一种,在不同的运行模式做不同的操作;
     3,CFRunLoopSourceRef:事件源,输入源;
     4,CFRunLoopTimerRef:定时器事件
     5,CFRunLoopObserverRef:观察者,观察runloop的状态;
     
     */
    
    //在子线程中启动对应的runloop
    dispatch_queue_t qu1 = dispatch_queue_create("qu1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(qu1, ^{
        //设定mode,并启动runloop
        CFRunLoopRef f = CFRunLoopGetCurrent();
        CFRunLoopAddCommonMode(f, kCFRunLoopCommonModes);
        CFRunLoopRun();
        
        NSLog(@"CFTypeID = %lu",CFRunLoopGetTypeID());
        //关闭runloop
        CFRunLoopStop(f);
        
        
        
        
//        CFRunLoopSourceRef s = nil;
//        CFRunLoopObserverRef o = nil;
//        CFRunLoopTimerRef t = nil;
//        CFRunLoopMode m = kCFRunLoopCommonModes;
        
    });
    
    
    
    
    
    [self runloopCoreFoundation];
    
#pragma mark runloop中的mode
    /*
     runloop在不同的mode下处理不同的事件;
     runloop每一次运行只能在其中的一种mode下运行;
     需要切换mode时,需要在下次进入循环之前进行切换;
     
     NSDefaultRunLoopMode:默认的mode,主线程的runloop mode就是默认在这种运行模式下运行.
     UITrackingRunLoopMode:当我们在主线程滑动ScrollView的时候,mode会切换到这种模式,保证不会受其他mode的影响.
     UIInitializationRunLoopMode:app刚启动时的mode,启动后就不会在使用,然后就会切换到defaultMode.
     GSEventReceiveRunLoopMode:内部系统的mode,通常使用不到;
     NSRunLoopCommonModes:一个占位mode,不能设置为runloop的运行模式,但是标记了defaultMode和trackingMode,表明timer/source/observer可以在这两种mode中的其中一种运行.
     
     */
    
#pragma mark runloop的应用
    
    
}
-(void)runloopCoreFoundation{
    /*
     启动子线程 -> 添加runloop观察者 -> 启动当前子线程runloop ->第一种手动退出(不会再执行后面的事件),第二种在完成任务后自动退出;
     */
    dispatch_queue_t q1 = dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT);
    //异步,并发队列:创建新的子线程
    dispatch_async(q1, ^{
        //创建runloop观察者
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                 switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;
              default:
                    break;
            }
         });
        //给runloop添加监听者
         CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
        //延迟事件,当runloop没有启动时,不会执行,因为子线程已经销毁退出;启动runloop之后,子线程一直存在,事件会在设定的时间之后执行;
        [self performSelector:@selector(addActionFrom) withObject:nil afterDelay:2];
        
        //启动当前子线程的runloop,设置当前runloop运行的mode
        CFRunLoopRef f = CFRunLoopGetCurrent();
        CFRunLoopAddCommonMode(f, kCFRunLoopDefaultMode);
        CFRunLoopRun();

    });
    
}
-(void)addActionFrom{
    NSLog(@"game 1");
    //关闭runloop
    CFRunLoopStop(CFRunLoopGetCurrent());
    //重新添加事件
    [self performSelector:@selector(addActionFrom2) withObject:nil afterDelay:1];
}
-(void)addActionFrom2{
    //如果在这个方法之前执行了关闭runloop操作,那么该事件不会再执行
    NSLog(@"game 2");
}
@end
