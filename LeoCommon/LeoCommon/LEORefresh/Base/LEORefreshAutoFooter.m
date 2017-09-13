//
//  LEORefreshAutoFooter.m
//  LEORefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "LEORefreshAutoFooter.h"

@interface LEORefreshAutoFooter()
@end

@implementation LEORefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.leo_insetB += self.leo_h;
        }
        
        // 设置位置
        self.leo_y = _scrollView.leo_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.leo_insetB -= self.leo_h;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.leo_y = self.scrollView.leo_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != LEORefreshStateIdle || !self.automaticallyRefresh || self.leo_y == 0) return;
    
    if (_scrollView.leo_insetT + _scrollView.leo_contentH > _scrollView.leo_h) { // 内容超过一个屏幕
        // 这里的_scrollView.leo_contentH替换掉self.leo_y更为合理
        if (_scrollView.leo_offsetY >= _scrollView.leo_contentH - _scrollView.leo_h + self.leo_h * self.triggerAutomaticallyRefreshPercent + _scrollView.leo_insetB - self.leo_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != LEORefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.leo_insetT + _scrollView.leo_contentH <= _scrollView.leo_h) {  // 不够一个屏幕
            if (_scrollView.leo_offsetY >= - _scrollView.leo_insetT) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.leo_offsetY >= _scrollView.leo_contentH + _scrollView.leo_insetB - _scrollView.leo_h) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(LEORefreshState)state
{
    LEORefreshCheckState
    
    if (state == LEORefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    } else if (state == LEORefreshStateNoMoreData || state == LEORefreshStateIdle) {
        if (LEORefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = LEORefreshStateIdle;
        
        self.scrollView.leo_insetB -= self.leo_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.leo_insetB += self.leo_h;
        
        // 设置位置
        self.leo_y = _scrollView.leo_contentH;
    }
}
@end
