//
//  File.swift
//  CYZS
//
//  Created by 李理 on 2017/8/24.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

import SnapKit
import ObjectMapper

protocol FeedViewCellProtocol {
    var viewModel: FeedViewCellViewModelProtocol? { get set }
    var disposeBag: DisposeBag { get set }
    
    func set()
    func bind()
    func layout()
    
}

class FeedViewCell: UICollectionViewCell, FeedViewCellProtocol {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: FeedViewCellViewModelProtocol? {
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
    
    class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        return .zero
    }
}
