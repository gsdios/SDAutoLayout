//
//  MemoryIndicator.m
//  QQLeakDemo
//
//  Tencent is pleased to support the open source community by making OOMDetector available.
//  Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
//  Licensed under the MIT License (the "License"); you may not use this file except
//  in compliance with the License. You may obtain a copy of the License at
//
//  http://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//
//

#import "MemoryIndicator.h"
#import "OOMDetector.h"

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

@interface MemoryIndicator()
@property (nonatomic, strong) CAShapeLayer *waveLayer;
@end

@implementation MemoryIndicator
{
    NSTimer *_timer;
    double _threshold;
    BOOL _isShowing;
    NSTimer *_waveTimer;
}

+ (instancetype)indicator
{
    MemoryIndicator *indicator = [MemoryIndicator new];
    indicator.frame = CGRectMake(0, 0, 80, 80);
    return indicator;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)show:(BOOL)yn
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (yn) {
        self.center = CGPointMake(keyWindow.bounds.size.width * 0.5, keyWindow.bounds.size.height - self.frame.size.height * 0.5 - 30);
        [keyWindow addSubview:self];
    } else {
        [self removeFromSuperview];
    }
    _isShowing = yn;
}

- (void)setMemory:(CGFloat)memory
{
    _memory = memory;
    
    if (!_isShowing) {
        return;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.label.text = [NSString stringWithFormat:@"%.2fMb", memory];
        CGFloat ratio = memory / _threshold;
        if (ratio < 0.3) {
            ratio = 0;
        }
        self.layer.borderColor = [[UIColor colorWithRed:ratio  green:MAX((1 - ratio), 0) blue:0 alpha:1] colorWithAlphaComponent:0.7].CGColor;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
    
    self.waveLayer.frame = self.bounds;
}

- (void)setup
{
    _threshold = 200;
    
    self.waveLayer = [CAShapeLayer new];
    self.waveLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6].CGColor;
    self.waveLayer.fillColor = [UIColor whiteColor].CGColor;
    
    [self.layer addSublayer:self.waveLayer];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 40;
    self.layer.borderColor = [[UIColor greenColor] colorWithAlphaComponent:0.7].CGColor;
    self.layer.borderWidth = 3;
    self.clipsToBounds = YES;
    
    self.label = [UILabel new];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tap];
    
    [self setCurrentWaveLayerPath];
    
    _waveTimer = [NSTimer scheduledTimerWithTimeInterval:0.022 target:self selector:@selector(setCurrentWaveLayerPath) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_waveTimer forMode:NSRunLoopCommonModes];
}

- (void)dealloc
{
    [_waveTimer invalidate];
    _waveTimer = nil;
}

- (void)onLongPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scale) userInfo:nil repeats:YES];
        }
    } else {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)scale
{
    static BOOL flag = YES;
    static CGFloat scale = 1;

    if (flag) {
        scale += 0.04;
        if (scale > 2) {
            scale = 2;
            flag = NO;
        }
    } else {
        scale -= 0.04;
        if (scale < 0.2) {
            scale = 0.2;
            flag = YES;
        }
    }
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)onPan:(UIGestureRecognizer *)recognizer
{
    self.center = [recognizer locationInView:self.superview];
}

- (void)onTap
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请设置内存警告阈值" message:nil delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void)setCurrentWaveLayerPath
{
    
    if (!_isShowing) {
        return;
    }
    
    // 正弦曲线公式：y=Asin(ωx+φ)+k
    
    CGFloat wh = 80.f;
    CGFloat persent = 1 - MIN(1, self.memory / _threshold);
    CGFloat s_ω = 2.0 * M_PI / wh;
    CGFloat s_k = wh * persent;
    CGFloat s_φ = 0;
    CGFloat s_A = 1.3f;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-40, wh * persent)];
    
    static CGFloat controlX = 0;
    s_φ = controlX;
    
    for (float x = 0.f; x <= wh; x += 2)
    {
        CGFloat y = s_A * sin(s_ω * x + s_φ) + s_k;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    [path addLineToPoint:CGPointMake(wh + 40, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    
    controlX += 0.4 / M_PI;;
    
    self.waveLayer.path = [path CGPath];
}

- (void)setThreshhold:(double)value
{
    _threshold = value;
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    int value = [[alertView textFieldAtIndex:0].text intValue];
    if (value == 0) {
        return;
    }
    [self setThreshhold:value];
    [[OOMDetector getInstance] startMaxMemoryStatistic:value];
}


@end
