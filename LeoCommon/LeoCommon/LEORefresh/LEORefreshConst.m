//  代码地址: https://github.com/CoderMJLee/LEORefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat LEORefreshLabelLeftInset = 25;
const CGFloat LEORefreshHeaderHeight = 96.0;
const CGFloat LEORefreshFooterHeight = 44.0;
const CGFloat LEORefreshFastAnimationDuration = 0.25;
const CGFloat LEORefreshSlowAnimationDuration = 0.4;

NSString *const LEORefreshKeyPathContentOffset = @"contentOffset";
NSString *const LEORefreshKeyPathContentInset = @"contentInset";
NSString *const LEORefreshKeyPathContentSize = @"contentSize";
NSString *const LEORefreshKeyPathPanState = @"state";

NSString *const LEORefreshHeaderLastUpdatedTimeKey = @"LEORefreshHeaderLastUpdatedTimeKey";

NSString *const LEORefreshHeaderIdleText = @"LEORefreshHeaderIdleText";
NSString *const LEORefreshHeaderPullingText = @"LEORefreshHeaderPullingText";
NSString *const LEORefreshHeaderRefreshingText = @"LEORefreshHeaderRefreshingText";

NSString *const LEORefreshAutoFooterIdleText = @"LEORefreshAutoFooterIdleText";
NSString *const LEORefreshAutoFooterRefreshingText = @"LEORefreshAutoFooterRefreshingText";
NSString *const LEORefreshAutoFooterNoMoreDataText = @"LEORefreshAutoFooterNoMoreDataText";

NSString *const LEORefreshBackFooterIdleText = @"LEORefreshBackFooterIdleText";
NSString *const LEORefreshBackFooterPullingText = @"LEORefreshBackFooterPullingText";
NSString *const LEORefreshBackFooterRefreshingText = @"LEORefreshBackFooterRefreshingText";
NSString *const LEORefreshBackFooterNoMoreDataText = @"LEORefreshBackFooterNoMoreDataText";

NSString *const LEORefreshHeaderLastTimeText = @"LEORefreshHeaderLastTimeText";
NSString *const LEORefreshHeaderDateTodayText = @"LEORefreshHeaderDateTodayText";
NSString *const LEORefreshHeaderNoneLastDateText = @"LEORefreshHeaderNoneLastDateText";
