//
//  BulletView.h
//  弹幕
//
//  Created by 杨毅 on 16/12/13.
//  Copyright © 2016年 杨毅. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Start,
    Enter,
    End,
} MoveStatus;
typedef void(^BulletBlock)(MoveStatus status);
@interface BulletView : UIView
@property(nonatomic, assign) int trajectroy;//弹道
@property(nonatomic, copy) BulletBlock  moveStatusBlock;//弹道状态的回调

//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment;
//开始动画
-(void)startAnimation;
//暂停动画
-(void)pauseAnimation;
//继续动画
-(void)continueAnimation;
//结束动画
-(void)stopAnimation;
@end
