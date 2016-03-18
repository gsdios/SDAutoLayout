//
//  DemoVC13.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/3/18.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "DemoVC13.h"

#import "UIView+SDAutoLayout.h"

NSString *const kCommonText = @"Hello, everybody! 我是SDAutoLayout，我是不是萌萌哒呢？ ^_^  ^(***)^  ^_^ ";
static const CGFloat maxImageViewWidth = 200.f;

@interface DemoVC13 ()

@property (nonatomic, strong) UIScrollView *scroollView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *lastBottomLine;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DemoVC13

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupContentCell];
    [self setupImageCell];
    
    [self.scroollView setupAutoContentSizeWithBottomView:self.lastBottomLine bottomMargin:10];
}

- (UIScrollView *)scroollView
{
    if (!_scroollView) {
        _scroollView = [UIScrollView new];
        [self.view addSubview:_scroollView];
        
        _scroollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return _scroollView;
}

- (UIView *)addSeparatorLineBellowView:(UIView *)view margin:(CGFloat)margin
{
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self.scroollView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.scroollView, 5)
    .rightSpaceToView(self.scroollView, 5)
    .heightIs(1)
    .topSpaceToView(view, margin);
    
    return line;
}

- (UILabel *)titleLabelWithText:(NSString *)text
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (UIButton *)buttonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor sel:(SEL)sel
{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = bgColor;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setupContentCell
{
    UILabel *titleLabel = [self titleLabelWithText:@"文字内容"];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.backgroundColor = titleLabel.backgroundColor;
    contentLabel.text = kCommonText;
    self.contentLabel = contentLabel;
    
    UIView *buttonContainer = [UIView new];
    
    {
        UIButton *addButton = [self buttonWithTitle:@"添加文字" bgColor:[[UIColor blueColor] colorWithAlphaComponent:0.3] sel:@selector(addText)];
        
        UIButton *delButton = [self buttonWithTitle:@"删减文字" bgColor:[[UIColor redColor] colorWithAlphaComponent:0.7] sel:@selector(delText)];
        
        [buttonContainer sd_addSubviews:@[addButton, delButton]];
        

        buttonContainer.sd_equalWidthSubviews = @[addButton, delButton];
        
        addButton.sd_layout
        .leftSpaceToView(buttonContainer, 10)
        .topEqualToView(buttonContainer)
        .bottomEqualToView(buttonContainer);
        
        delButton.sd_layout
        .leftSpaceToView(addButton, 30)
        .rightSpaceToView(buttonContainer, 10)
        .topEqualToView(buttonContainer)
        .bottomEqualToView(buttonContainer);
    }
    
    [self.scroollView sd_addSubviews:@[titleLabel, contentLabel, buttonContainer]];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.scroollView, 10)
    .topSpaceToView(self.scroollView, 20)
    .widthIs(80)
    .heightIs(20);
    
    contentLabel.sd_layout
    .leftSpaceToView(titleLabel, 10)
    .topEqualToView(titleLabel)
    .rightSpaceToView(self.scroollView, 10)
    .autoHeightRatio(0);
    
    buttonContainer.sd_layout
    .leftEqualToView(contentLabel)
    .rightEqualToView(contentLabel)
    .topSpaceToView(contentLabel, 10)
    .heightIs(25);
    
    self.lastBottomLine = [self addSeparatorLineBellowView:buttonContainer margin:10];
    
}

- (void)setupImageCell
{
    UILabel *titleLabel = [self titleLabelWithText:@"图片展示"];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"pic0.jpg"];
    self.imageView = imageView;
    
    UIButton *magnifyButton = [self buttonWithTitle:@"放大" bgColor:[[UIColor blueColor] colorWithAlphaComponent:0.3] sel:@selector(magnifyImage)];
    
    UIButton *shrinkButton = [self buttonWithTitle:@"缩小" bgColor:[[UIColor redColor] colorWithAlphaComponent:0.7] sel:@selector(shrinkImage)];
    
    [self.scroollView sd_addSubviews:@[titleLabel, imageView, magnifyButton, shrinkButton]];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.scroollView, 10)
    .topSpaceToView(self.lastBottomLine, 10)
    .widthIs(80)
    .heightIs(20);
    
    imageView.sd_layout
    .leftSpaceToView(titleLabel, 10)
    .topEqualToView(titleLabel)
    .widthIs(50)
    .autoHeightRatio(2)
    .maxWidthIs(maxImageViewWidth)
    .maxHeightIs(800);
    
    magnifyButton.sd_layout
    .centerXEqualToView(imageView)
    .topSpaceToView(imageView, 10)
    .widthIs(50)
    .heightIs(25);
    
    shrinkButton.sd_layout
    .leftEqualToView(magnifyButton)
    .rightEqualToView(magnifyButton)
    .topSpaceToView(magnifyButton, 10)
    .heightIs(25);
    
    self.lastBottomLine = [self addSeparatorLineBellowView:shrinkButton margin:10];
}


- (void)addText
{
    self.contentLabel.text = [NSString stringWithFormat:@"%@     %@", self.contentLabel.text, kCommonText];
    [self.scroollView layoutSubviews];
}

- (void)delText
{
    long to = self.contentLabel.text.length - 20;
    to = to < 1 ? 1 : to;
    self.contentLabel.text = [self.contentLabel.text substringToIndex:to];
    [self.scroollView layoutSubviews];
}

- (void)magnifyImage
{
    CGFloat w = self.imageView.width * 1.1;
    if (w > maxImageViewWidth) {
        [self showAlertWithText:@"已经达到最大宽度"];
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.sd_layout.widthIs(self.imageView.width * 1.2);
        [self.scroollView layoutSubviews];
    }];
}

- (void)shrinkImage
{
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.sd_layout.widthIs(self.imageView.width * 0.8);
        [self.scroollView layoutSubviews];
    }];
}


- (void)showAlertWithText:(NSString *)text
{
    UIView *alert = [UIView new];
    alert.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    
    [alert addSubview:label];
    
    label.sd_layout
    .leftSpaceToView(alert, 20)
    .rightSpaceToView(alert, 20)
    .topSpaceToView(alert, 20)
    .autoHeightRatio(0);
    
    
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    alert.sd_layout
    .centerXEqualToView(alert.superview)
    .centerYEqualToView(alert.superview)
    .widthIs(200);
    [alert setupAutoHeightWithBottomView:label bottomMargin:20];
    
    alert.sd_cornerRadius = @(5);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert removeFromSuperview];
    });
}

@end
