#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FeedAlignment) {
    FeedAlignmentJustified = 0,
    FeedAlignmentTopLeftAligned, // Top if scrollDirection is horizontal, Left if vertical
    FeedAlignmentBottomRightAligned, // Bottom if scrollDirection is horizontal, right if vertical
};

@interface FeedAlignmentFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) FeedAlignment alignment;

@end
