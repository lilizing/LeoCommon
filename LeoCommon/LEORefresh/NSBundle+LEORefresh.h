//
//  NSBundle+LEORefresh.h
//  LEORefreshExample
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (LEORefresh)
+ (instancetype)leo_refreshBundle;
+ (UIImage *)leo_arrowImage;
+ (NSString *)leo_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)leo_localizedStringForKey:(NSString *)key;
@end
