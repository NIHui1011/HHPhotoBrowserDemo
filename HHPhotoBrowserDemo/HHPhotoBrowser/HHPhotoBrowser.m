//
//  HHPhotoBrowser.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/11.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "HHPhotoBrowser.h"
#import "HHPhotoBrowserCell.h"
#import "HHPBFlowLayout.h"
#import "HHScaleAnimator.h"
#import "HHScaleAnimatorCoordinator.h"
#import <SDWebImageManager.h>
//typedef void(^Completion)();


@interface HHPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,HHPhotoBrowserCellDelegate>
@property(nonatomic,strong)UIViewController * presentingVC;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,weak)id<HHPhotoBrowserDelegate>photoBrowserDelegate;
@property(nonatomic,strong)UICollectionView *collectionView;
// 左右两张图之间的间隙(默认30)
@property(nonatomic,assign)CGFloat photoSpacing;
@property(nonatomic,strong)HHPBFlowLayout *flowLayout;

@property(nonatomic,strong)UIView *relatedView;
@property(nonatomic,strong)HHScaleAnimator *animator;
@property(nonatomic,strong)HHScaleAnimatorCoordinator *coordinator;

/// 保存原windowLevel
@property(nonatomic,assign)UIWindowLevel originWindowLevel;


@property(nonatomic,strong)UILabel *indexLabel;
@end

@implementation HHPhotoBrowser
static NSString * HHPhotoBrowserCellId = @"HHPhotoBrowserCell";


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.layer.borderWidth = 2;
    
#pragma warn
//    [[SDImageCache sharedImageCache] clearMemory];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] cleanDisk];

    [self.view addSubview:self.collectionView];

    //刷新数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [_collectionView layoutIfNeeded];
    
    
    //完善转场动画中缺失 endView和scaleView
    HHPhotoBrowserCell *cell = (HHPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    self.animator.endView = cell.imageView;
    UIImageView *imageview= [[UIImageView alloc] initWithImage:cell.imageView.image];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.clipsToBounds = YES;
    self.animator.scaleView = imageview;
    
    [self configOtherUI];
}

#pragma mark - getter Setter

- (CGFloat)photoSpacing{
    return 30;
}

- (HHPBFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[HHPBFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.flowLayout.minimumLineSpacing = self.photoSpacing;
        self.flowLayout.itemSize = self.view.bounds.size;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.frame = self.view.bounds;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        

        
        [_collectionView registerClass:[HHPhotoBrowserCell class] forCellWithReuseIdentifier:HHPhotoBrowserCellId];
    }
    return _collectionView;
}

/// 当前正在显示视图的前一个页面关联视图
- (UIView *)relatedView{
    if ([_photoBrowserDelegate respondsToSelector:@selector(photoBrowser:thumbnailImageForIndex:)]) {
        return [_photoBrowserDelegate photoBrowser:self thumbnailViewForIndex:_currentIndex];
    }else
        return [UIView new];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [_coordinator updateCurrentHiddenView:[self relatedView]];
   
}

#pragma mark - init
- (HHScaleAnimator *)animator{
    if (!_animator) {
        _animator = [[HHScaleAnimator alloc] initWithStartView:self.relatedView WithEndView:nil WithScaleView:nil];
    }
    return _animator;
}

- (instancetype)initWithshowByViewController:(UIViewController *)presentingVC WithHHPhotoBrowserDelegate:(id<HHPhotoBrowserDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.presentingVC = presentingVC;
        self.photoBrowserDelegate = delegate;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)showWithIndex:(NSInteger)index{
    self.currentIndex = index;
    self.modalPresentationCapturesStatusBarAppearance = true;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [self.presentingVC presentViewController:self animated:YES completion:^{}];
    
}

+ (HHPhotoBrowser *)ShowByViewController:(UIViewController *)presentedVC WithPhotoBrowserDelegate:(id<HHPhotoBrowserDelegate>)delegate WithPhotoIndex:(NSInteger)index{
    HHPhotoBrowser *browser = [[HHPhotoBrowser alloc] initWithshowByViewController:presentedVC WithHHPhotoBrowserDelegate:delegate];
    [browser showWithIndex:index];
    return browser;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 遮盖状态栏
    [self coverStatusBar:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self coverStatusBar:NO];
}

- (void)configOtherUI{
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = [UIScreen mainScreen].bounds.size.height;
    
    
    //navBar
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,W , 64)];
    navBar.backgroundColor = [UIColor colorWithWhite:.8 alpha:.8];
    [self.view addSubview:navBar];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(W/2.0 - 100/2, 20, 100, 44)];
    indexLabel.textAlignment = NSTextAlignmentCenter;
//    indexLabel.center = navBar.center;
    indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,[self.photoBrowserDelegate numberOfPhotosInPhotoBrowser:self]];
    [navBar addSubview:indexLabel];
    _indexLabel = indexLabel;
    
    //底部控制按钮
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, H - 49, W, 49)];
    bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    [self.view addSubview:bottomView];
    
    NSArray *btnNames = @[@" 0",@" 0",@"免费设计"];
    NSArray *btnImageNames = @[@"PBGrayloveBtn",@"PBGrayCmtBtn",@""];
    NSArray *btnScale = @[@(0.3),@(0.3),@(0.4)];
    NSArray *xOffset = @[@(0),@(0.3),@(0.6)];
    for (NSInteger i=0; i < btnNames.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake( W * [xOffset[i] floatValue], 0,  W *[btnScale[i] floatValue], 49)];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnImageNames[i]] forState:UIControlStateNormal];
        btn.tag = 4000 + i;
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
    }

}
#pragma mark - privaMethod
- (void)dismiss{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - click
- (void)bottomBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag - 4000;
    NSLog(@"%ld",index);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photoBrowserDelegate numberOfPhotosInPhotoBrowser:self];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HHPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HHPhotoBrowserCellId forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.delegate = self;
//    let (image, url) = imageFor(index: indexPath.item)
//    cell.setImage(image, url: url)
   
//    [cell setImageWithImage:[self.photoBrowserDelegate photoBrowser:self highQualityImageForIndex:indexPath.row] WithUrl:nil];
    [cell setImageWithImage:[self.photoBrowserDelegate photoBrowser:self highQualityImageForIndex:indexPath.row] WithUrl:[self.photoBrowserDelegate photoBrowser:self highQualityUrlStringForIndex:indexPath.row]];

//    cell.imageMaximumZoomScale = imageMaximumZoomScale
//    cell.imageZoomScaleForDoubleTap = imageZoomScaleForDoubleTap
    return cell;
}

/// 取已有图像，若有高清图，只返回高清图，否则返回缩略图和url
//- (id)imageForIndex:(NSInteger)index{
//    UIImage *highQualityImage ;
//    if ([self.photoBrowserDelegate respondsToSelector:@selector(photoBrowser:highQualityImageForIndex:)]) {
//        highQualityImage = [self.photoBrowserDelegate photoBrowser:self highQualityImageForIndex:index];
//    }
//    if (highQualityImage) {
//        return highQualityImage;
//    }
//    
//    NSURL *highQualityUrl;
//    if ([self.photoBrowserDelegate respondsToSelector:@selector(photoBrowser:highQualityUrlStringForIndex:)]) {
//        highQualityUrl = [self.photoBrowserDelegate photoBrowser:self highQualityUrlStringForIndex:index];
//        if (highQualityUrl) {
//            UIImage *cacheImage = nil;
//            BOOL isCached = [[SDWebImageManager sharedManager] cachedImageExistsForURL:highQualityUrl] || [[SDWebImageManager sharedManager] diskImageExistsForURL:highQualityUrl];
//            if (isCached) {//有缓存过图片
//                if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:highQualityUrl]) {
//                    cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:highQualityUrl.absoluteString];
//                }
//                if (cacheImage) {
//                    return cacheImage;
//                }
//                
//                if ([[SDWebImageManager sharedManager] diskImageExistsForURL:highQualityUrl]) {
//                    cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:highQualityUrl.absoluteString];
//                }
//                if (cacheImage) {
//                    return cacheImage;
//                }
//            
//            }else{//没有缓存过图片
//                return highQualityUrl;
//            }
//        }
//    }
//    if ([self.photoBrowserDelegate respondsToSelector:@selector(photoBrowser:thumbnailImageForIndex:)]) {
//        return  [self.photoBrowserDelegate photoBrowser:self thumbnailImageForIndex:index];
//
//    }
//    
//    return nil;
//}



#pragma mark - UICollectionViewDelegate
/// 减速完成后，计算当前页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width + _photoSpacing;
    self.currentIndex = (NSInteger)(offsetX / width);
//    NSLog(@"减速%ld",_currentIndex);
    
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,[self.photoBrowserDelegate numberOfPhotosInPhotoBrowser:self]];
}



#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    // 在本方法被调用时，endView和scaleView还未确定。需于viewDidLoad方法中给animator赋值endView
    return self.animator;
    
}

//转场协调器
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    _coordinator = [[HHScaleAnimatorCoordinator alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    _coordinator.currentHiddenView = self.relatedView;
    return _coordinator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    HHPhotoBrowserCell *cell = (HHPhotoBrowserCell *)[[_collectionView visibleCells] firstObject];
    UIImageView *imageview= [[UIImageView alloc] initWithImage:cell.imageView.image];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.clipsToBounds = YES;
    return [[HHScaleAnimator alloc] initWithStartView:cell.imageView WithEndView:self.relatedView WithScaleView:imageview];
}

#pragma mark - HHPhotoBrowserCellDelegate
- (void)HHPhotoBrowserCellDidSingleTap:(HHPhotoBrowserCell *)cell{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)HHPhotoBrowser:(HHPhotoBrowserCell *)cell didPanScale:(CGFloat)scale{
    // 实测用scale的平方，效果比线性好些
    CGFloat alpha = scale * scale;
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
//    [UIView animateWithDuration:.1 animations:^{
//        self.view.backgroundColor = [UIColor colorWithRed:alpha green:alpha blue:alpha alpha:alpha];
//    }];
    self.view.alpha = alpha;
    // 半透明时重现状态栏，否则遮盖状态栏
    [self coverStatusBar: alpha>=0 ];
}

#pragma mark - WindowLevelStatusBar
/// 遮盖状态栏。以改变windowLevel的方式遮盖
- (void)coverStatusBar:(BOOL) cover{
    UIWindow *window = self.view.window;
    if (!window) {
        return;
    }
    if (self.originWindowLevel) {
        self.originWindowLevel = window.windowLevel;
    }
    if (cover) {
        if (window.windowLevel == UIWindowLevelStatusBar + 1) {
            return;
        }
        window.windowLevel = UIWindowLevelStatusBar + 1;
    }else{
        if (window.windowLevel == self.originWindowLevel) {
            return;
        }
        window.windowLevel = self.originWindowLevel;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
