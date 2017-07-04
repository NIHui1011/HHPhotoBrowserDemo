//
//  HHPhotoBrowser.h
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/11.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPhotoBrowserCell.h"
#import "HHPBFlowLayout.h"
#import "HHScaleAnimator.h"
#import "HHScaleAnimatorCoordinator.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>



@class HHPhotoBrowser;
@protocol HHPhotoBrowserDelegate <NSObject>
/// 实现本方法以返回图片数量
- (NSInteger)numberOfPhotosInPhotoBrowser:(HHPhotoBrowser *)browser;
/// 实现本方法以返回默认图片，缩略图或占位图
- (UIImage *)photoBrowser:(HHPhotoBrowser *)photoBrowser thumbnailImageForIndex:(NSInteger)index;
/// 实现本方法以返回点击视图的缩略图
- (UIView *)photoBrowser:(HHPhotoBrowser *)photoBrowser thumbnailViewForIndex:(NSInteger)index;

/// 实现本方法以返回高质量图片。可选
- (UIImage *)photoBrowser:(HHPhotoBrowser *)photoBrowser highQualityImageForIndex:(NSInteger)index;
/// 实现本方法以返回高质量图片的url。可选
- (NSURL *)photoBrowser:(HHPhotoBrowser *)photoBrowser highQualityUrlStringForIndex:(NSInteger)index;

@end

@interface HHPhotoBrowser : UIViewController
+ (HHPhotoBrowser *)ShowByViewController:(UIViewController *)presentedVC WithPhotoBrowserDelegate:(id<HHPhotoBrowserDelegate>)delegate WithPhotoIndex:(NSInteger)index;
@end
