//
//  TNSexyImageUploadProgress.m
//  TNSexyImageUploadProgressDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNSexyImageUploadProgress.h"

NSString * const IMAGE_UPLOAD_COMPLETED = @"imageUploadCompleted";

@interface TNSexyImageUploadProgress()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) CAShapeLayer *overlayLayer;
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, strong) CABasicAnimation *fadeInOverlay;
@property (nonatomic, strong) CABasicAnimation *fadeOutOverlay;

@property (nonatomic, strong) CABasicAnimation *growTrackAnimation;
@property (nonatomic, strong) CABasicAnimation *fadeInTrackAnimation;

@property (nonatomic, strong) CABasicAnimation *growImageMaskAnimation;

@property (nonatomic, strong) CABasicAnimation *shrinkImageMaskAnimation;
@property (nonatomic, strong) CABasicAnimation *reverseProgressAnimation;
@property (nonatomic, strong) CABasicAnimation *shrinkTrackAnimation;
@property (nonatomic, strong) CABasicAnimation *fadeOutAnimation;


@end

@implementation TNSexyImageUploadProgress

@synthesize progressBorderThickness = _progressBorderThickness;
@synthesize radius = _radius;

- (id)init {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        // Initialization code
        self.showOverlay = YES;
        
    }
    
    return self;
}

- (void)show {
    
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
    }
    
    if(!self.superview) {
        [self addSubview:self];
    }
    
    if( self.showOverlay ){
        [self createOverlay];
    }
    
    [self introAnimation];
}

#pragma mark - Create

- (void)createOverlay {
    
    self.overlayLayer = [CAShapeLayer layer];
    self.overlayLayer.path = [UIBezierPath bezierPathWithRect:self.frame].CGPath;
    self.overlayLayer.fillColor = [UIColor colorWithRed:33/255.0f green:33/255.0f blue:33/255.0f alpha:0.3].CGColor;
    [self.layer insertSublayer:self.overlayLayer atIndex:0];
    
}

- (void)createImageViewMask {
    
    double diameter = self.radius * 2;
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-diameter / 2, -diameter / 2, diameter, diameter)].CGPath;
    self.maskLayer.position = CGPointMake( self.imageView.frame.size.width / 2, self.imageView.frame.size.height / 2);
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.maskLayer.fillColor = [UIColor purpleColor].CGColor;
    self.maskLayer.transform = CATransform3DMakeScale(0, 0, 0);
    self.imageView.layer.mask = self.maskLayer;
    
    self.imageView.layer.masksToBounds = YES;
}

- (void)createProgressTrackCircle {
    
    double diameter = (self.radius * 2) + self.progressBorderThickness;
    
    self.trackLayer = [CAShapeLayer layer];
    self.trackLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-diameter / 2, -diameter / 2, diameter, diameter)].CGPath;
    self.trackLayer.position = CGPointMake( self.frame.size.width / 2 , self.frame.size.height / 2);
    self.trackLayer.fillColor = self.trackColor.CGColor;
    self.trackLayer.opacity = 0;
    self.trackLayer.transform = CATransform3DMakeScale(0, 0, 0);
    [self.layer insertSublayer:self.trackLayer atIndex:0];
}

- (void)createProgressProgressCircle {
    
    double diameter = (self.radius * 2) + self.progressBorderThickness;
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-diameter / 2, -diameter / 2, diameter, diameter)].CGPath;
    self.progressLayer.position = CGPointMake( self.frame.size.width / 2 , self.frame.size.height / 2);
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = self.progressColor.CGColor;
    
    self.progressLayer.lineWidth = self.progressBorderThickness;
    
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    
    [self.layer addSublayer:self.progressLayer];
}

#pragma mark - Animations
- (void)introAnimation {
    
    [self.overlayLayer addAnimation:self.fadeInOverlay forKey:@"fadeInOverlay"];
    self.overlayLayer.opacity = 1;
    
    // Scale/fade in background circle
    CAAnimationGroup *introTrackAnimation = [CAAnimationGroup animation];
    introTrackAnimation.animations = @[self.growTrackAnimation, self.fadeInTrackAnimation];
    
    [self.trackLayer addAnimation:introTrackAnimation forKey:@"growTrack"];

    self.trackLayer.opacity = 1;
    self.trackLayer.transform = CATransform3DMakeScale(1, 1, 0);
    
    // Scale image mask
    self.maskLayer.transform = CATransform3DMakeScale(1, 1, 0);
    [self.maskLayer addAnimation:self.growImageMaskAnimation forKey:@"growMask"];
}

- (void)outroAnimation {
    // Scale image mask
    [self.maskLayer addAnimation:self.shrinkImageMaskAnimation forKey:@"shrinkMask"];
    self.maskLayer.transform = CATransform3DMakeScale(0, 0, 0);
    
    // Reverse the progress
    [self.progressLayer addAnimation:self.reverseProgressAnimation forKey:@"reverseProgress"];
    self.progressLayer.strokeEnd = 0.0f;
    
    // Shrink track
    [self.trackLayer addAnimation:self.shrinkTrackAnimation forKey:@"shrinkTrack"];
    self.trackLayer.transform = CATransform3DMakeScale(0, 0, 0);
    
    // Fade out
    [self.trackLayer addAnimation:self.fadeOutAnimation forKey:@"fadeOutTrack"];
    self.trackLayer.opacity = 0;
    
    [self.overlayLayer addAnimation:self.fadeOutAnimation forKey:@"fadeOutOverlay"];
    self.overlayLayer.opacity = 0;
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
        
    if( flag == YES){
        [self outroAnimationCompleted];
    }

}

- (void)outroAnimationCompleted {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_UPLOAD_COMPLETED object:self];
    
    [self removeFromSuperview];
}

- (void)animateProgress {
    
    [CATransaction setDisableActions:YES];
    
    self.progressLayer.strokeEnd = self.progress;
}

#pragma mark - Getters / Setters
- (UIImageView *)imageView {
    
    if( !_imageView ){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.radius * 2, self.radius * 2)];
        _imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = _radius;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderWidth = 0;

        [self addSubview:_imageView];
        
        [self createImageViewMask];
        [self createProgressTrackCircle];
        [self createProgressProgressCircle];
    }
    
    return _imageView;
    
}

- (void)setImageToUpload:(UIImage *)imageToUpload {
    
    if( _imageToUpload != imageToUpload ){
        _imageToUpload = imageToUpload;
        
        self.imageView.image = _imageToUpload;
    }
    
}

- (void)setProgress:(float)progress {
    
    if( _progress != progress ){
        _progress = progress;
    
        [self animateProgress];
    
        if( _progress >= 1.0f ){
            [self outroAnimation];
        }
    }
}

- (void)setRadius:(NSUInteger)radius {
    
    if( radius > self.frame.size.width ){
        radius = 50;
    }
    
    _radius = radius;
    
}

- (NSUInteger)radius {
    
    if( !_radius ){
        _radius = 50;
    }
    
    return _radius;
}

- (void)setProgressBorderThickness:(NSUInteger)progressBorderThickness {
    
    if( progressBorderThickness > 1000 ){
        progressBorderThickness = 10;
    }
    
    _progressBorderThickness = progressBorderThickness;
    
}

- (NSUInteger)progressBorderThickness {
    
    if( !_progressBorderThickness ){
        _progressBorderThickness = 10;
    }
    
    return _progressBorderThickness;
}

- (UIColor *)trackColor {
    
    if ( !_trackColor ){
        _trackColor = [UIColor whiteColor];
    }
    
    return _trackColor;
}

- (UIColor *)progressColor {
    
    if ( !_progressColor ){
        _progressColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    }
    
    return _progressColor;
}

- (CABasicAnimation *)fadeInOverlay {
    
    if ( !_fadeInOverlay ){
        _fadeInOverlay = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _fadeInOverlay.fromValue = [NSNumber numberWithDouble:0.0];
        _fadeInOverlay.toValue = [NSNumber numberWithDouble:1.0];
        _fadeInOverlay.duration = 0.2f;
        _fadeInOverlay.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    return _fadeInOverlay;
}

- (CABasicAnimation *)growTrackAnimation {
    
    if ( !_growTrackAnimation ){
        _growTrackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _growTrackAnimation.fromValue = [NSNumber numberWithDouble:0.0];
        _growTrackAnimation.toValue = [NSNumber numberWithDouble:1.0];
        _growTrackAnimation.duration = 0.2f;
        _growTrackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    return _growTrackAnimation;
}

- (CABasicAnimation *)fadeInTrackAnimation {
    
    if ( !_fadeInTrackAnimation ){
        _fadeInTrackAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _fadeInTrackAnimation.fromValue = [NSNumber numberWithDouble:0.0];
        _fadeInTrackAnimation.toValue = [NSNumber numberWithDouble:1.0];
        _fadeInTrackAnimation.duration = 0.2f;
        _fadeInTrackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    return _fadeInTrackAnimation;
}

- (CABasicAnimation *)growImageMaskAnimation {
    
    if ( !_growImageMaskAnimation ){
        _growImageMaskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _growImageMaskAnimation.fromValue = [NSNumber numberWithDouble:0.0];
        _growImageMaskAnimation.toValue = [NSNumber numberWithDouble:1.0];
        _growImageMaskAnimation.duration = 0.3f;
        _growImageMaskAnimation.beginTime = CACurrentMediaTime() + 0.2f;
        _growImageMaskAnimation.fillMode = kCAFillModeBackwards;
        _growImageMaskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    
    return _growImageMaskAnimation;
}

- (CABasicAnimation *)shrinkImageMaskAnimation {
    
    if ( !_shrinkImageMaskAnimation ){
        _shrinkImageMaskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _shrinkImageMaskAnimation.fromValue = [NSNumber numberWithDouble:1.0];
        _shrinkImageMaskAnimation.toValue = [NSNumber numberWithDouble:0.0];
        _shrinkImageMaskAnimation.duration = 0.2f;
        _shrinkImageMaskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    
    return _shrinkImageMaskAnimation;
}

- (CABasicAnimation *)reverseProgressAnimation {
    
    if ( !_reverseProgressAnimation ){
        _reverseProgressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _reverseProgressAnimation.fromValue = [NSNumber numberWithDouble:1.0];
        _reverseProgressAnimation.toValue = [NSNumber numberWithDouble:0.0];
        _reverseProgressAnimation.duration = 0.4f;
        _reverseProgressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    return _reverseProgressAnimation;
}

- (CABasicAnimation *)shrinkTrackAnimation {
    
    if ( !_shrinkTrackAnimation ){
        _shrinkTrackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _shrinkTrackAnimation.fromValue = [NSNumber numberWithDouble:1.0];
        _shrinkTrackAnimation.toValue = [NSNumber numberWithDouble:0.0];
        _shrinkTrackAnimation.duration = 0.2f;
        _shrinkTrackAnimation.beginTime = CACurrentMediaTime() + 0.25f;
        _shrinkTrackAnimation.fillMode = kCAFillModeBackwards;
        _shrinkTrackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _shrinkTrackAnimation.delegate = self;
    }
    
    return _shrinkTrackAnimation;
}

- (CABasicAnimation *)fadeOutAnimation {
    
    if ( !_fadeOutAnimation ){
        _fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _fadeOutAnimation.fromValue = [NSNumber numberWithDouble:1.0];
        _fadeOutAnimation.toValue = [NSNumber numberWithDouble:0.0];
        _fadeOutAnimation.duration = 0.2f;
        _fadeOutAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    return _fadeOutAnimation;
}

- (void)dealloc {
    
}

@end
