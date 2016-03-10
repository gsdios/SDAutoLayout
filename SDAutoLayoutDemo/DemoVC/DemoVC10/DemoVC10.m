//
//  DemoVC10.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/1/20.
//  Copyright © 2016年 gsd. All rights reserved.
//


/*
 本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
 */

#import "DemoVC10.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XYString.h"

#import "ThreeBaseCell.h"
#import "ThreeFirstCell.h"
#import "ThreeSecondCell.h"
#import "ThreeThirdCell.h"
#import "ThreeFourthCell.h"

/*
 本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
 */

@interface DemoVC10 () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic ,strong) UITableView *tv;
@property(nonatomic ,strong) NSMutableArray *listArry;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;

@end

@implementation DemoVC10

- (void)viewDidLoad {
    
    /*
     本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
     */
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.tv];
    
    self.tv.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}


#pragma mark - getter
- (UITableView *)tv{
    
    /*
     本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
     */
    
    
    
    if (!_tv) {
        
        _tv = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tv.separatorColor = [UIColor clearColor];
        _tv.delegate = self;
        _tv.dataSource = self;
        
        __weak typeof(self) weakSelf = self;
        
        //..下拉刷新
        _tv.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.myRefreshView = weakSelf.tv.header;
            weakSelf.page = 0;
            [weakSelf loadData];
        }];
        
        // 马上进入刷新状态
        [_tv.header beginRefreshing];
        
        //..上拉刷新
        _tv.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.myRefreshView = weakSelf.tv.footer;
            weakSelf.page = weakSelf.page + 10;
            [weakSelf loadData];
        }];
        
        _tv.footer.hidden = YES;
        
        
    }
    return _tv;
}

-(NSMutableArray *)listArry{
    
    if (!_listArry) {
        _listArry = [[NSMutableArray alloc] init];
    }
    return _listArry;
}

#pragma mark - 请求数据
-(void)loadData{
    /*
     本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
     */
    NSString * urlString = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/%ld-20.html",@"headline/T1348647853363",self.page];
    NSLog(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [XYString getObjectFromJsonString:operation.responseString];
        //..keyEnumerator 获取字典里面所有键  objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
        NSString *key = [dict.keyEnumerator nextObject];//.取键值
        NSArray *temArray = dict[key];
        
        // 数组>>model数组
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[ThreeModel mj_objectArrayWithKeyValuesArray:temArray]];
        
        //..下拉刷新
        if (self.myRefreshView == _tv.header) {
            self.listArry = arrayM;
            _tv.footer.hidden = self.listArry.count==0?YES:NO;
            
        }else if(self.myRefreshView == _tv.footer){
            [self.listArry addObjectsFromArray:arrayM];
        }
        
        
        [self doneWithView:self.myRefreshView];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        [_myRefreshView endRefreshing];
    }];
}

#pragma mark -  回调刷新
-(void)doneWithView:(MJRefreshComponent*)refreshView{
    [_tv reloadData];
    [_myRefreshView  endRefreshing];
}


#pragma mark - 表的协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
     */
    ThreeBaseCell * cell = nil;
    ThreeModel * threeModel = self.listArry[indexPath.row];
    
    NSString * identifier = [ThreeBaseCell cellIdentifierForRow:threeModel];
    Class mClass =  NSClassFromString(identifier);
    
    cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[mClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.threeModel = threeModel;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // cell自适应设置
    ThreeModel * threeModel = self.listArry[indexPath.row];
    
    NSString * identifier = [ThreeBaseCell cellIdentifierForRow:threeModel];
    Class mClass =  NSClassFromString(identifier);
    
    // 返回计算出的cell高度（普通简化版方法，同样只需一步设置即可完成）
    return [self.tv cellHeightForIndexPath:indexPath model:threeModel keyPath:@"threeModel" cellClass:mClass contentViewWidth:[self cellContentViewWith]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
