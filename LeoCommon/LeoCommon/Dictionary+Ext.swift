//
//  Dictionary.ext.swift
//  LeoCommon
//
//  Created by 李理 on 2017/8/8.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

extension Dictionary {
    public func string() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            return String.init(data: data, encoding: .utf8)
        }
        return nil
    }
}
