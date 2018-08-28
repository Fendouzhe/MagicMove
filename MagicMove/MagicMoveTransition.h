//
//  MagicMoveTransition.h
//  MagicMove
//
//  Created by 雷路荣 on 2018/7/28.
//  Copyright © 2018年 leilurong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LRTransitionAnimationType) {
    LRTransitionAnimationTypePush,
    LRTransitionAnimationTypePop
};

@interface MagicMoveTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign)LRTransitionAnimationType type;

- (instancetype)initWithTransitionType:(LRTransitionAnimationType)type;

+ (instancetype)transitionType:(LRTransitionAnimationType)type;


@end
