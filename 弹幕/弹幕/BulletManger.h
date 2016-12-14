//
//  BulletManger.h
//  弹幕
//
//  Created by 杨毅 on 16/12/13.
//  Copyright © 2016年 杨毅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
typedef void(^GenerateViewBlock)(BulletView * view);
@interface BulletManger : NSObject

@property(nonatomic, copy) GenerateViewBlock generateBlock;
//弹幕开始执行
-(void)start;
//弹幕结束执行
-(void)stop;
//弹幕暂停
-(void)pause;
//弹幕暂停之后的继续
-(void)continueBullet;
@end
