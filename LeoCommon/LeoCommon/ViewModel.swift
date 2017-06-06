//
//  ViewModel.swift
//  Lottery
//
//  Created by 李理 on 2017/4/23.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ViewModelProtocol {
    func set()
    func binding()
}

open class ViewModel<Model>:ViewModelProtocol {
    public var model: Model
    
    public init(model: Model) {
        self.model = model
        
        self.set()
        self.binding()
    }
    
    open func set() {}
    open func binding() {}
}
