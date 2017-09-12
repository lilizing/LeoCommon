//
//  SYDRefreshHeader.m
//  CYZS
//
//  Created by 李理 on 2017/9/6.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

#import "SYDRefreshHeader.h"
//#import "CYZSGlobalInstance.h"
//#import "CYZSConfig.h"

@interface SYDRefreshHeader ()

//@property (weak, nonatomic) CYZSImageView *logo;
@property (weak, nonatomic) UIImageView *loading;

@end

@implementation SYDRefreshHeader

- (void)prepare {
    [super prepare];
    
//    // logo
//    CYZSImageView *logo = [[CYZSImageView alloc] initWithImage:[UIImage imageNamed:@"downRefresh"]];
//    [self addSubview:logo];
//    self.logo = logo;
    
    // loading
    UIImageView *loading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_hanger_gray"]];
    loading.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
//    UIImage *placeholderImage = [UIImage imageNamed:@"downRefresh"];
//    if (self.logo.image) {
//        placeholderImage = self.logo.image;
//    }
//    if (self.logoURL.length) {
//        [self.logo setWebImageWithURL:self.logoURL placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image && image.size.width > 0) {
//                CGFloat height = kWindowSize.width * image.size.height / image.size.width;
//                self.logo.frame = CGRectMake(0, LEORefreshHeaderHeight - height, kWindowSize.width, height);
//            }
//        }];
//    } else if ([CYZSGlobalInstance sharedInstance].refreshImageUrl.length > 0) {
//        [self.logo setWebImageWithURL:[CYZSGlobalInstance sharedInstance].refreshImageUrl placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image && image.size.width > 0) {
//                CGFloat height = kWindowSize.width * image.size.height / image.size.width;
//                self.logo.frame = CGRectMake(0, LEORefreshHeaderHeight - height, kWindowSize.width, height);
//            }
//        }];
//    } else {
//        self.logo.image = [UIImage imageNamed:@"downRefresh"];
//        CGFloat height = kWindowSize.width * self.logo.image.size.height / self.logo.image.size.width;
//        self.logo.frame = CGRectMake(0, LEORefreshHeaderHeight - height, kWindowSize.width, height);
//    }
    
    self.loading.center = CGPointMake(self.leo_w * 0.5, self.leo_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(LEORefreshState)state {
    LEORefreshCheckState;
    
    switch (state) {
        case LEORefreshStateIdle:
            [self stopAnimating];
            break;
        case LEORefreshStatePulling:
            [self stopAnimating];
            break;
        case LEORefreshStateRefreshing:
            [self startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}

#pragma mark 动画
- (void)startAnimating {
    self.loading.layer.zPosition = self.loading.frame.size.width * .5f;
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithDouble:M_PI * 2.0];
    rotationAnimation.duration = 1.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [self.loading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating {
    [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
