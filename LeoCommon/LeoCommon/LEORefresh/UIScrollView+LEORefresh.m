//  代码地址: https://github.com/CoderMJLee/LEORefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+LEORefresh.m
//  LEORefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+LEORefresh.h"
#import "LEORefreshHeader.h"
#import "LEORefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (LEORefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (LEORefresh)

#pragma mark - header
static const char LEORefreshHeaderKey = '\0';
- (void)setLeo_header:(LEORefreshHeader *)leo_header
{
    if (leo_header != self.leo_header) {
        // 删除旧的，添加新的
        [self.leo_header removeFromSuperview];
        [self insertSubview:leo_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"leo_header"]; // KVO
        objc_setAssociatedObject(self, &LEORefreshHeaderKey,
                                 leo_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"leo_header"]; // KVO
    }
}

- (LEORefreshHeader *)leo_header
{
    return objc_getAssociatedObject(self, &LEORefreshHeaderKey);
}

#pragma mark - footer
static const char LEORefreshFooterKey = '\0';
- (void)setLeo_footer:(LEORefreshFooter *)leo_footer
{
    if (leo_footer != self.leo_footer) {
        // 删除旧的，添加新的
        [self.leo_footer removeFromSuperview];
        [self insertSubview:leo_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"leo_footer"]; // KVO
        objc_setAssociatedObject(self, &LEORefreshFooterKey,
                                 leo_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"leo_footer"]; // KVO
    }
}

- (LEORefreshFooter *)leo_footer
{
    return objc_getAssociatedObject(self, &LEORefreshFooterKey);
}

#pragma mark - 过期
//- (void)setFooter:(LEORefreshFooter *)footer
//{
//    self.leo_footer = footer;
//}
//
//- (LEORefreshFooter *)footer
//{
//    return self.leo_footer;
//}
//
//- (void)setHeader:(LEORefreshHeader *)header
//{
//    self.leo_header = header;
//}
//
//- (LEORefreshHeader *)header
//{
//    return self.leo_header;
//}

#pragma mark - other
- (NSInteger)leo_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char LEORefreshReloadDataBlockKey = '\0';
- (void)setLeo_reloadDataBlock:(void (^)(NSInteger))leo_reloadDataBlock
{
    [self willChangeValueForKey:@"leo_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &LEORefreshReloadDataBlockKey, leo_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"leo_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))leo_reloadDataBlock
{
    return objc_getAssociatedObject(self, &LEORefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.leo_reloadDataBlock ? : self.leo_reloadDataBlock(self.leo_totalDataCount);
}
@end

@implementation UITableView (LEORefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(leo_reloadData)];
}

- (void)leo_reloadData
{
    [self leo_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (LEORefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(leo_reloadData)];
}

- (void)leo_reloadData
{
    [self leo_reloadData];
    
    [self executeReloadDataBlock];
}
@end
