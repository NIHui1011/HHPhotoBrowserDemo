//
//  ViewController.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/11.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "ViewController.h"

#import "HHPhotoBrowser.h"

@interface ViewController ()<HHPhotoBrowserDelegate>
{
    NSArray *_imageArray;
    NSArray * _thumbnailImageUrls;
    NSArray *_highQualityImageUrls;
    NSInteger  _clickIndex;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _clickIndex = 0;
    [self loadData];
    [self configUI];
}

- (void)loadData{
    _imageArray = @[
                    [UIImage imageNamed:@"photo1"],
                    [UIImage imageNamed:@"photo2"],
                    [UIImage imageNamed:@"photo3"],
                    [UIImage imageNamed:@"photo4"],
                    [UIImage imageNamed:@"photo5"],
                    [UIImage imageNamed:@"photo6"],
                    [UIImage imageNamed:@"photo7"],
                    [UIImage imageNamed:@"photo8"],
                    [UIImage imageNamed:@"photo9"]
                    ];
    
    _thumbnailImageUrls= @[
                           @"http://wx1.sinaimg.cn/thumbnail/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                           @"http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                           @"http://wx1.sinaimg.cn/thumbnail/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                           @"http://wx2.sinaimg.cn/thumbnail/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                           @"http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                           @"http://wx4.sinaimg.cn/thumbnail/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                           @"http://wx2.sinaimg.cn/thumbnail/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                           @"http://wx4.sinaimg.cn/thumbnail/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                           @"http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7usmc8j20i543zngx.jpg"];
    
    
    _highQualityImageUrls =  @[
                               @"http://wx1.sinaimg.cn/large/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                               @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                               @"http://wx1.sinaimg.cn/large/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                               @"http://wx2.sinaimg.cn/large/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                               @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                               @"http://wx4.sinaimg.cn/large/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                               @"http://wx2.sinaimg.cn/large/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                               @"http://wx4.sinaimg.cn/large/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                               @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7usmc8j20i543zngx.jpg",];
    
    
}

- (void)configUI{
    for (NSInteger i=0; i<_imageArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80 + i/3 * 80 , 80 + i%3 *80, 60, 60)];
        [btn setImage:_imageArray[i] forState:UIControlStateNormal];
        btn.tag = 100 +i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn{
    NSLog(@"%ld",btn.tag-100);
    _clickIndex = btn.tag - 100;
    [HHPhotoBrowser ShowByViewController:self WithPhotoBrowserDelegate:self WithPhotoIndex:_clickIndex];
}


#pragma mark -
/// 实现本方法以返回图片数量
- (NSInteger)numberOfPhotosInPhotoBrowser:(HHPhotoBrowser *)browser{
    return _imageArray.count;
}
/// 实现本方法以返回默认图片，缩略图或占位图
- (UIImage *)photoBrowser:(HHPhotoBrowser *)photoBrowser thumbnailImageForIndex:(NSInteger)index{
    return _imageArray[index];
}
/// 实现本方法以返回高质量图片。可选
- (UIImage *)photoBrowser:(HHPhotoBrowser *)photoBrowser highQualityImageForIndex:(NSInteger)index{
    return _imageArray[index];
}
/// 实现本方法以返回高质量图片的url。可选
- (NSURL *)photoBrowser:(HHPhotoBrowser *)photoBrowser highQualityUrlStringForIndex:(NSInteger)index{
    return [NSURL URLWithString:_highQualityImageUrls[index]];
}


- (UIView *)photoBrowser:(HHPhotoBrowser *)photoBrowser thumbnailViewForIndex:(NSInteger)index{
    UIView *view = [self.view viewWithTag:index + 100];;
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
