//  代码地址: https://github.com/CoderMJLee/LEORefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+Extension.m
//  LEORefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIScrollView+LEOExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (LEOExtension)

- (void)setLeo_insetT:(CGFloat)leo_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = leo_insetT;
    self.contentInset = inset;
}

- (CGFloat)leo_insetT
{
    return self.contentInset.top;
}

- (void)setLeo_insetB:(CGFloat)leo_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = leo_insetB;
    self.contentInset = inset;
}

- (CGFloat)leo_insetB
{
    return self.contentInset.bottom;
}

- (void)setLeo_insetL:(CGFloat)leo_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = leo_insetL;
    self.contentInset = inset;
}

- (CGFloat)leo_insetL
{
    return self.contentInset.left;
}

- (void)setLeo_insetR:(CGFloat)leo_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = leo_insetR;
    self.contentInset = inset;
}

- (CGFloat)leo_insetR
{
    return self.contentInset.right;
}

- (void)setLeo_offsetX:(CGFloat)leo_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = leo_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)leo_offsetX
{
    return self.contentOffset.x;
}

- (void)setLeo_offsetY:(CGFloat)leo_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = leo_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)leo_offsetY
{
    return self.contentOffset.y;
}

- (void)setLeo_contentW:(CGFloat)leo_contentW
{
    CGSize size = self.contentSize;
    size.width = leo_contentW;
    self.contentSize = size;
}

- (CGFloat)leo_contentW
{
    return self.contentSize.width;
}

- (void)setLeo_contentH:(CGFloat)leo_contentH
{
    CGSize size = self.contentSize;
    size.height = leo_contentH;
    self.contentSize = size;
}

- (CGFloat)leo_contentH
{
    return self.contentSize.height;
}
@end
