//
//  FeedViewSectionViewModel.swift
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

public protocol FeedViewSectionHeaderOrFooterViewModel {
    func sectionClass(_ context:Dictionary<String, Any>?) -> FeedViewSectionHeaderOrFooter.Type
}

open class FeedViewSectionViewModel:NSObject {
    public var columnCount:Int = 1
    public var sectionInset:UIEdgeInsets = .zero
    public var minimumInteritemSpacing:CGFloat = 0
    public var minimumLineSpacing:CGFloat = 0
    public var headerSticky:Bool = true //是否固定头部
    
    public var header:FeedViewSectionHeaderOrFooterViewModel?
    public var footer:FeedViewSectionHeaderOrFooterViewModel?
    public var items:[FeedViewCellViewModel] = []
    
    public init(header:FeedViewSectionHeaderOrFooterViewModel? = nil,
                footer:FeedViewSectionHeaderOrFooterViewModel? = nil,
                items:[FeedViewCellViewModel] = []) {
        self.header = header
        self.footer = footer
        self.items.append(contentsOf: items)
    }
    
    deinit {
        Utils.debugLog("【内存释放】\(String(describing: self)) dealloc")
    }
}
