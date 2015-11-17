//
//  UITableView+SDAutoTableViewCellHeight.m
//  SDAutoLayout 测试 Demo
//
//  Created by aier on 15/11/1.
//  Copyright © 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import <objc/runtime.h>

@implementation  UITableViewCell (SDAutoHeight)

- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    self.sd_bottomView = bottomView;
    self.sd_bottomViewBottomMargin = bottomMargin;
    self.sd_layout.autoHeightRatio(0);
}

- (CGFloat)autoHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setAutoHeight:(CGFloat)autoHeight
{
    objc_setAssociatedObject(self, @selector(autoHeight), @(autoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sd_bottomView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_bottomView:(UIView *)sd_bottomView
{
    objc_setAssociatedObject(self, @selector(sd_bottomView), sd_bottomView, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)sd_bottomViewBottomMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSd_bottomViewBottomMargin:(CGFloat)sd_bottomViewBottomMargin
{
    objc_setAssociatedObject(self, @selector(sd_bottomViewBottomMargin), @(sd_bottomViewBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation SDCellAutoHeightManager
{
    NSMutableDictionary *_cacheDictionary;
    UITableViewCell *_modelCell;
}

- (instancetype)initWithCellClass:(Class)cellClass
{
    if (self = [super init]) {
        _modelCell = (UITableViewCell *)[cellClass alloc];
        _modelCell = [_modelCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellAutoHeightManager"];
        if (!_modelCell.contentView.subviews.count) {
            UITableView *temp = [UITableView new];
            [temp registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:@"SDCellAutoHeightManager"];
            _modelCell = [temp dequeueReusableCellWithIdentifier:@"SDCellAutoHeightManager"];
        }
        _modelCell.contentView.tag = kSDModelCellTag;
        _cellClass = cellClass;
        
        _cacheDictionary = [NSMutableDictionary new];
    }
    return self;
}

+ (instancetype)managerWithCellClass:(Class)cellClass
{
    SDCellAutoHeightManager *manager = [[self alloc] initWithCellClass:cellClass];
    return manager;
}

- (void)clearHeightCache
{
    [_cacheDictionary removeAllObjects];
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath
{
    NSString *cacheKey = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    NSNumber *cacheHeight = [_cacheDictionary objectForKey:cacheKey];
    if (cacheHeight) {
        return [cacheHeight floatValue];
    } else {
        if (model && keyPath) {
            [_modelCell setValue:model forKey:keyPath];
        }
        [_modelCell.contentView layoutSubviews];
        [_cacheDictionary setObject:@(_modelCell.autoHeight) forKey:cacheKey];
        return _modelCell.autoHeight;
    }
}

- (void)setContentViewWidth:(CGFloat)contentViewWidth
{
    if (_contentViewWidth != contentViewWidth) {
        [self clearHeightCache];
    }
    _contentViewWidth = contentViewWidth;
    
    _modelCell.frame = CGRectMake(0, 0, contentViewWidth, 44);
    _modelCell.contentView.frame = CGRectMake(0, 0, contentViewWidth, 44);
}

@end


@implementation UITableView (SDAutoTableViewCellHeight)
 
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method reloadData = class_getInstanceMethod(self, @selector(reloadData));
        Method sd_reloadData = class_getInstanceMethod(self, @selector(sd_reloadData));
        method_exchangeImplementations(reloadData, sd_reloadData);
    });
}

- (void)sd_reloadData
{
    [self.cellAutoHeightManager clearHeightCache];
    [self sd_reloadData];
}
/*
 * 下一步即将实现的功能
 
- (void)sd_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self sd_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sd_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self sd_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sd_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self sd_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sd_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    [self sd_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}
 
 */

- (void)startAutoCellHeightWithCellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth
{
    if (!self.cellAutoHeightManager) {
        self.cellAutoHeightManager = [SDCellAutoHeightManager managerWithCellClass:cellClass];
    }
    self.cellAutoHeightManager.contentViewWidth = contentViewWidth;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath
{
    return [self.cellAutoHeightManager cellHeightForIndexPath:indexPath model:model keyPath:keyPath];
}

- (SDCellAutoHeightManager *)cellAutoHeightManager
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCellAutoHeightManager:(SDCellAutoHeightManager *)cellAutoHeightManager
{
    objc_setAssociatedObject(self, @selector(cellAutoHeightManager), cellAutoHeightManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end




