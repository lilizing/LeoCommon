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

open class FeedViewCellViewModel:NSObject, FeedViewCellViewModelProtocol {
    public var staticsContext: [String: Any] = [:]
    
    public override init() {}
    
    open func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return FeedViewCell.self
    }
}
