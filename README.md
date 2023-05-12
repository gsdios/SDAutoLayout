# SDAutoLayout（一行代码搞定自动布局！）

一行代码搞定自动布局！致力于做最简单易用的Autolayout库。The most easy way for autolayout.

### 字节跳动 iOS 岗位招聘
北上广深杭大量招人，各种研发岗位都在找，有意向者可以直接点击后面链接投递简历或者联系我 gsdios@126.com https://job.toutiao.com/s/eL91QMm，

## 众多公司和个人开发者已经使用本库布局：
SDAutoLayout使用者开发的部分app截图 http://www.jianshu.com/p/9bc04d3effb8

## 技术支持(QQ交流群)：

497140713（1群）  519489682（2群已满）

## Pod支持：

支持pod：  pod 'SDAutoLayout', '~> 2.1.3'

## 更新记录：
2018.11.28 -- 修复部分开发者违规调用load的super方法导致自动布局失效的问题

2018.07.02 -- 修复了部分布局组合下view居中布局失效bug

2017.11.11 -- 实现控制富文本可显示行数功能

2017.11.11 -- 解决朋友圈demo在iOS11上文字收折或者展开时出现cell跳动问题

2017.06.26 -- 解决部分开发者反应因出现“UITableViewCellContentView”而导致应用审核被拒问题

2016.08.12 -- 实现在tableview插入新的cell数据时自动缓存管理

2016.06.30 -- 增加多参照view的leftSpaceToView和topSpaceToView约束，例：topSpaceToView(@[self.view3, self.view4], 30)

2016.06.24 -- 修复给button设置约束时在iOS8.x系统中出现的崩溃问题；发布2.1.2版本

2016.06.23 -- 实现删除某行cell时自动调整height缓存

2016.05.16 -- 修复用xib生成的view出现的部分约束失效问题（发布pod2.0.0版本）

2016.05.15 -- 增加设置偏移量offset功能

2016.04.30 -- 修复之前button作为父视图时内部控件不能自动布局问题

2016.04.05 -- 修复宽度自适应label在重用时候偶尔出现的宽度计算不准确的问题（发布pod1.51版本）

2016.03.23 -- 升级了缓存机制，新版本在tableview滑动cell时候流畅度和性能提升20%以上（发布pod1.50版本）

2016.01.23 -- 增加label对attributedString的内容自适应

2016.01.21 -- 实现tableview局部刷新cell高度缓存的自动管理

2016.01.20 -- demo适配在ios7上的屏幕旋转问题

2016.01.18 -- 推出“普通简化版”tableview的cell自动高度方法（推荐使用），原来的需2步设置的普通版方法将标记过期

2016.01.13 -- 增加在不确定bottom view的情况下的cell高度自适应方法

2016.01.07 -- 1.增加 scrollview 横向内容自适应功能；2.增加view宽高相等的功能

2016.01.03 -- 增加任何类型对象都可以实现一行代码搞定cell高度自适应；增加文档注释

2015.12.08 -- 重大升级：1.支持scrollview内容自适应；2.任意添加或者修改约束不冲突；3.性能提升40%以上；4.添加最大、最小宽高约束


## 视频教程：
☆☆ SDAutoLayout 基础版视频教程：http://www.letv.com/ptv/vplay/24038772.html ☆☆

☆☆ SDAutoLayout 进阶版视频教程：http://www.letv.com/ptv/vplay/24381390.html ☆☆

☆☆ SDAutoLayout 原理简介视频教程：http://www.iqiyi.com/w_19rt0tec4p.html ☆☆

☆☆ SDAutoLayout 朋友圈demo视频教程：http://v.youku.com/v_show/id_XMTYzNzg2NzA0MA==.html ☆☆

## 部分SDAutoLayout的DEMO：

完整微信Demo https://github.com/gsdios/GSD_WeiXin

![](http://ww3.sinaimg.cn/mw690/9b8146edgw1f1nm3pziawg205u0a0qv5.gif)![](http://ww1.sinaimg.cn/bmiddle/9b8146edgw1f06aoe2umhg206e0b4u0x.gif)![](http://ww4.sinaimg.cn/bmiddle/9b8146edgw1ezal3smihcg206y0ciqv5.gif)![](http://ww3.sinaimg.cn/mw690/9b8146edgw1f1nm3lweg3g207s0dcu0x.gif)![](http://ww2.sinaimg.cn/mw690/9b8146edgw1f23irukb0qg207i0dwu0x.gif)![](http://ww2.sinaimg.cn/bmiddle/9b8146edgw1eya1jv951ig208c0etqv5.gif)



#   用法简介
    
    
## 普通view的自动布局：

#### 用法示例
     用法一
```
    _view.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 80)
    .heightIs(130)
    .widthRatioToView(self.view, 0.4);  
```
    用法二 （一行代码搞定，其实用法一也是一行代码）
```
    _view.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.view,80).heightIs(130).widthRatioToView(self.view, 0.4);
```
    综合示例
```   
    
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
```  

## UILabel文字自适应
```
// autoHeightRatio() 传0则根据文字自动计算高度（传大于0的值则根据此数值设置高度和宽度的比值）
    _label.sd_layout.autoHeightRatio(0);
```
    
## tableview和cell高度自适应：   

#### 普通（简化）版【推荐使用】：tableview 高度自适应设置只需要2步
```    
    1. >> 设置cell高度自适应：
    // cell布局设置好之后调用此方法就可以实现高度自适应（注意：如果用高度自适应则不要再以cell的底边为参照去布局其子view）

    [cell setupAutoHeightWithBottomView:_view4 bottomMargin:10];
```
```   
    2. >> 获取自动计算出的cell高度

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        id model = self.modelsArray[indexPath.row];
        // 获取cell高度
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DemoVC9Cell class]  contentViewWidth:cellContentViewWith];
    }
```

#### 升级版（适应于cell条数少于100的tableview）：tableview 高度自适应设置只需要2步
```    
    1. >> 设置cell高度自适应：
    // cell布局设置好之后调用此方法就可以实现高度自适应（注意：如果用高度自适应则不要再以cell的底边为参照去布局其子view）

    [cell setupAutoHeightWithBottomView:_view4 bottomMargin:10];
```
```    
    2. >> 获取自动计算出的cell高度 

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    // 获取cell高度
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }
```
    

#### 自动布局用法简析

![](http://ww1.sinaimg.cn/mw690/9b8146edgw1ex4or5ixkjj20k60gw3zg.jpg)

```
   1.1 > leftSpaceToView(self.view, 10)
   
   方法名中带有“SpaceToView”的方法表示到某个参照view的间距，需要传递2个参数：（UIView）参照view 和 （CGFloat）间距数值

   1.2 > widthRatioToView(self.view, 1)
   
   方法名中带有“RatioToView”的方法表示view的宽度或者高度等属性相对于参照view的对应属性值的比例，需要传递2个参数：（UIView）参照view 和 （CGFloat）倍数
 
   1.3 > topEqualToView(view)
   
   方法名中带有“EqualToView”的方法表示view的某一属性等于参照view的对应的属性值，需要传递1个参数：（UIView）参照view
   
   1.4 > widthIs(100)
   
   方法名中带有“Is”的方法表示view的某一属性值等于参数数值，需要传递1个参数：（CGFloat）数值
```

# PS

// 如果需要用“断言”调试程序请打开此宏(位于UIView+SDAutoLayout.h)

//#define SDDebugWithAssert


![](http://ww3.sinaimg.cn/bmiddle/9b8146edgw1ex4mukixr6g209g07lhdt.gif)


![](http://upload-images.jianshu.io/upload_images/1157161-07fa43e0f539ebad.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/1157161-453a5d33d7f3d48d.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
