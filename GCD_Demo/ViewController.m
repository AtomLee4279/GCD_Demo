//
//  ViewController.m
//  GCD_Demo
//
//  Created by kaola  on 2019/1/21.
//  Copyright © 2019 hello. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self asyncConcurrent];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//同步执行+并发队列
-(void)syncConcurrent{
    NSLog(@"currnet Thread:---%@",[NSThread currentThread]);
    NSLog(@"======syncConcurrent:--begin========");
    
    //1.创建一个并发队列queue
    dispatch_queue_t queue = dispatch_queue_create("com.GCDDemo.sync.Concurrent", DISPATCH_QUEUE_CONCURRENT);
    //2.在queue中以同步执行方式执行任务（同步执行无法开启新线程）
    
    dispatch_sync(queue, ^{
        //添加任务1
        for (int i = 0; i<2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"1:--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //添加任务2
        for (int i =0; i<2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"2:--%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_sync(queue, ^{
        //添加任务3
        for (int i =0; i<2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"3:--%@",[NSThread currentThread]);
        }
        
    });
    //执行结果：1.任务都是在主线程上运行；2.任务按顺序执行
    NSLog(@"======syncConcurrent--end===========");
}

//异步执行+并发队列
-(void)asyncConcurrent{
    NSLog(@"====currentThrread%@====",[NSThread currentThread]);
    NSLog(@"====asyncConcurrent-begin====");
    //1.创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.GCDDemo.async.Concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    //2.在queue中以异步执行方式执行任务（异步执行可以开启新线程）
    dispatch_async(queue, ^{
        // 添加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 添加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 添加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"====asyncConcurrent-end====");
    
}

//造成进程死锁的案例:在同一个队列：主队列（主线程）中添加任务（执行的block）。
-(void)syncMain{
    NSLog(@"1");
    //主队列（对应主线程）等待block里面的内容（NSLog输出“2”）执行完；
    //而dispatch_sync的block里内容又在等待主队列（对应主线程）执行完NSLog输出“3”这一句完毕，才执行block里面的内容
    //相互等待，造成进程死锁= =
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}


//不会进程死锁的案例：在一个新的线程里将任务添加到主线程里执行
-(void)detachNewThread{
    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}


//异步执行+主队列：虽然异步执行具备开启新线程的能力，但是因为是主队列（串行队列的一种），所以不会开启新线程，只会在主线程中一个接一个执行任务
-(void)asyncMain{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
}


//线程间通信
-(void)threadCommunication{
    //获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //获取主队列
    dispatch_queue_t mainqueue = dispatch_get_main_queue();

}


@end
