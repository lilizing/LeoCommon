//
// Created by 李理 on 2017/4/19.
// Copyright (c) 2017 李理. All rights reserved.
//

import Foundation
import ReactiveSwift

public func className<T>(_ type:T.Type) -> String {
    return "\(type)".components(separatedBy: ".").last!
}

open class BaseObject {
    private let token = Lifetime.Token()
    public var lifetime: Lifetime {
        return Lifetime(token)
    }
    
    public init() {
        let type = String(describing: self).components(separatedBy: ".").last!
        self.lifetime.observeEnded {
            debugPrint("\(type) lifetime is ended")
        }
    }
}

extension Dictionary {
    public func string() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String.init(data: data, encoding: .utf8)
        }
        return nil
    }
}
