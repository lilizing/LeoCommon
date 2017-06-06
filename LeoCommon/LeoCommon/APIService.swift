//
//  APIService.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import Alamofire

open class APIService:APIDelegate {
    private var apis: [String: API] = [:]
    
    public init() {
    }
    
    public func api(_ basePath: String) -> API {
        guard self.apis[basePath] == nil else { return self.apis[basePath]! }
        let api = API(basePath: basePath)
        api.apiDelegate = self
        self.apis[basePath] = api
        return api
    }
    
    public func defaultHTTPHeaders() -> HTTPHeaders? {
        return nil
    }
}
