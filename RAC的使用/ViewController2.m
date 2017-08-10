//
//  ViewController2.m
//  RAC的使用
//
//  Created by iSongWei on 2017/6/6.
//  Copyright © 2017年 iSong. All rights reserved.
//

#import "ViewController2.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController2 ()
@property (nonatomic,strong) RACDisposable * ss;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
//    
//    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataArray];
//    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    _ss = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification * _Nullable x) {

        
        NSLog(@"%@", x.name);
        NSLog(@"%@", x.object);

        
    }];
    #pragma mark - ===============================
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sss:) name:@"postData" object:nil];
//}
//
//-(void)sss:(NSNotification *)x{
//    
//    NSLog(@"%@", x.name);
//    NSLog(@"%@", x.object);
}




-(void)dealloc{
    NSLog(@"注销");
    
    [_ss dispose];
    
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
