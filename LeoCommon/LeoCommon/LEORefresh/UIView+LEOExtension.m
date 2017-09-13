//  代码地址: https://github.com/CoderMJLee/LEORefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIView+Extension.m
//  LEORefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIView+LEOExtension.h"

@implementation UIView (LEOExtension)
- (void)setLeo_x:(CGFloat)leo_x
{
    CGRect frame = self.frame;
    frame.origin.x = leo_x;
    self.frame = frame;
}

- (CGFloat)leo_x
{
    return self.frame.origin.x;
}

- (void)setLeo_y:(CGFloat)leo_y
{
    CGRect frame = self.frame;
    frame.origin.y = leo_y;
    self.frame = frame;
}

- (CGFloat)leo_y
{
    return self.frame.origin.y;
}

- (void)setLeo_w:(CGFloat)leo_w
{
    CGRect frame = self.frame;
    frame.size.width = leo_w;
    self.frame = frame;
}

- (CGFloat)leo_w
{
    return self.frame.size.width;
}

- (void)setLeo_h:(CGFloat)leo_h
{
    CGRect frame = self.frame;
    frame.size.height = leo_h;
    self.frame = frame;
}

- (CGFloat)leo_h
{
    return self.frame.size.height;
}

- (void)setLeo_size:(CGSize)leo_size
{
    CGRect frame = self.frame;
    frame.size = leo_size;
    self.frame = frame;
}

- (CGSize)leo_size
{
    return self.frame.size;
}

- (void)setLeo_origin:(CGPoint)leo_origin
{
    CGRect frame = self.frame;
    frame.origin = leo_origin;
    self.frame = frame;
}

- (CGPoint)leo_origin
{
    return self.frame.origin;
}
@end
