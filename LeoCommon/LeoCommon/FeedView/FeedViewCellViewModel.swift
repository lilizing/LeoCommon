//
//  FeedViewCellViewModel.swift
//  CYZS
//
//  Created by 李理 on 2017/9/4.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

import SnapKit
import ObjectMapper

public protocol FeedViewCellViewModelProtocol {
    //context用来传递一些上下文信息，可以用于区分返回不同的视图类型
    func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type
}

open class FeedViewCellViewModel:FeedViewCellViewModelProtocol {
    public init() {}
    
    open func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return FeedViewCell.self
    }
}

extension FeedViewCellViewModel: Equatable {
    open static func ==(lhs: FeedViewCellViewModel, rhs: FeedViewCellViewModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

