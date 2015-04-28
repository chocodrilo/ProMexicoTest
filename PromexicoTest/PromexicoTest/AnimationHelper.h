

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationHelper : NSObject



+(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait;

+(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;

+(void)fadeOutTransparent:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait;

+(void)fadeInTransparent:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;

+(void)fadeInTransparent:(UIView*)viewToFadeIn withAlpha:(CGFloat)alpha withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;

+(void)flashView:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration;

+(void)popIn:(UIView*)viewPopIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait andScaleFactor:(float)scaleFactor;

+(void)changeViewSize:(UIView*)viewPopIn withFrame:(CGRect)frame withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;

+(void)changeViewImage:(UIImageView*)imageView withImage:(UIImage *)img withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;

+(void)transitionView:(UIView *)view toRect:(CGRect)rect WithSpringWithDamping:(float)damping andVelocity:(float)velocity andTransitionTime:(float)transitionTime andWaitTime:(float)waitTime;

+(float) randFloatBetween:(float)low and:(float)high;


@end
