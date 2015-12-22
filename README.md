# SDAutoLayout

☆☆ SDAutoLayout 视频教程：http://www.letv.com/ptv/vplay/24038772.html ☆☆

一行代码搞定自动布局！致力于做最简单易用的Autolayout库。The most easy way for autolayout.


#    ☆新增：cell高度自适应 + label文字自适应☆

![](http://ww2.sinaimg.cn/bmiddle/9b8146edgw1eya1jv951ig208c0etqv5.gif)

##    >>>>> 升级版：tableview cell 自动高度设置只需要2步
    
    1. >> 设置cell高度自适应：
    // cell布局设置好之后调用此方法就可以实现高度自适应（注意：如果用高度自适应则不要再以cell的底边为参照去布局其子view）
    [cell setupAutoHeightWithBottomView:_view4 bottomMargin:10];
    
    2. >> 获取自动计算出的cell高度 
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    // 获取cell高度
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }
    
    
##    >>>>> 普通版：tableview cell 自动高度设置只需要3步
    
    1. >> 设置cell高度自适应：
    // cell布局设置好之后调用此方法就可以实现高度自适应（注意：如果用高度自适应则不要再以cell的底边为参照去布局其子view）
    [cell setupAutoHeightWithBottomView:_view4 bottomMargin:10];
    
    2. >> 设置 tableview 数据源和代理
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
    // 2.1 注册模型cell 
    [self.tableView startAutoCellHeightWithCellClass:“cell类名” contentViewWidth:“contentview宽度”];

    return _rowCount;
    }
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    // 2.2 根据模型取得cell高度
    return [self.tableView cellHeightForIndexPath:indexPath model:“model” keyPath:@"model属性名"];
    }
    
    
# ***********  普通view的自动布局  ***********

## 摒弃复杂累赘的约束，利用运行时Runtime在合适的时机布局视图。

## 0.用法示例
    /* 用法一 */
    _view.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 80)
    .heightIs(130)
    .widthRatioToView(self.view, 0.4);  

    /* 用法二 （一行代码搞定，其实用法一也是一行代码） */
    _view.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.view,80).heightIs(130).widthRatioToView(self.view, 0.4);
    
    
    >> UILabel文字自适应：
    // autoHeightRatio() 传0则根据文字自动计算高度（传大于0的值则根据此数值设置高度和宽度的比值）
    _label.sd_layout.autoHeightRatio(0);
    
    *******************************************************************************
        
        注意:先把需要自动布局的view加入父view然后在进行自动布局，例： 
        
        UIView *view0 = [UIView new];
        UIView *view1 = [UIView new];
        [self.view addSubview:view0];
        [self.view addSubview:view1];
        
        view0.sd_layout
        .leftSpaceToView(self.view, 10)
        .topSpaceToView(self.view, 80)
        .heightIs(100)
        .widthRatioToView(self.view, 0.4);
        
        view1.sd_layout
        .leftSpaceToView(view0, 10)
        .topEqualToView(view0)
        .heightRatioToView(view0, 1)
        .rightSpaceToView(self.view, 10);
    *******************************************************************************

## 1.用法简析

![](http://ww1.sinaimg.cn/mw690/9b8146edgw1ex4or5ixkjj20k60gw3zg.jpg)


   1.1 > leftSpaceToView(self.view, 10)
   
   方法名中带有“SpaceToView”的方法表示到某个参照view的间距，需要传递2个参数：（UIView）参照view 和 （CGFloat）间距数值
   
   1.2 > widthRatioToView(self.view, 1)
   
   方法名中带有“RatioToView”的方法表示view的宽度或者高度等属性相对于参照view的对应属性值的比例，需要传递2个参数：（UIView）参照view 和 （CGFloat）倍数
   
   1.3 > topEqualToView(view)
   
   方法名中带有“EqualToView”的方法表示view的某一属性等于参照view的对应的属性值，需要传递1个参数：（UIView）参照view
   
   1.4 > widthIs(100)
   
   方法名中带有“Is”的方法表示view的某一属性值等于参数数值，需要传递1个参数：（CGFloat）数值

# PS

/* 如果您需要布局错误LOG信息提示请打开此宏 */

//#define SDAutoLayoutIssueLog

![](http://ww3.sinaimg.cn/bmiddle/9b8146edgw1ex4mukixr6g209g07lhdt.gif)

