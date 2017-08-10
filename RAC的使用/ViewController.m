//
//  ViewController.m
//  RAC的使用
//
//  Created by iSongWei on 2017/6/6.
//  Copyright © 2017年 iSong. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ViewController2.h"

#import "RAC的使用-Swift.h"




@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textFild;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    SwiftVC * vc = [[SwiftVC alloc]init];
    NSLog(@"%@", vc);
    [vc log];
    
    
    #pragma mark - ===============RAC的简单使用===============
    
//    [self racDemo];
    
    #pragma mark - ===============RAC代理的使用===============
    
//    [self delegateDemo];
    
    #pragma mark - ===============RAC 通知的使用===============
    
    

    #pragma mark - ===============RAC KVO 的使用===============
    
    //RAC中得KVO大部分都是宏定义，所以代码异常简洁，简单来说就是RACObserve(TARGET, KEYPATH)这种形式，TARGET是监听目标，KEYPATH是要观察的属性值，
    
//    [self kvoDemo];
    
    #pragma mark - ===============信号===============生命周期
    //信号的生命周期
//    [self subscribeNext];
    
    

    
    #pragma mark - ===============一些字段的功能===============
    
//    [self stringFunction];
    
    
    #pragma mark - ===============RACSubject===============信号提供者，自己可以充当信号，又能发送信号
    //      RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
    //
    //      使用场景:通常用来代替代理，有了它，就不必要定义代理了。
    //      RACReplaySubject:重复提供信号类，RACSubject的子类。
    //
    //      RACReplaySubject与RACSubject区别:
    //      RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
    //      使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
    //      使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
//    [self Subject];
    
    #pragma mark - ===============RACSequence & RACTuple===============
    
    //RACTuple:元组类,类似NSArray,用来包装值.
    
    //RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
    
//    [self arrayAndDicFunction];
    
    #pragma mark - ===============RACCommand===============
    
    //RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
    
    //使用场景:监听按钮点击，网络请求
    
    [self RACCommand];
    
    
    #pragma mark - ===============RACMulticastConnection===============
 
    //用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
    
    //使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
    
//    [self multicastConnection];
}



-(void)subscribeNext{
    
    //RAC信号的订阅
    
    /*
     完成一个信号的生命周期分为四步：
     1、创建信号
     2、订阅信号
     3、发送信号
     4、取消订阅（图中未标明）
     */
    /*
     RAC的核心就是信号，即RACSignal。
     热/冷信号
     默认一个信号都是冷信号，也就是值改变了，也不会触发，
     只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
     手写一个RACSignal
     */
    
    
    //创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号"];
        // 可能两个都会终止
        [subscriber sendCompleted];
        [subscriber sendError:nil];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号销毁了");
        }];
        return nil;
    }];
    
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error = %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    
}




#pragma mark - ===============----===============
-(void)kvoDemo{
    
    UIScrollView  *sc = [[UIScrollView alloc]initWithFrame:(CGRectMake(0, 250, 300, 200))];
    sc.backgroundColor = [UIColor redColor];
    sc.contentSize = CGSizeMake(200, 800);
    [self.view addSubview:sc];
    [RACObserve(sc, contentOffset) subscribeNext:^(id x) {
        
        NSLog(@"ss");
        NSLog(@"%@", x);
//        UIScrollView * sss= (UIScrollView *)x;
//        NSLog(@"%@", NSStringFromCGPoint(sss.contentOffset));
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}




-(void)delegateDemo{
    
    
    //用RAC写代理是有局限的，它只能实现返回值为void的代理方法
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"测试" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSLog(@"%@", x.first);
        NSLog(@"%@", x.second);
        NSLog(@"%@", x.third);
        

    }];
    [alert show];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataArray];
}

-(void)racDemo{
    
    
    
    //textField 的使用
    
    
    [[self.textFild rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x){
        
        UITextField * textFild = (UITextField * )x;
        
        NSLog(@"%@", textFild.text);
        NSString * str = textFild.text.copy;
        if (textFild.text.length >= 3) {
            textFild.text = [str substringWithRange:(NSMakeRange(0, 3))];
        }
        NSLog(@"%@", textFild.text);
    }];
    
    //button 的使用
    
    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
        NSLog(@"%@", x);
        NSLog(@"button");
        [self delegateDemo];
    }];
    
    
    //tap
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        NSLog(@"tap");
//        
//
//        
//    }];
//    [self.view addGestureRecognizer:tap];
    
    
    
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    
    #pragma mark - ==============================
    id redV;
    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    // 4.代替通知
    // 把监听到的通知转换信号
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    
    // 5.监听文本框的文字改变
    [self.textFild.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    
    
    
    
    //8.3  @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，
    //需要自己手动导入，RACEXTScope.h才可以使用。
    //但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
    
    
    //8.4 RACTuplePack：把数据包装成RACTuple（元组类）
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10,@20);

}
// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

- (IBAction)push:(UIButton *)sender {
    

    
    ViewController2  * vc  = [[ViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)stringFunction{
#pragma mark - ===============map===============映射
    //信号的处理   返回值是订阅的映射
    //    [[self.textFild.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    //        NSLog(@"%@", value);
    //        return @(value.length);
    //    }] subscribeNext:^(id  _Nullable x) {
    //         NSLog(@"%@", x);
    //    }];
    
#pragma mark - ===============filter===============过滤
    //过滤当条件实现的时候才执行
    //    [[self.textFild.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
    //        return value.length > 3;
    //    }] subscribeNext:^(NSString * _Nullable x) {
    //        NSLog(@"x = %@", x);
    //    }];
    
    
#pragma mark - ===============take/skip/repeat===============添加条件
    /*
     take是获取，skip是跳过，这两个方法后面跟着的都是NSInteger。
     所以take 2就是获取前两个信号，
     skip 2就是跳过前两个。
     repeat是重复发送信号。
     */
    
    /*
     相似的还有
     takeLast
     takeUntil
     takeWhileBlock
     skipWhileBlock
     skipUntilBlock
     repeatWhileBlock
     */
    //
    //    RACSignal * signal = [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //
    //        [subscriber sendNext:@"1"];
    //        [subscriber sendNext:@"2"];
    //        [subscriber sendNext:@"3"];
    //        [subscriber sendNext:@"4"];
    //        [subscriber sendNext:@"5"];
    //        [subscriber sendCompleted];
    //        return nil;
    //
    //    }] take:2] repeat];
    //
    //    [signal  subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@", x);
    //    } completed:^{
    //        NSLog(@"completed");
    //    }];
    
#pragma mark - ===============delay===============延时
    //延时信号，顾名思义，即延迟发送信号。
    //    RACSignal * signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //        [subscriber sendNext:@"delay"];
    //        [subscriber sendCompleted];
    //        return nil;
    //    }] delay:2];
    //    NSLog(@"tag");
    //
    //    [signal subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    } completed:^{
    //        NSLog(@"completed");
    //    }];
    
#pragma mark - ===============throttle===============节流 666
    //加入节流管道只有0.5秒内不发生变化才执行
    //    [[[self.textFild rac_textSignal]throttle:0.5]subscribeNext:^(NSString * _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
#pragma mark - ===============distinctUntilChanged===============
    //网络请求中为了减轻服务器压力，无用的请求我们应该尽可能不发送。
    //distinctUntilChanged的作用是使RAC不会连续发送两次相同的信号，这样就解决了这个问题。
    //    [self.textFild.rac_textSignal.distinctUntilChanged subscribeNext:^(NSString * _Nullable x) {
    //        NSLog(@"%@", x);
    //    }];
    
    
#pragma mark - ===============timeout===============
    //超时信号，当超出限定时间后会给订阅者发送error信号。
    /*
     由于在创建信号是限定了延迟3秒发送，
     但是加了timeout2秒的限定，所以这一定是一个超时信号。
     这个信号被订阅后，由于超时，不会执行订阅成功的输出x方法，
     而是跳到error的块输出了错误信息。
     timeout在用RAC封装网络请求时可以节省不少的代码量。
     */
    
    //    RACSignal * signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //        [[RACScheduler mainThreadScheduler]afterDelay:3 schedule:^{
    //            [subscriber sendNext:@"delay"];
    //            [subscriber sendCompleted];
    //        }];
    //
    //        return nil;
    //    }] timeout:2 onScheduler:[RACScheduler mainThreadScheduler]];
    //
    //    [signal subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    } error:^(NSError * _Nullable error) {
    //        NSLog(@"%@",error);
    //    }];
    
#pragma mark - ===============ignore===============
    /*
     忽略信号，指定一个任意类型的量（可以是字符串，数组等），
     当需要发送信号时讲进行判断，若相同则该信号会被忽略发送。
     */
    
    //    [[self.textFild.rac_textSignal ignore:@"good"]subscribeNext:^(NSString * _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    
    //还有很多例如扁平映射flattenMap，Signal of Signals都没有提到
    
}


-(void)Subject{
    
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。

    //1 创建信号
    RACSubject * subject = [RACSubject subject];
    //2 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个信号订阅者");
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个信号订阅者");
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第三个信号订阅者");
    }];
    //3  发送信号
    [subject sendNext:@"1"];
    
    
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    
    //1 创建信号
    RACReplaySubject  *replaySubject = [RACReplaySubject subject];
    
    
    //2 发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    //3 订阅信号
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者接受到的数据");
    }];
    
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者接受到的数据");
    }];
    
    
    
    // RACSubject替换代理      类似于block
    
    
    // 需求:
    // 1.给当前控制器添加一个按钮，modal到另一个控制器界面
    // 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
    
    
    //步骤一：在第二个控制器.h，添加一个RACSubject代替代理。
    /*
     @interface TwoViewController : UIViewController
     
     @property (nonatomic, strong) RACSubject *delegateSignal;
     
     @end
     */
    
    
    //步骤二：监听第二个控制器按钮点击
    /*
     @implementation TwoViewController
     - (IBAction)notice:(id)sender {
     // 通知第一个控制器，告诉它，按钮被点了
     
     // 通知代理
     // 判断代理信号是否有值
        if (self.delegateSignal) {
            // 有值，才需要通知
            [self.delegateSignal sendNext:nil];
        }
     }
     @end
     */
    
    //步骤三：在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
    
    /*
     @implementation OneViewController
     - (IBAction)btnClick:(id)sender {
     
     // 创建第二个控制器
     TwoViewController *twoVc = [[TwoViewController alloc] init];
     
     // 设置代理信号
     twoVc.delegateSignal = [RACSubject subject];
     
        // 订阅代理信号
        [twoVc.delegateSignal subscribeNext:^(id x) {
     
            NSLog(@"点击了通知按钮");
        }];
     
     // 跳转到第二个控制器
     [self presentViewController:twoVc animated:YES completion:nil];
     
     }
     @end
     */
    

    
}

-(void)arrayAndDicFunction{
    
    //使用场景：1.字典转模型
    
    //RACSequence和RACTuple简单使用
    
    //便利数组
    
    NSArray * numbers = @[@1,@2,@3,@4,@5,];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    //2 便利字典  便利出来的键值对会包装成RACTuple(元组对象)
    
    NSDictionary * dic = @{
                           @"name":@"zsw" ,
                           @"age":@18
                           };
    
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        //解包元组  会把元组的值 按顺序给参数里面的变量赋值
        
        RACTupleUnpack(NSString * key, NSString * value) = x;
        
        // equal
        NSString * key1 = x[0];
        NSString * value1 = x[1];
        
        NSLog(@"x---%@", x);
        NSLog(@"%@--%@", key,value);
        NSLog(@"%@--%@", key1,value1);

        
    }];
    
    //3 字典转模型
    
    
    //3.1           OC写法
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *dict in dictArr) {
        //模型转换
        /*
         FlagItem *item = [FlagItem flagWithDict:dict];
         [items addObject:item];
         */
    }
    
    
    //3.2 写法
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr1 = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *flags = [NSMutableArray array];
    
    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr1.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
       
        // 运用RAC遍历字典，x：字典
        
        /*
         FlagItem *item = [FlagItem flagWithDict:x];
         [flags addObject:item];
         */
        
    }];
    
    //3.3 RAC 的高级写法
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr2 = [NSArray arrayWithContentsOfFile:filePath];
    
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    
    NSArray * flags2 = [[dictArr2.rac_sequence map:^id _Nullable(id  _Nullable value) {
        NSDictionary * dic= (NSDictionary *)value;
        return nil;
//        return [FlagItem flagWithDict:value];
    }] array];
    
}



-(void)RACCommand{
    
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    

    //1 创建命令
    
    RACCommand * command = [[RACCommand alloc ]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@" 执行命令");
        
        //创建空信号  用来传递信号
//        return [RACSignal empty];
        
        //2 创建信号  用来传递数据
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"请求数据"];
            
            //注意 : 数据传递完  最好调用completed  命令才执行完毕
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    
    //强引用命令   不要被销毁  否则接受不到数据
//    _command = command
    
    //3 订阅RACCommand中的信号
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }error:^(NSError * _Nullable error) {
            
        } completed:^{
            
        }];
    }];
    
    
    //RAC高级用法
    //
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"switchToLatest---%@",x);
    }];
    
    
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"boolValue正在执行");
            
        }else{
            // 执行完成
            NSLog(@"boolValue执行完成");
        }
    }];
    
    //执行
    [command execute:@1];
}


-(void)multicastConnection{
    
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    //需求: 假设在一个信号中发送请求    每次订阅都会发送请求  这样导致多次请求
    //解决: 使用RACMulticastConnection就能解决
    
    
    
    //1 创建请求信号
    
    RACSignal * signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSLog(@"发送请求");
//        [subscriber sendNext:nil];
        return nil;
    }];
    
    //2 订阅信号
    [signal0 subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受数据1");
    }];
    
    [signal0 subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受数据2");
    }];
    [signal0 subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受数据3");
    }];
    
    
    //3 运行结果  会执行两遍发送请求, 每次订阅发送一次
    
    // RACMulticastConnection:解决重复请求问题
    
    //1 创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求");
        
        [subscriber sendNext:@1];
//        [subscriber sendCompleted];
        return nil;
    }];
    
    //穿件连接
    RACMulticastConnection * connect = [signal publish];
    
    
    //3 订阅信号
    //注意  : 订阅信号, 也不能激活信号  只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者一信号");
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者二信号");
    }];
    
    //4 连接  激活信号
    [connect connect];
    
    
}




@end
