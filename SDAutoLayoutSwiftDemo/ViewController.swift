//
//  ViewController.swift
//  SDAutoLayoutSwiftDemo
//
//  Created by 李响 on 2018/9/29.
//  Copyright © 2018 gsd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var redView: UIView = {
        $0.backgroundColor = .red
        return $0
    } ( UIView() )
    
    private lazy var blueView: UIView = {
        $0.backgroundColor = .blue
        return $0
    } ( UIView() )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }

    private func setup() {
        
        view.addSubview(redView)
        view.addSubview(blueView)
    }
    
    private func setupLayout() {
        
        _ = redView.sd_layout()
            .topSpaceToView(view, 80)
            .leftSpaceToView(view, 10)
            .rightSpaceToView(view, 10)
            .heightIs(100)
        
        _ = blueView.sd_layout()
            .topSpaceToView(redView, 10)
            .leftSpaceToView(view, 10)
            .rightSpaceToView(view, 10)
            .heightIs(200)
    }
}
