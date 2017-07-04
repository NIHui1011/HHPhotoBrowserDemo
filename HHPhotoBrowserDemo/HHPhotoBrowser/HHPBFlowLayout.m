//
//  HHPBFlowLayout.m
//  HHPhotoBrowserDemo
//
//  Created by 倪辉辉 on 2017/5/11.
//  Copyright © 2017年 倪辉辉. All rights reserved.
//

#import "HHPBFlowLayout.h"

@interface HHPBFlowLayout()
@property(nonatomic,assign)CGFloat pageWidth;
//@property(nonatomic,assign)CGFloat lastPage;
@property(nonatomic,assign)CGFloat minPage;
@property(nonatomic,assign)CGFloat maxPage;



@end

@implementation HHPBFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastPage = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

// 当bounds发生改变的时候需要重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

/// 一页宽度，算上空隙
- (CGFloat)pageWidth{
    return self.itemSize.width + self.minimumLineSpacing;
}

/// 上次页码
- (CGFloat)lastPage{
    CGFloat offsetX;
    offsetX = self.collectionView.contentOffset.x;
    if (!offsetX) {
        return 0;
    }
    return round(offsetX / self.pageWidth);
}

/// 最小页码 minPage=0

/// 最大页码
- (CGFloat)maxPage{
    CGFloat contentWidth = self.collectionView.contentSize.width;
    if (!contentWidth) {
        return 0;
    }
    contentWidth += self.minimumLineSpacing;
    return contentWidth / self.pageWidth - 1;
}


/// 调整scroll停下来的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat page = round(proposedContentOffset.x/self.pageWidth);
    
    // 处理轻微滑动
    if (velocity.x > 0.2) {
        page += 1;
    }else if (velocity.x < -0.2){
        page -= 1;
    }
    
     // 一次滑动不允许超过一页
    if (page >self.lastPage + 1) {
        page =  self.lastPage + 1;
    }else if (page < self.lastPage - 1 ){
        page = self.lastPage - 1;
    }
    if (page > self.maxPage) {
        page = self.maxPage;
    } else if( page < self.minPage ){
        page = self.minPage;
    }
    
    _lastPage = page;
    NSLog(@"页码%f",page);
    return CGPointMake(page*self.pageWidth, 0);

}

- (CGFloat)flickVelocity {
    return .5;
}



@end
