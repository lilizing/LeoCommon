//
//  LeoView.swift
//  LeoComponent
//
//  Created by 李理 on 2017/5/29.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewProtocol {
    func initSubviews() -> Void
    func relayout() -> Void
    func set() -> Void
    func binding() -> Void
}

open class View<ViewModel>:UIView, ViewProtocol {
    
    public convenience init(viewModel:ViewModel) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.initSubviews()
        self.relayout()
        self.set()
        self.binding()
    }
    
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
