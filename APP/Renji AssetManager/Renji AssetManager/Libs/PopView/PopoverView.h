#import <UIKit/UIKit.h>


@protocol PopoverViewDelegate <NSObject>

- (void)viewDismiss;

@end
@interface PopoverView : UIView

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);
@property (nonatomic, weak) id<PopoverViewDelegate>delegate;
@end
