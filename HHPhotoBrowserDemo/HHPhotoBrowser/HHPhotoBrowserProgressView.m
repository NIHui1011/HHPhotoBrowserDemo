//
//  HHPhotoBrowserProgressView.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/19.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "HHPhotoBrowserProgressView.h"

@interface HHPhotoBrowserProgressView()

//外边界
@property(nonatomic,strong)CAShapeLayer *circleLayer;
//扇形区
@property(nonatomic,strong)CAShapeLayer *fanshapedLayer;

@end

@implementation HHPhotoBrowserProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (CGRectIsNull(frame)) {
            self.frame = CGRectMake(0, 0, 50, 50);
        }
        [self configUI];
        self.progress = 0;
    }
    return self;
    
}

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    NSLog(@"init(coder:) has not been implemented");
//    return nil;
//}

- (void)configUI{
    self.backgroundColor = [UIColor clearColor];
    CGColorRef strokeColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    
    _circleLayer = [CAShapeLayer new];
    _circleLayer.strokeColor = strokeColor;
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.path = [self makeCirclePath].CGPath;
    [self.layer addSublayer:_circleLayer];
    
    _fanshapedLayer = [CAShapeLayer new];
    _fanshapedLayer.fillColor = strokeColor;
    _fanshapedLayer.path = [UIBezierPath new].CGPath;
    [self.layer addSublayer:_fanshapedLayer];
    
    
}
- (UIBezierPath *)makeCirclePath{
    CGRect frame = self.bounds;
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(frame),CGRectGetMidY(frame));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:25 startAngle:0 endAngle:(CGFloat)(M_PI * 2) clockwise:true];
    path.lineWidth = 2;
    return path;
    
}
- (UIBezierPath *)makeProgressPath:(CGFloat)progress{
    CGRect frame = self.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(frame),CGRectGetMidY(frame));
    CGFloat radius = CGRectGetMidX(frame) - 2.5;
   
    UIBezierPath *path =[UIBezierPath new];
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(center.x+radius, center.y)];
//    [path addArcWithCenter:center radius:radius startAngle:-(CGFloat)(M_PI * 2) endAngle:-(CGFloat)(M_PI * 2) + (CGFloat)(M_PI * 2 * progress) clockwise:YES];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:0 + (CGFloat)(M_PI * 2 * progress) clockwise:YES];

    [path closePath];
    path.lineWidth = 1;
    return path;
    
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _fanshapedLayer.path = [self makeProgressPath:_progress].CGPath;
}
@end
