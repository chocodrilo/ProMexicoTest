

#import "AnimationHelper.h"

@implementation AnimationHelper

#pragma mark
#pragma mark  Public Methods

+(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

+(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

+(void)fadeOutTransparent:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

+(void)fadeInTransparent:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = .7;
    [UIView commitAnimations];
}

+(void)fadeInTransparent:(UIView*)viewToFadeIn withAlpha:(CGFloat)alpha withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = alpha;
    [UIView commitAnimations];
}

+(void)flashView:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration
{
    [AnimationHelper fadeOut:viewToFadeIn withDuration:duration andWait:0.0];
    [AnimationHelper fadeIn:viewToFadeIn withDuration:duration andWait:duration];
}


+(void)popIn:(UIView*)viewPopIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait andScaleFactor:(float)scaleFactor
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewPopIn.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    [UIView commitAnimations];
}

+(void)changeViewSize:(UIView*)viewPopIn withFrame:(CGRect)frame withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView
     animateWithDuration:duration
     delay:wait
     options:UIViewAnimationCurveEaseIn
     animations:^{
         [viewPopIn setFrame:frame];
     }
     completion:^(BOOL completed) {}
     ];
}

+(void)changeViewImage:(UIImageView*)imageView withImage:(UIImage *)img withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait;
{
    [UIView beginAnimations: @"Change Image" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    [imageView setImage:img];
    [UIView commitAnimations];

}

+(void)transitionView:(UIView *)view toRect:(CGRect)rect WithSpringWithDamping:(float)damping andVelocity:(float)velocity andTransitionTime:(float)transitionTime andWaitTime:(float)waitTime
{
    [UIView animateWithDuration:transitionTime delay:waitTime usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
        view.frame = rect;
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

+(float) randFloatBetween:(float)low and:(float)high
{
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}



@end
