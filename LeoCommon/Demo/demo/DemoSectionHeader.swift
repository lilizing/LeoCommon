//
//  DemoSectionHeader.swift
//  CYZS
//
//  Created by 李理 on 2017/9/6.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DemoSectionHeader: FeedViewSectionHeaderOrFooter {
    private var label:UILabel!
    
    override func set() {
        let vm:DemoSectionHeaderViewModel? = self.viewModel as? DemoSectionHeaderViewModel
        self.label.text = vm?.text
    }
    
    override func bind() {
        
    }
    
    override func layout() {
        self.label = UILabel()
        self.label.backgroundColor = .orange
        self.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    override class func sizeThatFits(_ viewModel:FeedViewSectionHeaderOrFooterViewModel?, size: CGSize = .zero) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 100)
    }
}
