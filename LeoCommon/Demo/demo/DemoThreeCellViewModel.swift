//
//  DemoThreeCellViewModel.swift
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

class DemoThreeCellViewModel: FeedViewCellViewModel {
    var model:String?
    
    override func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return DemoThreeCell.self
    }
}
