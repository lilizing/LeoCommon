//  代码地址: https://github.com/CoderMJLee/LEORefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define LEORefreshLog(...) NSLog(__VA_ARGS__)
#else
#define LEORefreshLog(...)
#endif

// 过期提醒
#define LEORefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define LEORefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define LEORefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define LEORefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define LEORefreshLabelTextColor LEORefreshColor(90, 90, 90)

// 字体大小
#define LEORefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
UIKIT_EXTERN const CGFloat LEORefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat LEORefreshHeaderHeight;
UIKIT_EXTERN const CGFloat LEORefreshFooterHeight;
UIKIT_EXTERN const CGFloat LEORefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat LEORefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const LEORefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const LEORefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const LEORefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const LEORefreshKeyPathPanState;

UIKIT_EXTERN NSString *const LEORefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const LEORefreshHeaderIdleText;
UIKIT_EXTERN NSString *const LEORefreshHeaderPullingText;
UIKIT_EXTERN NSString *const LEORefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const LEORefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const LEORefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const LEORefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const LEORefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const LEORefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const LEORefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const LEORefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const LEORefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const LEORefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const LEORefreshHeaderNoneLastDateText;

// 状态检查
#define LEORefreshCheckState \
LEORefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
