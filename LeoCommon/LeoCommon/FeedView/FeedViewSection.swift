//
//  FeedViewCellHeader.swift
//  CYZS
//
//  Created by 李理 on 2017/9/5.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

import SnapKit
import ObjectMapper

protocol FeedViewSectionHeaderOrFooterProtocol {
    var viewModel: FeedViewSectionHeaderOrFooterViewModel? { get set }
    var disposeBag: DisposeBag { get set }
    
    func set()
    func bind()
    func layout()
}

class FeedViewSectionHeaderOrFooter:UICollectionReusableView, FeedViewSectionHeaderOrFooterProtocol {

    var disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: FeedViewSectionHeaderOrFooterViewModel? {
        didSet {
            guard self.viewModel != nil else { return }
            self.set()
            self.bind()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set() {}
    func bind() {}
    func layout() {}
    
    class func sizeThatFits(_ viewModel:FeedViewSectionHeaderOrFooterViewModel?, size: CGSize = .zero) -> CGSize {
        return .zero
    }
}
