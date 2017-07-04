//
//  HHPhotoBrowserCell.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/11.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "HHPhotoBrowserCell.h"
#import "HHPhotoBrowserProgressView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface HHPhotoBrowserCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
//@property(nonatomic,strong)UIImageView *imageView;
//@property(nonatomic,strong)UIScrollView *scrollView;
//@property(nonatomic,assign)CGSize fitSize;
//@property(nonatomic,assign)CGRect fitFrame;
//@property(nonatomic,strong)UIView *progressView;
@property(nonatomic,assign)CGPoint centerOfContentSize;

/// 记录pan手势开始时imageView的位置
@property(nonatomic,assign)CGRect beganFrame;
/// 记录pan手势开始时，手势位置
@property(nonatomic,assign)CGPoint beganTouch;


@property(nonatomic,strong)UIView *descScrollView;

@end

@implementation HHPhotoBrowserCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _beganFrame = CGRectZero;
        _beganTouch = CGPointZero;
        _progressView = [[HHPhotoBrowserProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _progressView.hidden = YES;
        [self addSubview:_progressView];
        
        /// 图像加载视图
        _imageView = [UIImageView new];
        /// 内嵌容器。本类不能继承UIScrollView。
        /// 因为实测UIScrollView遵循了UIGestureRecognizerDelegate协议，而本类也需要遵循此协议，
        /// 若继承UIScrollView则会覆盖UIScrollView的协议实现，故只内嵌而不继承。
        _scrollView = [UIScrollView new];
        
        [self.contentView addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [_scrollView addSubview:_imageView];
        _imageView.clipsToBounds = YES;
        
        
        _imageView.userInteractionEnabled = YES;
        
        // 双击手势
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubleTap];
        
        //单击手势
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:singleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        pan.delegate = self;
        [_imageView addGestureRecognizer:pan];
        
        [self configUIForDescScorllViewAndBottomView];
    }
    return self;
}

- (void)configUIForDescScorllViewAndBottomView{
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = [UIScreen mainScreen].bounds.size.height;
    
    
    //添加描述文本
    _descScrollView = [[UIView alloc] initWithFrame:CGRectMake(0,H - 49 - 120, W , 120)];
    _descScrollView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.8];
    [self addSubview:_descScrollView];
    
    UILabel *title = [UILabel new];
    title.text = @"案例标题";
    title.font = [UIFont systemFontOfSize:12 weight:12];
//    title.backgroundColor =[UIColor redColor];
    [_descScrollView addSubview:title];
    
    UITextView *textView = [UITextView new];
    textView.text = @"描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述";
    textView.font = [UIFont systemFontOfSize:12];
    textView.backgroundColor = [UIColor clearColor];
    [_descScrollView addSubview:textView];
    
    
    UIView *labelView = [UIView new];
    labelView.backgroundColor = [UIColor blueColor];
    [_descScrollView addSubview:labelView];
    
    
    CGFloat space = 10;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_descScrollView).offset(space);
        make.right.equalTo(_descScrollView).offset(-space);
        make.height.equalTo(@(20));
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_descScrollView).offset(space);
        make.right.equalTo(_descScrollView).offset(-space);
        make.top.equalTo(title.mas_bottom).offset(0);
        make.bottom.equalTo(labelView.mas_top).offset(-4);
    }];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_descScrollView).offset(-space);
        make.left.equalTo(_descScrollView).offset(space);
        make.height.mas_equalTo(30);
    }];

    
    
    
//    //底部控制按钮
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, H - 49, W, 49)];
//    bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
//    [self addSubview:bottomView];
//    
//    NSArray *btnNames = @[@" 0",@" 0",@"免费设计"];
//    NSArray *btnImageNames = @[@"PBGrayloveBtn",@"PBGrayCmtBtn",@""];
//    NSArray *btnScale = @[@(0.3),@(0.3),@(0.4)];
//    NSArray *xOffset = @[@(0),@(0.3),@(0.6)];
//    for (NSInteger i=0; i < btnNames.count; i++) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake( W * [xOffset[i] floatValue], 0,  W *[btnScale[i] floatValue], 49)];
//        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:btnImageNames[i]] forState:UIControlStateNormal];
//        btn.tag = 4000 + i;
//        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:btn];
//    }

}

 /// 计算contentSize应处于的中心位置
- (CGPoint)centerOfContentSize{
    CGFloat deltaWidth = self.bounds.size.width - _scrollView.contentSize.width;
    //缩小的情况
    CGFloat offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0;
    CGFloat deltaHeight = self.bounds.size.height - _scrollView.contentSize.height;
    CGFloat offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0;
    return CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);

}

/// 取图片适屏size
- (CGSize)fitSize{
    UIImage *image = _imageView.image;
    if (!image) {
        return CGSizeZero;
    }
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat scale = image.size.height / image.size.width;
    return CGSizeMake(width, width * scale);
}


/// 取图片适屏frame
- (CGRect)fitFrame{
    CGSize size = self.fitSize;
    CGFloat y = (_scrollView.bounds.size.height - size.height) > 0 ? (_scrollView.bounds.size.height - size.height) * 0.5 : 0;
    return CGRectMake(0, y, size.width, size.height);
}


/// 布局
- (void)doLayout{
    _scrollView.frame = self.contentView.bounds;
    [_scrollView setZoomScale:1.0 animated:NO];
    _imageView.frame = self.fitFrame;
    self.progressView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
}


/// 设置图片。image为placeholder图片，url为网络图片
- (void)setImageWithImage:(UIImage *)image WithUrl:(NSURL *)url{
    if (image) {
        _imageView.image = image;
        [self doLayout];
//        return;
    }
    if (!url) {
        return;
    }
    //处理url加载图片
    self.progressView.hidden = NO;
    __weak typeof(self) ws = self;
    
    [_imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        if (expectedSize>=0) {
            ws.progressView.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
//        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:url];
        ws.progressView.hidden = YES;
        [ws doLayout];
    }];
    [self doLayout];
    
}

#pragma mark - click
///bottomBtnClick
//- (void)bottomBtnClick:(UIButton *)btn{
//    NSInteger index = btn.tag - 4000;
//    NSLog(@"%ld",index);
//}

#pragma mark - gesture
- (void)onDoubleTap:(UITapGestureRecognizer *)tap{
    CGFloat scale = _scrollView.maximumZoomScale;
    if (_scrollView.zoomScale == _scrollView.maximumZoomScale) {
        scale = 1;
    }
    [_scrollView setZoomScale:scale animated:YES ];
}
- (void)onSingleTap:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(HHPhotoBrowserCellDidSingleTap:)]) {
        [_delegate HHPhotoBrowserCellDidSingleTap:self];
    }
}

- (void)onPan:(UIPanGestureRecognizer *)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            _beganFrame = _imageView.frame;
            _beganTouch = [pan locationInView:_scrollView];
            break;}
     
        case UIGestureRecognizerStateChanged:{

            // 拖动偏移量
            
            CGPoint translation = [pan translationInView:_scrollView];
            CGPoint  currentTouch = [pan locationInView:_scrollView];
            
            
            // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
            
            CGFloat scale = MIN(1.0, MAX(0.3,1- translation.y/self.bounds.size.height ));
            CGSize theFitSize = [self fitSize];
            CGFloat width = theFitSize.width * scale;
            CGFloat height = theFitSize.height * scale;
            
            
            // 计算x和y。保持手指在图片上的相对位置不变。
            // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
            CGFloat xRate = (_beganTouch.x - _beganFrame.origin.x) / _beganFrame.size.width;
            CGFloat currentTouchDeltaX = xRate * width;
            CGFloat x = currentTouch.x - currentTouchDeltaX;
         
            CGFloat yRate = (_beganTouch.y - _beganFrame.origin.y) / _beganFrame.size.height;
            CGFloat currentTouchDeltaY = yRate * height;
            CGFloat y = currentTouch.y - currentTouchDeltaY;
            
            self.imageView.frame = CGRectMake(x,  y,  width,  height);
        
            
            
            // 通知代理，发生了缩放。代理可依scale值改变背景蒙板alpha值
            if ([_delegate respondsToSelector:@selector(HHPhotoBrowser:didPanScale:)]) {
                [_delegate HHPhotoBrowser:self didPanScale:scale];
            }

            
            break;}
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGPoint v = [pan velocityInView:self];
            if ( v.y > 0) {
                //dismiss
                [self onSingleTap:nil];
            }else{
                //取消dismiss
                [self endPan];
            }
            break;
        }
        default:
            [self endPan];
            break;
    }
}

- (void)endPan{
    if ([_delegate respondsToSelector:@selector(HHPhotoBrowser:didPanScale:)]) {
        [_delegate HHPhotoBrowser:self didPanScale:1.0];
    }
    
    // 如果图片当前显示的size小于原size，则重置为原size
    CGSize size = self.fitSize;
    CGFloat needResetSize = _imageView.bounds.size.width < size.width
    || _imageView.bounds.size.height < size.height;
   
    [UIView animateWithDuration:.25 animations:^{
        
        if (needResetSize) {
            CGRect frame = self.imageView.frame;
//            self.imageView.bounds.size = size;
            self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
            
            
        }
        self.imageView.center = self.centerOfContentSize;
    }];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 只响应pan手势
    
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [pan  velocityInView:self];
    // 向上滑动时，不响应手势
    if (velocity.y < 0) {
        return NO;
    }
    // 横向滑动时，不响应pan手势
    if (ABS((NSInteger)(velocity.x)) > (NSInteger)(velocity.y))   {
        return NO;
    }
    // 向下滑动，如果图片顶部超出可视区域，不响应手势
    if (_scrollView.contentOffset.y > 0) {
        return NO;
    }
    
    return YES;
    


}



#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    _imageView.center = centerOfContentSize;
    
    //图片保存在内容视图的中心???
    _imageView.center = self.centerOfContentSize;

}




@end
