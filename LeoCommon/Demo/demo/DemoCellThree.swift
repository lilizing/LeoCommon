//
//  DemoCellThree.swift
//  CYZS
//
//  Created by 李理 on 2017/9/7.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DemoThreeCell:FeedViewCell {
    private var label:UILabel!
    
    override func set() {
        let vm:DemoThreeCellViewModel? = self.viewModel as? DemoThreeCellViewModel
        self.label.text = vm?.model
    }
    
    override func bind() {
        
    }
    
    override func layout() {
        self.label = UILabel()
        self.label.backgroundColor = .blue
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.edges)
        }
    }
    
    override class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        let y = arc4random() % UInt32(300) + UInt32(100)
        return CGSize.init(width: (SCREEN_WIDTH - 5) / 2, height: CGFloat(y))
    }
}
