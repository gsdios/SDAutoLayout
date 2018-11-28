//
//  SDAutolayout+extension.swift
//  SDAutoLayoutDemo
//
//  Created by fancy on 2018/5/29.
//  Copyright © 2018年 gsd. All rights reserved.
//

// 若使用cocoapods管理第三方，则打开 import SDAutoLayout 注释
// import SDAutoLayout

extension UIView {
    @discardableResult
    public func layout() -> SDAutoLayoutModel {
        return sd_layout()
    }
}

extension SDAutoLayoutModel {
    /* 设置距离其它view的间距 */
    @discardableResult
    public func topTo(_ view: UIView, _ space: CGFloat) -> SDAutoLayoutModel {
        return topSpaceToView(view, space)
    }
    
    @discardableResult
    public func bottomTo(_ view: UIView, _ space: CGFloat) -> SDAutoLayoutModel {
        return bottomSpaceToView(view, space)
    }
    
    @discardableResult
    public func leftTo(_ view: UIView, _ space: CGFloat) -> SDAutoLayoutModel {
        return leftSpaceToView(view, space)
    }
    
    @discardableResult
    public func rightTo(_ view: UIView, _ space: CGFloat) -> SDAutoLayoutModel {
        return rightSpaceToView(view, space)
    }
    
    /* 设置x、y、width、height、centerX、centerY 值 */
    @discardableResult
    public func x(is value: CGFloat) -> SDAutoLayoutModel {
        return xIs(value)
    }
    
    @discardableResult
    public func y(is value: CGFloat) -> SDAutoLayoutModel {
        return yIs(value)
    }
    
    @discardableResult
    public func width(is value: CGFloat) -> SDAutoLayoutModel {
        return widthIs(value)
    }
    
    @discardableResult
    public func height(is value: CGFloat) -> SDAutoLayoutModel {
        return heightIs(value)
    }
    
    @discardableResult
    public func centerX(is value: CGFloat) -> SDAutoLayoutModel {
        return centerXIs(value)
    }
    
    @discardableResult
    public func centerY(is value: CGFloat) -> SDAutoLayoutModel {
        return centerYIs(value)
    }
    
    /* 设置最大宽度和高度、最小宽度和高度 */
    @discardableResult
    public func maxWidth(_ value: CGFloat) -> SDAutoLayoutModel {
        return maxWidthIs(value)
    }
    
    @discardableResult
    public func maxHeight(_ value: CGFloat) -> SDAutoLayoutModel {
        return maxHeightIs(value)
    }
    
    @discardableResult
    public func minWidth(_ value: CGFloat) -> SDAutoLayoutModel {
        return minWidthIs(value)
    }
    
    @discardableResult
    public func minHeight(_ value: CGFloat) -> SDAutoLayoutModel {
        return minHeightIs(value)
    }
    
    /* 设置和某个参照view的边距相同 */
    @discardableResult
    public func leftEqualTo(_ view: UIView) -> SDAutoLayoutModel {
        return leftEqualToView(view)
    }
    
    @discardableResult
    public func rightEqualTo(_ view: UIView) -> SDAutoLayoutModel {
        return rightEqualToView(view)
    }
    
    @discardableResult
    public func topEqualTo(_ view: UIView) -> SDAutoLayoutModel {
        return topEqualToView(view)
    }
    
    @discardableResult
    public func bottomEqualTo(_ view: UIView) -> SDAutoLayoutModel {
        return bottomEqualToView(view)
    }
    
    @discardableResult
    public func centerXEqualTo(_ view: UIView) -> SDAutoLayoutModel {
        return centerXEqualToView(view)
    }
    
    @discardableResult
    public func centerYEqualTo(_ view: UIView) -> SDAutoLayoutModel {
        return centerYEqualToView(view)
    }
    
    /*  设置宽度或者高度等于参照view的多少倍 */
    @discardableResult
    public func widthRatioTo(_ view: UIView, _ value: CGFloat) -> SDAutoLayoutModel {
        return widthRatioToView(view, value)
    }
    
    @discardableResult
    public func heightRatioTo(_ view: UIView, _ value: CGFloat) -> SDAutoLayoutModel {
        return heightRatioToView(view, value)
    }
    
    @discardableResult
    public func autoHeight(_ ratio: CGFloat) -> SDAutoLayoutModel {
        return autoHeightRatio(ratio)
    }
    
    @discardableResult
    public func autoWidth(_ ratio: CGFloat) -> SDAutoLayoutModel {
        return autoWidthRatio(ratio)
    }
    
    @discardableResult
    public func isWidthEqualToHeight() -> SDAutoLayoutModel {
        return widthEqualToHeight()
    }
    
    @discardableResult
    public func isHeightEqualToWidth() -> SDAutoLayoutModel {
        return heightEqualToWidth()
    }
    
    /* 填充父view(快捷方法) */
    public func spaceToSuperViewIs(_ value: UIEdgeInsets) {
        spaceToSuperView(value)
    }
    
    @discardableResult
    public func offsetIs(_ value: CGFloat) -> SDAutoLayoutModel {
        return offset(value)
    }
    
    
}
