//
//  MagicMoveTransition.m
//  MagicMove
//
//  Created by 雷路荣 on 2018/7/28.
//  Copyright © 2018年 leilurong. All rights reserved.
//

#import "MagicMoveTransition.h"
#import "CollectionViewController.h"
#import "DetailViewController.h"

@implementation MagicMoveTransition

- (instancetype)initWithTransitionType:(LRTransitionAnimationType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

+ (instancetype)transitionType:(LRTransitionAnimationType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    switch (self.type) {
        case LRTransitionAnimationTypePush:
            [self pushByTransition:transitionContext];
            break;
        case LRTransitionAnimationTypePop:
            [self popByTransition:transitionContext];
            break;
        default:
            break;
    }
}

- (void)pushByTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //1.获取动画的源控制器和目标控制器
    CollectionViewController *fromVc = (CollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DetailViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //transitionContext.containerView一般是源控制器的view,可以打印出来试试
    UIView *containView = transitionContext.containerView;
    /*
    //只有 UICollectionViewControllerWrapperView即UICollectionView
    [containView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj = %@",obj);
    }];
    */
    //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
    UIView *snapView = [fromVc.selectCell.iconView snapshotViewAfterScreenUpdates:NO];
    //设置截图的frame,将fromVc.selectCell.iconView.frame从fromVc.selectCell中转换到当前视图中，返回在当前视图中的rect
    snapView.frame = [containView convertRect:fromVc.selectCell.iconView.frame fromView:fromVc.selectCell];
    NSLog(@"snapView.frame = %@",NSStringFromCGRect(snapView.frame));
    fromVc.selectCell.iconView.hidden = YES;
    
    //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];//可不设置，没什么用
    toVc.view.alpha = 0;
    
    //4.都添加到 container 中。注意顺序不能错了
    [containView addSubview:toVc.view];
    [containView addSubview:snapView];
    
    //5. 执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapView.frame = toVc.imageView.frame;
        toVc.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromVc.selectCell.iconView.hidden = NO;
        [snapView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)popByTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //获取源控制器和目标控制器
    DetailViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CollectionViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //transitionContext.containerView一般是源控制器的view,可以打印出来试试
    UIView *contaiView = transitionContext.containerView;
    
    //创建截图
    UIView *snapView = [fromVc.imageView snapshotViewAfterScreenUpdates:NO];
    //设置截图frame
    snapView.frame = [contaiView convertRect:fromVc.imageView.frame fromView:fromVc.view];
    NSLog(@"snapView.frame = %@",NSStringFromCGRect(snapView.frame));
    //可不设置，没什么用
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    
    ///添加containView里面去
    [contaiView addSubview:toVc.view];
    [contaiView addSubview:snapView];
    
    toVc.selectCell.iconView.hidden = YES;
    toVc.view.alpha = 0;
    //fromVc.view.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //toVc.view即为UICollectionView
        snapView.frame = [toVc.view convertRect:toVc.selectCell.frame toView:toVc.view];
        toVc.view.alpha = 1;
        //fromVc.view.alpha = 0;
    } completion:^(BOOL finished) {
        toVc.selectCell.iconView.hidden = NO;
        [snapView removeFromSuperview];
        //不要直接写YES 否则DetailViewController 中 [self.percentDrivenInteractiveTransition cancelInteractiveTransition];时会黑屏
        //[transitionContext completeTransition:YES];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
