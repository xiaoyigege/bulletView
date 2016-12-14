//
//  BulletManger.m
//  弹幕
//
//  Created by 杨毅 on 16/12/13.
//  Copyright © 2016年 杨毅. All rights reserved.
//

#import "BulletManger.h"
#import "BulletView.h"

typedef enum : NSUInteger {
    Begin,
    Pause,
    Continue,
    Over,
} BulletViewStatus;


@interface BulletManger ()
//弹幕数据源数组
@property(nonatomic, strong) NSMutableArray * datasourceArray;
//弹幕使用过程中的数组变量
@property(nonatomic, strong) NSMutableArray * bulletCommentsArray;
//存储弹幕View的数组变量
@property(nonatomic, strong) NSMutableArray * bulletViewsArray;

//@property(nonatomic, assign) BOOL stopAnimation;
@property(nonatomic, assign) BulletViewStatus status;
@end
@implementation BulletManger

-(instancetype)init{
    self = [super init];
    if (self) {
        self.status = Over;
    }
    return self;
}
-(void)start{
    if (self.status != Over) {
        return;
    }
    self.status = Begin;
    [self.bulletCommentsArray removeAllObjects];
    [self.bulletCommentsArray addObjectsFromArray:self.datasourceArray];
    [self initBulletCommment];
}
-(void)pause{
    if (self.status == Over || self.status == Pause) {
        return;
    }
    self.status = Pause;
    [self.bulletViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView * view = obj;
        [view pauseAnimation];
    }];
}
-(void)continueBullet{
    if (self.status != Pause) {
        return;
    }
    self.status = Continue;
    [self.bulletViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView * view = obj;
        [view continueAnimation];
    }];
    [self initBulletCommment];
}
-(void)stop{
    if (self.status == Over) {
        return;
    }
    self.status = Over;
    [self.bulletViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView * view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViewsArray removeAllObjects];
}
-(void)initBulletCommment{
    NSMutableArray * trajectoryArray = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        if (self.bulletCommentsArray.count >0) {
            //        通过随机数获取弹幕轨迹
            NSInteger index = arc4random()%trajectoryArray.count;
            int trajectory = [[trajectoryArray objectAtIndex:index] intValue];
            [trajectoryArray removeObjectAtIndex:index];
            //        从弹幕数组中逐一取出弹幕数据
            NSString * comment = [self.bulletCommentsArray firstObject];
            [self.bulletCommentsArray removeObjectAtIndex:0];
            //创建弹幕view
            [self creatCommentBulletView:comment trajectory:trajectory];
        }

    }
    
}
-(void)creatCommentBulletView:(NSString *)comment trajectory:(int) trajectory{
    if (self.status == Over) {
        return;
    }
    BulletView * view = [[BulletView alloc]initWithComment:comment];
    view.trajectroy = trajectory;
//    [self.bulletViewsArray addObject:view];
    __weak typeof(view)weakView = view;
    __weak typeof(self)weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (weakSelf.status == Over) {
            return ;
        }
        switch (status) {
            case Start:{
                    //弹幕开始进入屏幕,将弹幕view加入弹幕管理数组
                [weakSelf.bulletViewsArray addObject:weakView];
                break;
            }
            case Enter:{
                //弹幕完全进入屏幕，判断是否还有弹幕，如果有，在该轨迹中继续创建一个
                NSString * comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf creatCommentBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End:{
                //弹幕完全移除屏幕  从bulletViewsArray中移除资源，销毁
                if ([weakSelf.bulletViewsArray containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViewsArray removeObject:weakView];
                }
                if (weakSelf.bulletViewsArray.count == 0) {
                    weakSelf.status = Over;
                }
                break;
            }
            default:
                break;
        }
    };
    if (self.generateBlock) {
        self.generateBlock(view);
    }
}
//加载下一条弹幕数据
-(NSString *)nextComment{
    if (self.bulletCommentsArray.count ==0 || self.status == Pause) {
        return nil;
    }
    NSString * comment = [self.bulletCommentsArray firstObject];
    if (comment) {
        [self.bulletCommentsArray removeObjectAtIndex:0];
    }
    return comment;
}
-(NSMutableArray *)datasourceArray{
    if (!_datasourceArray) {
        _datasourceArray = [NSMutableArray arrayWithArray:@[@"当程序员爱上梦幻",@"当回忆起那些年东海湾9级玩一月的时光",@"我们都已渐渐老去",@"但我们还可以追逐青春的梦想",@"群号361575819",@"逐梦青春欢迎你"]];
    }
    return _datasourceArray;
}
-(NSMutableArray *) bulletCommentsArray{
    if (!_bulletCommentsArray) {
        _bulletCommentsArray = [NSMutableArray array];
    }
    return _bulletCommentsArray
    ;
}
-(NSMutableArray *)bulletViewsArray{
    if (!_bulletViewsArray) {
        _bulletViewsArray = [NSMutableArray array];
    }
    return _bulletViewsArray;
}
@end
