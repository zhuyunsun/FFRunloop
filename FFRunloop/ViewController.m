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
       //一直循环
     }while(true)
     
     一个APP启动时,会有一条主线程并且主线程中默认启动runloop.
     主线程中runloop:
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
     第一个是CoreFoundation框架中C语言,结构体
     第二个是Foundation框架中OC对象(是对第一个的一层对象级的封装)
     */
    
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
//    CFRunLoopRef cf = CFRunLoopGetCurrent();
}
@end
