//
//  DemoSectionHeaderViewModel.swift
//  CYZS
//
//  Created by 李理 on 2017/9/6.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DemoSectionHeaderViewModel:FeedViewSectionHeaderOrFooterViewModel {
    var text:String?
    
    func sectionClass(_ context:Dictionary<String, Any>?) -> FeedViewSectionHeaderOrFooter.Type {
        return DemoSectionHeader.self
    }
}
