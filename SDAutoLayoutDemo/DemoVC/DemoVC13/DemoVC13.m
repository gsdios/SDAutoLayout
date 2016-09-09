//
//  DemoVC13.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/3/18.
//  Copyright © 2016年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 * QQ交流群：519489682（一群）497140713（二群）                                       *
 *********************************************************************************
 
 */

#import "DemoVC13.h"

#import "UIView+SDAutoLayout.h"

NSString *const kCommonText = @"Hello, everybody! 我是SDAutoLayout，我是不是萌萌哒呢？ ^_^  ^(***)^  ^_^ ";
static const CGFloat maxImageViewWidth = 200.f;

#define kGridItemViewColor [[UIColor greenColor] colorWithAlphaComponent:0.5]

@interface DemoVC13 () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroollView;

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *lastBottomLine;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *gridItemContainerView;

@property (nonatomic, strong) UIButton *addGridItemButton;

@end

@implementation DemoVC13

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.wrapperView = [UIView new];
    [self.scroollView addSubview:self.wrapperView];
    [self.scroollView setupAutoContentSizeWithBottomView:self.wrapperView bottomMargin:0];
    
    
    [self setupContentCell];
    [self setupImageCell];
    [self setupGridViewCell];
    
    self.wrapperView.sd_layout.
    leftEqualToView(self.scroollView)
    .rightEqualToView(self.scroollView)
    .topEqualToView(self.scroollView);
    [self.wrapperView setupAutoHeightWithBottomView:self.lastBottomLine bottomMargin:10];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIScrollView *)scroollView
{
    if (!_scroollView) {
        _scroollView = [UIScrollView new];
        _scroollView.delegate = self;
        [self.view addSubview:_scroollView];
        
        _scroollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return _scroollView;
}

- (UIView *)addSeparatorLineBellowView:(UIView *)view margin:(CGFloat)margin
{
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self.wrapperView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.wrapperView, 5)
    .rightSpaceToView(self.wrapperView, 5)
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

// 设置展示文字的模拟cell
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
    
    [self.wrapperView sd_addSubviews:@[titleLabel, contentLabel, buttonContainer]];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.wrapperView, 10)
    .topSpaceToView(self.wrapperView, 20)
    .widthIs(80)
    .heightIs(20);
    
    contentLabel.sd_layout
    .leftSpaceToView(titleLabel, 10)
    .topEqualToView(titleLabel)
    .rightSpaceToView(self.wrapperView, 10)
    .autoHeightRatio(0);
    
    buttonContainer.sd_layout
    .leftEqualToView(contentLabel)
    .rightEqualToView(contentLabel)
    .topSpaceToView(contentLabel, 10)
    .heightIs(25);
    
    self.lastBottomLine = [self addSeparatorLineBellowView:buttonContainer margin:10];
    
}

// 设置展示图片的模拟cell
- (void)setupImageCell
{
    UILabel *titleLabel = [self titleLabelWithText:@"图片展示"];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"pic0.jpg"];
    self.imageView = imageView;
    
    UIButton *magnifyButton = [self buttonWithTitle:@"放大" bgColor:[[UIColor blueColor] colorWithAlphaComponent:0.3] sel:@selector(magnifyImage)];
    
    UIButton *shrinkButton = [self buttonWithTitle:@"缩小" bgColor:[[UIColor redColor] colorWithAlphaComponent:0.7] sel:@selector(shrinkImage)];
    
    [self.wrapperView sd_addSubviews:@[titleLabel, imageView, magnifyButton, shrinkButton]];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.wrapperView, 10)
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

// 设置展示列表的模拟cell
- (void)setupGridViewCell
{
    
    UILabel *titleLabel = [self titleLabelWithText:@"列表展示"];
    
    UIView *contanerView = [UIView new];
    contanerView.backgroundColor = [UIColor redColor];
    self.gridItemContainerView = contanerView;
    
    [self.wrapperView sd_addSubviews:@[titleLabel, contanerView]];
    
    
    {
        UIButton *addButton = [UIButton new];
        self.addGridItemButton = addButton;
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        addButton.backgroundColor = kGridItemViewColor;
        [addButton addTarget:self action:@selector(addGridItemView) forControlEvents:UIControlEventTouchUpInside];
        [contanerView addSubview:addButton];
        
        addButton.sd_layout
        .leftSpaceToView(contanerView, 10)
        .topSpaceToView(contanerView, 10)
        .rightSpaceToView(contanerView, 10)
        .heightIs(50);
    }
    
    
    
    titleLabel.sd_layout
    .leftSpaceToView(self.wrapperView, 10)
    .topSpaceToView(self.lastBottomLine, 10)
    .widthIs(80)
    .heightIs(20);
    
    contanerView.sd_layout
    .leftSpaceToView(titleLabel, 10)
    .topEqualToView(titleLabel)
    .rightSpaceToView(self.wrapperView, 10);
    [contanerView setupAutoHeightWithBottomView:contanerView.subviews.lastObject bottomMargin:10];
    
    self.lastBottomLine = [self addSeparatorLineBellowView:contanerView margin:10];
}


- (void)addText
{
    self.contentLabel.text = [NSString stringWithFormat:@"%@     %@", self.contentLabel.text, kCommonText];
    [self updateViews];
}

- (void)delText
{
    long to = self.contentLabel.text.length - 20;
    to = to < 1 ? 1 : to;
    self.contentLabel.text = [self.contentLabel.text substringToIndex:to];
    [self updateViews];
}

// 放大图片
- (void)magnifyImage
{
    CGFloat w = self.imageView.width_sd * 1.3;
    if (w > maxImageViewWidth) {
        [self showAlertWithText:@"已经达到最大宽度"];
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.sd_layout.widthIs(self.imageView.width_sd * 1.3);
        [self.wrapperView layoutSubviews];
        [self.scroollView layoutSubviews];
    }];
}

// 缩小图片
- (void)shrinkImage
{
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.sd_layout.widthIs(self.imageView.width_sd * 0.7);
        [self.wrapperView layoutSubviews];
        [self.scroollView layoutSubviews];
    }];
}

- (void)updateViews
{
    [self.wrapperView layoutSubviews];
    [self.scroollView layoutSubviews];
}

- (void)addGridItemView
{
    UIView *view = [UIView new];
    view.backgroundColor = kGridItemViewColor;
    [self.gridItemContainerView insertSubview:view belowSubview:self.addGridItemButton];
    
    __block UIView *lastView = self.gridItemContainerView;
    
    [self.gridItemContainerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx < 3 && (idx == (self.gridItemContainerView.subviews.count > 2 ? 2 : 1))) { // 如果idx等于当第一行最后一个view的index时开始设置一行等宽子view
            NSMutableArray *equalWidthSubviews = [NSMutableArray new];
            for (int i = 0; i <= idx; i++) {
                UIView *subview = self.gridItemContainerView.subviews[i];
                [equalWidthSubviews addObject:subview];
                if (i == 0) { // 设置一排等宽子view的第一个view的约束
                    subview.sd_resetLayout
                    .leftSpaceToView(lastView, 10)
                    .topSpaceToView(lastView, 10)
                    .heightIs(50);
                } else if (i == idx) { // 设置一排等宽子view的中间view的约束
                    subview.sd_resetLayout
                    .leftSpaceToView(lastView, 10)
                    .topEqualToView(lastView)
                    .rightSpaceToView(self.gridItemContainerView, 10)
                    .heightRatioToView(lastView, 1);
                    self.gridItemContainerView.sd_equalWidthSubviews = [equalWidthSubviews copy];
                } else { // 设置一排等宽子view的最后一个view的约束
                    subview.sd_resetLayout
                    .leftSpaceToView(lastView, 10)
                    .topEqualToView(lastView)
                    .heightIs(50);
                }
                lastView = subview;
            }
        } else if (idx > 2){ // 设置第一排之后的子view的的约束
            long lastViewIndex = idx - 3;
            lastView = self.gridItemContainerView.subviews[lastViewIndex];
        
            view.sd_resetNewLayout
            .leftEqualToView(lastView)
            .rightEqualToView(lastView)
            .heightRatioToView(lastView, 1)
            .topSpaceToView(lastView, 10);
        }
    }];
    
    [self.gridItemContainerView setupAutoHeightWithBottomView:self.gridItemContainerView.subviews.lastObject bottomMargin:10];
    
    [self.wrapperView layoutSubviews];
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



#pragma mark - 监听屏幕旋转

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAutoLayout”属性来设置要不要触发自动布局计算
    self.scroollView.sd_closeAutoLayout = NO;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAutoLayout”属性来设置要不要触发自动布局计算
    self.wrapperView.sd_closeAutoLayout = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAutoLayout”属性来设置要不要触发自动布局计算
    self.wrapperView.sd_closeAutoLayout = NO;
}


@end
