//
//  SUploadProgressView.m
//  Wefafa
//
//  Created by Mr_J on 16/6/23.
//  Copyright © 2016年 metersbonwe. All rights reserved.
//

#import "JFLoadProgressView.h"
#import "UIView+JFFrame.h"

@interface JFLoadProgressView ()
{
    int _animationCount;
}

@property (nonatomic, strong) CAShapeLayer *edgeShapeLayer;
@property (nonatomic, strong) CAShapeLayer *progressShapeLayer;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign, readonly) CGFloat showRadius;

@end

@implementation JFLoadProgressView

+ (instancetype)showInView:(UIView *)view{
    JFLoadProgressView *progressView = [[JFLoadProgressView alloc]initWithFrame:view.bounds];
    [view addSubview:progressView];
    return progressView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.marginPercentage = 0.2;
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self.layer addSublayer:self.edgeShapeLayer];
    [self.layer addSublayer:self.progressShapeLayer];
}

#pragma mark - get set
- (CAShapeLayer *)edgeShapeLayer{
    if (!_edgeShapeLayer) {
        _edgeShapeLayer = [CAShapeLayer layer];
        _edgeShapeLayer.strokeColor = [UIColor clearColor].CGColor;
        _edgeShapeLayer.fillColor = self.maskColor.CGColor;
        _edgeShapeLayer.fillRule = @"even-odd";
        
        UIBezierPath *bezierPath = [self bezierWithRadius:self.showRadius progressValue:0];
        _edgeShapeLayer.path = bezierPath.CGPath;
    }
    return _edgeShapeLayer;
}

- (CAShapeLayer *)progressShapeLayer{
    if (!_progressShapeLayer) {
        _progressShapeLayer = [CAShapeLayer layer];
        _progressShapeLayer.strokeColor = [UIColor clearColor].CGColor;
        _progressShapeLayer.fillColor = self.maskColor.CGColor;
        
        UIBezierPath *bezierPath = [self progressBezierWithRadius:self.showRadius progressValue:0];
        _progressShapeLayer.path = bezierPath.CGPath;
    }
    return _progressShapeLayer;
}

- (CGFloat)showRadius{
    CGFloat showRadius = MIN(self.width, self.height)/ 2.0;
    return showRadius;
}

- (UIColor *)maskColor{
    if (!_maskColor) {
        _maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _maskColor;
}

- (void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
    UIBezierPath *bezierPath = [self progressBezierWithRadius:self.showRadius progressValue:progressValue];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressShapeLayer.path = bezierPath.CGPath;
    [CATransaction commit];
    if (progressValue >= 1) {
        [self showFinishAnimation];
    }
}

#pragma mark - option
- (void)reloadProgressState{
    UIBezierPath *bezierPath = [self bezierWithRadius:self.showRadius progressValue:0];
    self.edgeShapeLayer.path = bezierPath.CGPath;
}

- (void)showFinishAnimation{
    _animationCount = 0;
    if (self.displayLink) {
        return;
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(finishAnimation:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - create
- (UIBezierPath *)bezierWithRadius:(CGFloat)radius progressValue:(CGFloat)progressValue{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    CGFloat showRadius = (radius * (1 - self.marginPercentage)) + (self.width * progressValue);
    CGFloat move_X = self.width/ 2.0 + showRadius;
    
    [bezierPath moveToPoint:CGPointMake(move_X, self.height/ 2)];
    CGPoint centerPoint = CGPointMake(self.width/ 2.0, self.height/ 2.0);
    [bezierPath addArcWithCenter:centerPoint
                          radius:showRadius
                      startAngle:0
                        endAngle:M_PI * 2
                       clockwise:YES];
    return bezierPath;
}

- (UIBezierPath *)progressBezierWithRadius:(CGFloat)radius progressValue:(CGFloat)progressValue{
    if (progressValue >= 1) {
        return nil;
    }
    CGPoint centerPoint = CGPointMake(self.width/ 2.0, self.height/ 2.0);
    CGFloat startAngle = M_PI * 2.0 * progressValue;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:centerPoint];
    [bezierPath addArcWithCenter:centerPoint
                          radius:(radius * (1 - self.marginPercentage) - 2)
                      startAngle:startAngle
                        endAngle:M_PI * 2.0
                       clockwise:YES];
    return bezierPath;
}

#pragma mark - animation displaylink
- (void)finishAnimation:(CADisplayLink *)displayLink{
    if (_animationCount > 25) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.displayLink invalidate];
        self.displayLink = nil;
        return;
    }
    _animationCount ++;
    CGFloat progress = _animationCount/ 25.0;
    UIBezierPath *bezierPath = [self bezierWithRadius:self.showRadius progressValue:progress];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _edgeShapeLayer.path = bezierPath.CGPath;
    [CATransaction commit];
}

@end
