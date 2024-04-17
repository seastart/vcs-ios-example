//
//  FWSpeedTestRippleView.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestRippleView.h"

static NSInteger const FWSpeedTestPulsingCount = 3;
static double const FWSpeedTestAnimationDuration = 3;

@interface FWSpeedTestRippleView ()

/// 扩散倍数
@property (nonatomic, assign) CGFloat multiple;

@end

@implementation FWSpeedTestRippleView

#pragma mark - 初始化方法
/// 初始化方法
/// @param frame 布局
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        /// 配置UI属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - Xib加载初始化
/// Xib加载初始化
- (void)awakeFromNib {
    
    [super awakeFromNib];
    /// 配置UI属性
    [self stepConfig];
}

#pragma mark - 配置属性
/// 配置UI属性
- (void)stepConfig {
    
    /// 设置背景颜色
    self.backgroundColor = [UIColor clearColor];
    /// 扩散倍数
    self.multiple = 1.423;
}

- (void)drawRect:(CGRect)rect {
    
    CALayer *animationLayer = [CALayer layer];
    
    for (int i = 0; i < FWSpeedTestPulsingCount; i++) {
        
        NSArray *animationArray = [self animationArray];
        CAAnimationGroup *animationGroup = [self animationGroupAnimations:animationArray index:i];
        CALayer *pulsingLayer = [self pulsingLayer:rect animation:animationGroup];
        [animationLayer addSublayer:pulsingLayer];
    }
    
    [self.layer addSublayer:animationLayer];
}

- (NSArray *)animationArray {
    
    NSArray *animationArray = nil;
    
    CABasicAnimation *scaleAnimation = [self scaleAnimation];
    CAKeyframeAnimation *borderColorAnimation = [self borderColorAnimation];
    CAKeyframeAnimation *backgroundColorAnimation = [self backgroundColorAnimation];
    animationArray = @[scaleAnimation, backgroundColorAnimation, borderColorAnimation];
    
    return animationArray;
}

- (CAAnimationGroup *)animationGroupAnimations:(NSArray *)array index:(int)index {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime() + (double)(index * FWSpeedTestAnimationDuration) / (double)FWSpeedTestPulsingCount;
    animationGroup.duration = FWSpeedTestAnimationDuration;
    animationGroup.repeatCount = HUGE;
    animationGroup.timingFunction = defaultCurve;
    animationGroup.animations = array;
    animationGroup.removedOnCompletion = NO;
    return animationGroup;
}

- (CALayer *)pulsingLayer:(CGRect)rect animation:(CAAnimationGroup *)animationGroup {
    
    CALayer *pulsingLayer = [CALayer layer];
    
    pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    pulsingLayer.backgroundColor = RGBA(255, 216, 87, 0.5).CGColor;
    pulsingLayer.borderWidth = 0.5;
    
    pulsingLayer.borderColor = RGBA(255, 216, 87, 0.5).CGColor;
    pulsingLayer.cornerRadius = rect.size.height / 2;
    [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
    return pulsingLayer;
}

- (CABasicAnimation *)scaleAnimation {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @(_multiple);
    return scaleAnimation;
}

- (CAKeyframeAnimation *)backgroundColorAnimation {
    
    CAKeyframeAnimation *backgroundColorAnimation = [CAKeyframeAnimation animation];
    
    backgroundColorAnimation.keyPath = @"backgroundColor";
    backgroundColorAnimation.values = @[(__bridge id)RGBA(255, 216, 87, 0.5).CGColor,
                                        (__bridge id)RGBA(255, 231, 152, 0.5).CGColor,
                                        (__bridge id)RGBA(255, 241, 197, 0.5).CGColor,
                                        (__bridge id)RGBA(255, 241, 197, 0).CGColor];
    backgroundColorAnimation.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return backgroundColorAnimation;
}

- (CAKeyframeAnimation *)borderColorAnimation {
    
    CAKeyframeAnimation *borderColorAnimation = [CAKeyframeAnimation animation];
    
    borderColorAnimation.keyPath = @"borderColor";
    borderColorAnimation.values = @[(__bridge id)RGBA(255, 216, 87, 0.5).CGColor,
                                    (__bridge id)RGBA(255, 231, 152, 0.5).CGColor,
                                    (__bridge id)RGBA(255, 241, 197, 0.5).CGColor,
                                    (__bridge id)RGBA(255, 241, 197, 0).CGColor];
    borderColorAnimation.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return borderColorAnimation;
}

- (CAKeyframeAnimation *)blackBorderColorAnimation {
    
    CAKeyframeAnimation *borderColorAnimation = [CAKeyframeAnimation animation];
    
    borderColorAnimation.keyPath = @"borderColor";
    borderColorAnimation.values = @[(__bridge id)RGBA(0, 0, 0, 0.4).CGColor,
                                    (__bridge id)RGBA(0, 0, 0, 0.4).CGColor,
                                    (__bridge id)RGBA(0, 0, 0, 0.1).CGColor,
                                    (__bridge id)RGBA(0, 0, 0, 0).CGColor];
    borderColorAnimation.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return borderColorAnimation;
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
