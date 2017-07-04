//
//  HHScaleAnimatorCoordinator.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/12.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "HHScaleAnimatorCoordinator.h"

@interface HHScaleAnimatorCoordinator()



@end

@implementation HHScaleAnimatorCoordinator

/// 蒙板
- (UIView *)maskView{
    if (!_maskView) {
        _maskView  = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return _maskView;
}

/// 更新 动画结束后需要隐藏的view
- (void)updateCurrentHiddenView:(UIView *)view{
    _currentHiddenView.hidden = NO;
    _currentHiddenView = view;
    _currentHiddenView.hidden = YES;
}

- (void)presentationTransitionWillBegin{
    [super presentationTransitionWillBegin];
    if (!self.containerView) {
        return;
    }
    self.maskView.frame = self.containerView.bounds;
    self.maskView.alpha = 0;
    [self.containerView addSubview:self.maskView];
    self.currentHiddenView.hidden = YES;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.alpha = 1;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}


- (void)dismissalTransitionWillBegin{
    [super dismissalTransitionWillBegin];
    self.currentHiddenView.hidden = YES;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.currentHiddenView.hidden = NO;
    }];
}

@end
