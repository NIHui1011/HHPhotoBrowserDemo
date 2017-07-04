//
//  HHScaleAnimatorCoordinator.h
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/12.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHScaleAnimatorCoordinator : UIPresentationController
/// 动画结束后需要隐藏的view
@property(nonatomic,strong)UIView *currentHiddenView;
@property(nonatomic,strong)UIView *maskView;

- (void)updateCurrentHiddenView:(UIView *)view;
@end
