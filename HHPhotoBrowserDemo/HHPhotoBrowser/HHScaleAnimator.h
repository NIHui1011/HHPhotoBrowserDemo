//
//  HHScaleAnimator.h
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/12.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHScaleAnimator : NSObject<UIViewControllerAnimatedTransitioning>
/// 动画开始位置的视图
@property(nonatomic,strong)UIView *startView;
/// 动画结束位置的视图
@property(nonatomic,strong)UIView *endView;
/// 用于转场时的缩放视图
@property(nonatomic,strong)UIView *scaleView;

- (instancetype)initWithStartView:(UIView *)startView WithEndView:(UIView *)endView WithScaleView:(UIView *)scaleView;
@end
