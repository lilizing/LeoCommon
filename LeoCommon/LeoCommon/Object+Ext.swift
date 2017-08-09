//
// Created by 李理 on 2017/4/19.
// Copyright (c) 2017 李理. All rights reserved.
//

import Foundation

public func className<T>(_ type:T.Type) -> String {
    return "\(type)".components(separatedBy: ".").last!
}
