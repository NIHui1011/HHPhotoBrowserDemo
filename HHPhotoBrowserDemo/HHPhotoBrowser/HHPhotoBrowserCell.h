//
//  HHPhotoBrowserCell.h
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/11.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPhotoBrowserProgressView.h"
@class HHPhotoBrowserCell;
@protocol HHPhotoBrowserCellDelegate <NSObject>
- (void)HHPhotoBrowserCellDidSingleTap:(HHPhotoBrowserCell *)cell;
/// 拖动时回调。scale:缩放比率
- (void)HHPhotoBrowser:(HHPhotoBrowserCell *)cell didPanScale:(CGFloat)scale;


@end

@interface HHPhotoBrowserCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGSize fitSize;
@property(nonatomic,assign)CGRect fitFrame;
@property(nonatomic,strong)HHPhotoBrowserProgressView *progressView;
- (void)setImageWithImage:(UIImage *)image WithUrl:(NSURL *)url;
@property (nonatomic,weak)id<HHPhotoBrowserCellDelegate> delegate;
@end
