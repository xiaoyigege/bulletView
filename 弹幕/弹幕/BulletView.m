

//
//  BulletView.m
//  弹幕
//
//  Created by 杨毅 on 16/12/13.
//  Copyright © 2016年 杨毅. All rights reserved.
//

#import "BulletView.h"
#define Padding 10
@interface BulletView()
@property(nonatomic, strong) UILabel * barrageLabel;
@end
@implementation BulletView

//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        //计算弹幕的实际宽度
        NSDictionary * attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attrDic].width;
        self.bounds = CGRectMake(0, 0, width + 2 *Padding, 30);
         self.barrageLabel.text = comment;
        self.barrageLabel.frame = CGRectMake(Padding, 0, width, 30);
       
    }
    return self;
}
//开始动画
-(void)startAnimation{
    //根据弹幕长度执行动画效果
    //相同的动画时间间隔，弹幕文字越长  弹幕速度越快
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
//    v= s/t
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    //延迟方法   在此延迟之后弹幕完全进入屏幕 
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    //GCD的延迟方法  在其执行过程中无法中途停止，因为会涉及到中途停止弹幕进入的需求实现，所以不可以使用
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //弹幕完全进入
//        if (self.moveStatusBlock) {
//            self.moveStatusBlock(Enter);
//        }
//    });
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //弹幕结束
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}
//弹幕完全进入界面
-(void)enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }

}
-(void)pauseAnimation{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设置layer的timeOffset, 在继续操作也会使用到
    self.layer.timeOffset = pauseTime;
    
    // local time与parent time的比例为0, 意味着local time暂停了
    self.layer.speed = 0;

}
- (void)continueAnimation{
    // 时间转换
    CFTimeInterval pauseTime = self.layer.timeOffset;
    // 计算暂停时间
    CFTimeInterval timeSincePause = CACurrentMediaTime() - pauseTime;
    // 取消
    self.layer.timeOffset = 0;
    // local time相对于parent time世界的beginTime
    self.layer.beginTime = timeSincePause;
    // 继续
    self.layer.speed = 1;
}

//结束动画
-(void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}
-(UILabel *)barrageLabel{
    if (!_barrageLabel) {
        _barrageLabel = [[UILabel alloc]init];
        _barrageLabel.font = [UIFont systemFontOfSize:14];
        _barrageLabel.textColor = [UIColor whiteColor];
        _barrageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_barrageLabel];
    }
    return _barrageLabel;
}

@end
