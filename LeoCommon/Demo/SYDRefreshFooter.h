//
//  SYDRefreshFooter.h
//  CYZS
//
//  Created by 李理 on 2017/9/8.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

#import "LEORefreshAutoFooter.h"

@interface SYDRefreshFooter : LEORefreshAutoFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (nonatomic, strong, readonly) UILabel *stateLabel;

/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(LEORefreshState)state;

/** 隐藏刷新状态的文字 */
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end
