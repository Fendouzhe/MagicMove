//
//  ViewController.m
//  MagicMove
//
//  Created by 雷路荣 on 2018/7/28.
//  Copyright © 2018年 leilurong. All rights reserved.
//

#import "DetailViewController.h"
#import "MagicMoveTransition.h"

@interface DetailViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong)UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

@end

@implementation DetailViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ///注意不要设置在viewDidload方法里面
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    
    ///添加左滑手势，用于进度返回
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIScreenEdgePanGestureRecognizer *)pan{
    
    CGFloat progress = [pan translationInView:self.view].x/self.view.frame.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:progress];
        
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        
        if (progress > 0.5) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }else{
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
    }
}

#pragma mark -- UINavigationControllerDelegate --

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return [MagicMoveTransition transitionType:LRTransitionAnimationTypePop];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    MagicMoveTransition *magic = (MagicMoveTransition *)animationController;
    if (magic.type == LRTransitionAnimationTypePop) {
        return self.percentDrivenInteractiveTransition;
    }
    return nil;
};

@end
