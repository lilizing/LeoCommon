//
//  API.rac.swift
//  LeoCommon
//
//  Created by 李理 on 2017/6/14.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import ObjectMapper
import ReactiveSwift
import Alamofire

public extension API {
    public func action<T:BaseMappable>(_ type:T.Type, enabledIf: Property<Bool>,
                       url: String,
                       method: HTTPMethod = .get,
                       headers: HTTPHeaders? = nil,
                       timeoutInterval: TimeInterval? = 30,
                       cacheMaxAge: APICachePolicy = .server,
                       resultMap: @escaping ([String : Any]) -> (LeoResult<T>) = resultMap,
                       errorHandler: @escaping (LeoResult<T>) -> Void = { _ in }) -> Action<[String: Any], T, LeoAnyError> {
        return Action(enabledIf: enabledIf, { [weak self] params in
            return SignalProducer<T, LeoAnyError> { observer, disposable in
                if let sSelf = self {
                    let requestID = sSelf.fetch(url,
                                                method: method,
                                                parameters: params,
                                                headers: headers,
                                                timeoutInterval: timeoutInterval,
                                                cacheMaxAge: cacheMaxAge,
                                                resultMap: resultMap,
                                                errorHandler: errorHandler) { (result:LeoResult<T>) in
                                                    result.analysis(ifSuccess: { value in
                                                        observer.send(value: value)
                                                        observer.sendCompleted()
                                                    }, ifFailure: { error in
                                                        observer.send(error: error)
                                                    })
                    }
                    disposable += ActionDisposable(action: {
                        sSelf.cancel(requestID: requestID)
                    })
                }
            }
        })
    }

}
