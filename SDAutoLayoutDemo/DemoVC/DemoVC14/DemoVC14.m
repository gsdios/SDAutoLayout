//
//  DemoVC14.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/12.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "DemoVC14.h"

#import "DemoVC14Cell.h"
#import "DemoVC7Model.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface DemoVC14 ()

@property (nonatomic, strong) NSMutableArray *modelsArray;

@end

@implementation DemoVC14

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatModelsWithCount:20];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DemoVC14Cell" bundle:nil] forCellReuseIdentifier:@"DemoVC14Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatModelsWithCount:(NSInteger)count
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     @"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg"
                                     ];
    
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的LaunchImage 时。然后等比例拉伸屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任小。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"然后等比例拉伸到大屏。屏幕宽度返回 320否则在大屏上会显得字大长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会",
                           @"长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任小。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。"
                           ];
    
    for (int i = 0; i < count; i++) {
        
        int nameRandomIndex = arc4random_uniform(5);
        
        DemoVC7Model *model = [DemoVC7Model new];
        model.title = textArray[nameRandomIndex];
        model.iconImagePath = iconImageNamesArray[arc4random_uniform(9)];
        
        // 模拟“有或者无图片”
        int random = arc4random_uniform(1);
        if (random <= 8) {
            NSMutableArray *temp = [NSMutableArray new];
            
            int randomImagesCount = arc4random_uniform(9);
            for (int i = 0; i < randomImagesCount; i++) {
                int randomIndex = arc4random_uniform(9);
                NSString *text = iconImageNamesArray[randomIndex];
                [temp addObject:text];
            }
            
            model.imagePathsArray = [temp copy];
        }
        
        [self.modelsArray addObject:model];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoVC14Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoVC14Cell"];
    
    cell.model = self.modelsArray[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoVC7Model *demoVC14Modelodel = self.modelsArray[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:demoVC14Modelodel keyPath:@"model" cellClass:[DemoVC14Cell class] contentViewWidth:[self cellContentViewWith]];
    
    /*
     *  第二种返回cell高度的方法，此方法不需要设置keyPath，适合一个cell与多个model的情况
     
    AutoCellHeightDataSettingBlock dataSetting = ^(UITableViewCell *cell) {
        DemoVC14Cell *myCell = (DemoVC14Cell *)cell;
        myCell.model = demoVC14Modelodel;
    };
    
    return [self.tableView cellHeightForIndexPath:indexPath
                                        cellClass:[DemoVC14Cell class]
                             cellContentViewWidth:[UIScreen mainScreen].bounds.size.width cellDataSetting:dataSetting];
     */
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
