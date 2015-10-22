# SDAutoLayout
致力于做最简单易用的Autolayout库。The most easy way for autolayout.

# 摒弃复杂累赘的约束，利用运行时Runtime在合适的时机布局视图。
# 0.用法示例
    /* 用法一 */
    _view.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 80)
    .heightIs(130)
    .widthRatioToView(self.view, 0.4);  

    /* 用法二 （一行代码搞定，其实用法一也是一行代码） */
    _view.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.view,80).heightIs(130).widthRatioToView(self.view, 0.4);
    
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

# 1.用法简析

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

