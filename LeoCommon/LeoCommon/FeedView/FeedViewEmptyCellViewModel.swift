//
//  SYDEmptyCellViewModel.swift
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

open class FeedViewEmptyCellViewModel:FeedViewCellViewModel {
    public var text:String = "无数据"
    
    override open func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return FeedViewEmptyCell.self
    }
}
