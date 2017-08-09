//
//  API.rx.swift
//  LeoCommon
//
//  Created by 李理 on 2017/8/9.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Alamofire

extension Reactive where Base: API {
    
    public func fetch<T:BaseMappable>(_ type:T.Type,
                      url: String = "",
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      headers: HTTPHeaders? = nil,
                      timeoutInterval: TimeInterval? = 30,
                      cacheMaxAge: APICachePolicy = .server,
                      responseMap: @escaping ([String : Any]) -> (Result<T>) = responseMap,
                      errorHandler: @escaping (Result<T>) -> Void = { _ in }) -> Observable<T> {
        return Observable.create{ [weak api = self.base] observer in
            let requestID = api?.fetch(type,
                                       url: url,
                                       method: method,
                                       parameters: parameters,
                                       headers: headers,
                                       timeoutInterval: timeoutInterval,
                                       cacheMaxAge: cacheMaxAge,
                                       responseMap: responseMap,
                                       errorHandler: errorHandler) { (result:Result<T>) in
                                        if let error = result.error {
                                            observer.onError(error)
                                        } else {
                                            observer.onNext(result.value!)
                                            observer.onCompleted()
                                        }
            }
            
            func cancel() {
                api?.cancel(requestID: requestID ?? "")
            }
            
            return Disposables.create(with: cancel)
        }
    }
}
