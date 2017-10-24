//
// Created by 李理 on 2017/4/19.
// Copyright (c) 2017 李理. All rights reserved.
//

import Foundation

public func className<T>(_ type:T.Type) -> String {
    return "\(type)".components(separatedBy: ".").last!
}

extension URL {
    public subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
