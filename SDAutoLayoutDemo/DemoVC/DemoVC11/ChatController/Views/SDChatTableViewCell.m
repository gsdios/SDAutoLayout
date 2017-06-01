//
//  SDChatTableViewCell.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/13.
//  Copyright © 2016年 GSD. All rights reserved.
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
 * QQ交流群：519489682（已满）497140713                                              *
 *********************************************************************************
 
 */




#import "SDChatTableViewCell.h"

#import "UIView+SDAutoLayout.h"

#import "LEETheme.h"

#define kLabelMargin 20.f
#define kLabelTopMargin 8.f
#define kLabelBottomMargin 20.f

#define kChatCellItemMargin 10.f

#define kChatCellIconImageViewWH 35.f

#define kMaxContainerWidth 220.f
#define kMaxLabelWidth (kMaxContainerWidth - kLabelMargin * 2)

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f

@interface SDChatTableViewCell () <MLEmojiLabelDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) MLEmojiLabel *label;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation SDChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupView];
    
        //设置主题
        
        [self configTheme];
        
    }
    return self;
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _label = [MLEmojiLabel new];
    _label.delegate = self;
    _label.font = [UIFont systemFontOfSize:16.0f];
    _label.numberOfLines = 0;
    _label.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _label.isAttributedContent = YES;
    [_container addSubview:_label];
    
    _messageImageView = [UIImageView new];
    [_container addSubview:_messageImageView];
    
    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    
    _maskImageView = [UIImageView new];
    
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(@"demovc11_backgroundcolor");
    
//    self.label.lee_theme.LeeConfigTextColor(@"demovc11_textcolor");
    
    //其实UILabel的话只要按照上面的设置textcolor就可以的 , 这个label是第三方的 设置后不会马上变 , 需要重新赋值一下才会改变 - ,- 针对你这个情况 所以这样处理一下先
    self.label.lee_theme
    .LeeAddCustomConfig(@"day", ^(MLEmojiLabel *item) {
        
        item.textColor = [UIColor blackColor];
        
        item.text = item.text; // 重新赋值text
    })
    .LeeAddCustomConfig(@"night", ^(MLEmojiLabel *item) {
        
        item.textColor = [UIColor lightGrayColor];
        
        item.text = item.text;
    });
    
    //正常应该设置image的标识符 完成切换不同图片的效果 , 但是这个demo没有夜间图片 暂时用这个方式演示一下咯 , 要不然会看着不太和谐
    
    self.containerBackgroundImageView.lee_theme
    .LeeAddCustomConfig(@"day" , ^(UIImageView * item){
        
        item.alpha = 1.0f;
        
    }).LeeAddCustomConfig(@"night" , ^(UIImageView * item){
        
        item.alpha = 0.2f;
    });
    
}

- (void)setModel:(SDChatModel *)model{
    
    _model = model;
    
    _label.text = model.text;
    self.iconImageView.image = [UIImage imageNamed:model.iconName];
    
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:model];
    
    if (model.imageName) { // 有图片的先看下设置图片自动布局
        
        // cell重用时候清除只有文字的情况下设置的container宽度自适应约束
        [self.container clearAutoWidthSettings];
        self.messageImageView.hidden = NO;
        
        self.messageImageView.image = [UIImage imageNamed:model.imageName];
        
        // 根据图片的宽高尺寸设置图片约束
        CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
        CGFloat widthHeightRatio = 0;
        UIImage *image = [UIImage imageNamed:model.imageName];
        CGFloat h = image.size.height;
        CGFloat w = image.size.width;
        
        if (w > kMaxChatImageViewWidth || w > kMaxChatImageViewHeight) {
            
            widthHeightRatio = w / h;
            
            if (widthHeightRatio > standardWidthHeightRatio) {
                w = kMaxChatImageViewWidth;
                h = w * (image.size.height / image.size.width);
            } else {
                h = kMaxChatImageViewHeight;
                w = h * widthHeightRatio;
            }
        }
        
        self.messageImageView.size_sd = CGSizeMake(w, h);
        _container.sd_layout.widthIs(w).heightIs(h);
        
        // 设置container以messageImageView为bottomView高度自适应
        [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
        
        // container按照maskImageView裁剪
        self.container.layer.mask = self.maskImageView.layer;
        
        __weak typeof(self) weakself = self;
        [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
            // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
            weakself.maskImageView.size_sd = frame.size;
        }];
        
    } else if (model.text) { // 没有图片有文字情况下设置文字自动布局
        
        // 清除展示图片时候用到的mask
        [_container.layer.mask removeFromSuperlayer];
        
        self.messageImageView.hidden = YES;
        
        // 清除展示图片时候_containerBackgroundImageView用到的didFinishAutoLayoutBlock
        _containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
        
        _label.sd_resetLayout
        .leftSpaceToView(_container, kLabelMargin)
        .topSpaceToView(_container, kLabelTopMargin)
        .autoHeightRatio(0); // 设置label纵向自适应
        
        // 设置label横向自适应
        [_label setSingleLineAutoResizeWithMaxWidth:kMaxContainerWidth];
        
        // container以label为rightView宽度自适应
        [_container setupAutoWidthWithRightView:_label rightMargin:kLabelMargin];
        
        // container以label为bottomView高度自适应
        [_container setupAutoHeightWithBottomView:_label bottomMargin:kLabelBottomMargin];
    }
}


- (void)setMessageOriginWithModel:(SDChatModel *)model
{
    if (model.messageType == SDMessageTypeSendToOthers) {
        // 发出去的消息设置居右样式
        self.iconImageView.sd_resetLayout
        .rightSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topEqualToView(self.iconImageView).rightSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        _containerBackgroundImageView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    } else if (model.messageType == SDMessageTypeSendToMe) {
        
        // 收到的消息设置居左样式
        self.iconImageView.sd_resetLayout
        .leftSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topEqualToView(self.iconImageView).leftSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        _containerBackgroundImageView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    }
    
    _maskImageView.image = _containerBackgroundImageView.image;
}


#pragma mark - MLEmojiLabelDelegate

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (self.didSelectLinkTextOperationBlock) {
        self.didSelectLinkTextOperationBlock(link, type);
    }
}

@end
