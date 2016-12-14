//
//  ViewController.m
//  弹幕
//
//  Created by 杨毅 on 16/12/13.
//  Copyright © 2016年 杨毅. All rights reserved.
//
/*
 
 特别感谢慕课网的讲师，此demo是对其视频课程的展现于拓展
 
 
 */
#import "ViewController.h"
#import "BulletView.h"
#import "BulletManger.h"
@interface ViewController ()
@property(nonatomic, strong) BulletManger * bulletManger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bulletManger = [[BulletManger alloc]init];
    __weak typeof(self)weakSelf = self;
    self.bulletManger.generateBlock = ^(BulletView * view){
        [weakSelf addBulletView:view];
    };
    UIButton * starButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    starButton.frame = CGRectMake(100, 100, 100, 100);
    [starButton setTitle:@"开始" forState:(UIControlStateNormal)];
    [starButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [starButton addTarget:self action:@selector(btAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:starButton];
    
    
    UIButton * pauseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    pauseButton.frame = CGRectMake(250, 100, 100, 100);
    [pauseButton setTitle:@"暂停" forState:(UIControlStateNormal)];
    [pauseButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [pauseButton addTarget:self action:@selector(btAction1) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pauseButton];
    
    
    UIButton * continueButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    continueButton.frame = CGRectMake(100, 250, 100, 100);
    [continueButton setTitle:@"继续" forState:(UIControlStateNormal)];
    [continueButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [continueButton addTarget:self action:@selector(btAction2) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:continueButton];

    
    UIButton * endButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    endButton.frame = CGRectMake(250, 250, 100, 100);
    [endButton setTitle:@"结束" forState:(UIControlStateNormal)];
    [endButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [endButton addTarget:self action:@selector(btAction3) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:endButton];
    
    UIButton * giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    giftButton.frame = CGRectMake(100, 400, 100, 100);
    [giftButton setTitle:@"礼物" forState:(UIControlStateNormal)];
    [giftButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [giftButton addTarget:self action:@selector(giftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:giftButton];
    
    
    
    
    UIImageView * giftView  = [[UIImageView alloc]init];
    giftView.tag = 100;
    giftView.frame = CGRectMake(-200, 200, 200, 200);
    [giftView setImage:[UIImage imageNamed:@"gift.jpeg"]];
    [self.view addSubview:giftView];
}
-(void)btAction{
    [self.bulletManger start];
}
-(void)btAction1{
    [self.bulletManger pause];
}
-(void)btAction2{
    [self.bulletManger continueBullet];
}
-(void)btAction3{
    [self.bulletManger stop];
}
-(void)giftAction{
    UIImageView * giftView = [self.view viewWithTag:100];
    giftView.hidden = NO;
    [UIView animateWithDuration:2 delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        
        giftView.frame = CGRectMake(10, 200, 200, 200);
    } completion:^(BOOL finished) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        giftView.hidden = YES;
         giftView.frame = CGRectMake(-200, 200, 200, 200);
    });
}
-(void)addBulletView:(BulletView *)view{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectroy * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
