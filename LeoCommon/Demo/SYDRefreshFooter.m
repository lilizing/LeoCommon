//
//  SYDRefreshFooter.m
//  CYZS
//
//  Created by 李理 on 2017/9/8.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

#import "SYDRefreshFooter.h"

@interface SYDRefreshFooter()

@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation SYDRefreshFooter

#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
//        label.textColor = kCYZS_COLOR_CCCCCC;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        
        _stateLabel = label;
        
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(LEORefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == LEORefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    [self setTitle:[NSBundle leo_localizedStringForKey:LEORefreshAutoFooterIdleText] forState:LEORefreshStateIdle];
    [self setTitle:[NSBundle leo_localizedStringForKey:LEORefreshAutoFooterRefreshingText] forState:LEORefreshStateRefreshing];
    [self setTitle:[NSBundle leo_localizedStringForKey:LEORefreshAutoFooterNoMoreDataText] forState:LEORefreshStateNoMoreData];
    
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    self.stateLabel.frame = self.bounds;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != LEORefreshStateIdle || !self.automaticallyRefresh || self.leo_y == 0) return;
    
    if (_scrollView.leo_insetT + _scrollView.leo_contentH > _scrollView.leo_h) { // 内容超过一个屏幕
        if (_scrollView.leo_offsetY >= _scrollView.leo_contentH - _scrollView.leo_h - 100) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            [self beginRefreshing];
        }
    }
}

- (void)setState:(LEORefreshState)state
{
    LEORefreshCheckState
    
    if (state == LEORefreshStateNoMoreData) {
        if (LEORefreshStateRefreshing == oldState) {
//            self.stateLabel.textColor = kCYZS_COLOR_CCCCCC;
            [UIView animateWithDuration:LEORefreshSlowAnimationDuration animations:^{
                self.scrollView.leo_insetB = 0;
            }];
        }
        self.stateLabel.text = self.stateTitles[@(state)];
    } else if (self.isRefreshingTitleHidden && state == LEORefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.textColor = [UIColor darkGrayColor];
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}

- (void)beginRefreshing {
    self.scrollView.leo_insetB = 44;
    [super beginRefreshing];
}

- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = LEORefreshStateIdle;
    });
}

- (void)endRefreshingWithNoMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = LEORefreshStateNoMoreData;
    });
}
@end
