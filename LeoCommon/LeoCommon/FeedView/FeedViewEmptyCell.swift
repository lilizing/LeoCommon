//
//  SYDEmptyCell.swift
//  CYZS
//
//  Created by 李理 on 2017/9/18.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

open class FeedViewEmptyCell:FeedViewCell {
    public var textLabel:UILabel!
    
    override open func set() {
        guard
            let vm = self.viewModel as? FeedViewEmptyCellViewModel
        else
        {
            return
        }
        
        self.textLabel.attributedText = vm.text.string(size: 14, hex: "#CCCCCC")
    }
    
    override open func bind() {}
    
    override open func layout() {
        self.textLabel = UILabel()
        self.contentView.addSubview(textLabel)
        self.textLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
    }
    
    override open class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        return size
    }
}
