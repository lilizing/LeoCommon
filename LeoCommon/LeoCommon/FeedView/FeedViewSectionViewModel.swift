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

protocol FeedViewSectionHeaderOrFooterViewModel {
    func sectionClass(_ context:Dictionary<String, Any>?) -> FeedViewSectionHeaderOrFooter.Type
}

class FeedViewSectionViewModel {
    var columnCount:Int = 1
    var sectionInset:UIEdgeInsets = .zero
    var minimumInteritemSpacing:CGFloat = 0
    var minimumLineSpacing:CGFloat = 0
    
    var header:FeedViewSectionHeaderOrFooterViewModel?
    var footer:FeedViewSectionHeaderOrFooterViewModel?
    var items:[FeedViewCellViewModel] = []
    
    init(header:FeedViewSectionHeaderOrFooterViewModel? = nil,
         footer:FeedViewSectionHeaderOrFooterViewModel? = nil,
         items:[FeedViewCellViewModel] = []) {
        self.header = header
        self.footer = footer
        self.items.append(contentsOf: items)
    }
}

