//
//  Cell.swift
//  Lottery
//
//  Created by 李理 on 2017/4/24.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit

public protocol CellProtocol {
    func initSubviews() -> Void
    func relayout() -> Void
    func set() -> Void
    func binding() -> Void
}

open class Cell<ViewModel>:UITableViewCell, CellProtocol {
    public var viewModel:ViewModel? {
        didSet {
            self.initSubviews()
            self.relayout()
            self.set()
            self.binding()
        }
    }
    
    open func initSubviews() -> Void {}
    open func relayout() -> Void {}
    open func set() -> Void {}
    open func binding() -> Void {}
}

open class CollectionCell<ViewModel>:UICollectionViewCell, CellProtocol {
    public var viewModel:ViewModel? {
        didSet {
            self.initSubviews()
            self.relayout()
            self.set()
            self.binding()
        }
    }
    
    open func initSubviews() -> Void {}
    open func relayout() -> Void {}
    open func set() -> Void {}
    open func binding() -> Void {}
}
