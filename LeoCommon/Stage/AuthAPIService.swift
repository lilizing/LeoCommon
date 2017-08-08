//
//  AuthAPI.swift
//  Lottery
//
//  Created by 李理 on 2017/4/13.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import Result
import ObjectMapper
import ReactiveSwift

class DemoAPIResponse<Model: Mappable>: Mappable {
    var status: Int?
    var data: Model?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
}

class DemoAPIArrayResponse<Model: Mappable>: Mappable {
    var status: Int?
    var data: [Model]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
}

class DemoModel: Mappable {
    var expire: Int?
    var accessToken: String?
    var refreshToken: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        expire <- map["expire"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
}

class DemoAPIService: APIService {
    
    public static let shared: DemoAPIService = DemoAPIService()
    public let api:API = API(basePath: "")
    
    private override init() {
        super.init()
        self.api.apiDelegate = self
    }
    
    func demoAction(_ enabledIf: Property<Bool>) -> Action<[String: Any], DemoAPIResponse<DemoModel>, AnyError> {
        return self.api.action(DemoAPIResponse<DemoModel>.self, enabledIf: enabledIf, url: "/api/v1/auth/login", method: .post)
    }
    
    deinit {
        debugPrint("AuthAPIService deinit")
    }
}
