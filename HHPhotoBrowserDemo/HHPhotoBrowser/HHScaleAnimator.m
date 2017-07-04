//
//  HHScaleAnimator.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/12.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "HHScaleAnimator.h"


@interface HHScaleAnimator()<UIViewControllerAnimatedTransitioning>


@end

@implementation HHScaleAnimator
- (instancetype)initWithStartView:(UIView *)startView WithEndView:(UIView *)endView WithScaleView:(UIView *)scaleView
{
    self = [super init];
    if (self) {
        self.startView = startView;
        self.endView = endView;
        self.scaleView = scaleView;
    }
    return self;
}

///转场动画实现
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!fromVC && !fromView) {
        return;
    }
    
    
    // 判断是presentataion动画还是dismissal动画
    BOOL isPresentation = (toVC.presentingViewController == fromVC);
    
    if (!isPresentation) {
        fromView.hidden = YES;
    }
    
    //转场中介容器
    UIView * containerView = transitionContext.containerView;
    
    if (!self.startView || !self.endView || !self.scaleView) {
        return;
    }
    
    
    CGRect startFrame = [_startView.superview convertRect:_startView.frame toView:containerView];
    if (CGRectIsNull(startFrame) ){
        NSLog(@"无法获取startFrame");
        return;
    }
    
//    // 暂不求endFrame
//    CGRect endFrame = startFrame;
//    CGFloat endAlpha = 0.0;
// 
//    if (self.endView) {
//        // 当前正在显示视图的前一个页面关联视图已经存在，此时分两种情况
//        // 1、该视图显示在屏幕内，作scale动画
//        // 2、该视图不显示在屏幕内，作fade动画
//        CGRect relativeFrame = [_endView convertRect:_endView.bounds toView:nil];
//        CGRect keyWindowBounds = [UIScreen mainScreen].bounds;
//        if (CGRectIntersectsRect(keyWindowBounds, relativeFrame) ) {
//            // 在屏幕内，求endFrame，让其缩放
//            endAlpha = 1.0;
//            endFrame = [_endView convertRect:_endView.bounds toView:containerView];
//           
//        }
//    }
//    _scaleView.frame = startFrame;
//    [containerView addSubview:_scaleView];
   
    
    CGRect endFrame = [_endView.superview convertRect:_endView.frame toView:containerView];
    if (CGRectIsNull(endFrame) ){
        NSLog(@"无法获取endFrame");
        return;
    }
    _scaleView.frame = startFrame;
    
    [containerView addSubview:_scaleView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        _scaleView.frame = endFrame;
    } completion:^(BOOL finished) {
        // presentation转场，需要把目标视图添加到视图栈
        
        if (isPresentation && toView) {
            [containerView addSubview:toView];
        }
        
        [_scaleView removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
   
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .3;
}



@end
