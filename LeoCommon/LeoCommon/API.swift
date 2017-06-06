//
//  API.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import ReactiveSwift
import LeoCommon

var API_MANAGERS:Dictionary<String, Alamofire.SessionManager> = [:]
var API_REQUESTS:Dictionary<String, Alamofire.DataRequest> = [:]

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias Parameters = Alamofire.Parameters
public typealias HTTPHeaders = Alamofire.HTTPHeaders

private func resultMap<T:BaseMappable>(json:[String: Any]) -> LeoResult<T> {
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let JSONString = String(data: data, encoding: .utf8)
        let value:T = T(JSONString: JSONString!)!
        return .success(value)
    } catch {
        return .failure(LeoAnyError(error))
    }
}

public protocol APIDelegate:class {
    func defaultHTTPHeaders() -> HTTPHeaders?
}

open class API:Alamofire.SessionManager {
    
    public let basePath:String
    
    private var manager:Alamofire.SessionManager?
    
    public weak var apiDelegate:APIDelegate?
    
    private let queue = DispatchQueue(label: "com.leo.api.queue")
    
    public init(basePath:String) {
        self.basePath = basePath
        super.init()
    }
    
    private func createManager() -> Alamofire.SessionManager {
        if self.manager == nil {
            if API_MANAGERS[self.basePath] != nil {
                self.manager = API_MANAGERS[self.basePath]!
            } else {
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 30
                configuration.httpAdditionalHeaders = self.buildHeaders()
                self.manager = Alamofire.SessionManager(configuration: configuration)
                API_MANAGERS[basePath] = self.manager
            }
        }
        return self.manager!
    }
    
    private func buildHeaders(_ headers:HTTPHeaders? = nil) -> HTTPHeaders {
        var httpHeaders = SessionManager.defaultHTTPHeaders
        if let defaultHeaders = self.apiDelegate!.defaultHTTPHeaders() {
            for (key, value) in defaultHeaders {
                httpHeaders[key] = value
            }
        }
        
        guard headers != nil else {
            return httpHeaders
        }
        for (key, value) in headers! {
            httpHeaders[key] = value
        }
        return httpHeaders
    }
    
    public func fetch<T:BaseMappable>(_ url: String,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      headers: HTTPHeaders? = nil,
                      timeoutInterval: TimeInterval? = 30,
                      resultMap: @escaping ([String : Any]) -> (LeoResult<T>),
                      errorHandler: @escaping (LeoResult<T>) -> Void = { _ in },
                      callback: @escaping (LeoResult<T>) -> Void = { _ in }) -> String {
        
        var tUrl = url
        var tParams = parameters
        if let params = parameters {
            for (key, value) in params {
                let range = tUrl.range(of: "{\(key)}")
                if range != nil {
                    tUrl.replaceSubrange(range!, with: value as! String)
                    tParams!.removeValue(forKey: key)
                }
            }
        }
        
        let absURL = self.basePath + tUrl
        
        var request:URLRequest = URLRequest(url: URL(string: absURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.buildHeaders(headers)
        let requestID = UUID().uuidString
        do {
            let encodedURLRequest = try URLEncoding.default.encode(request, with: tParams)
            let task = self.createManager().request(encodedURLRequest).responseJSON(completionHandler: { response in
                var result:LeoResult<T>? = nil
                if let error = response.error {
                    result = .failure(LeoAnyError(error))
                } else {
                    result = resultMap(response.value! as! [String : Any])
                }
                errorHandler(result!)
                callback(result!)
            })
            self.queue.sync {
                API_REQUESTS[requestID] = task
            }
        } catch {
            callback(.failure(LeoAnyError(error)))
        }
        return requestID
    }
    
    public func action<T:BaseMappable>(_ type:T.Type, enabledIf: Property<Bool>,
                       url: String,
                       method: HTTPMethod = .get,
                       headers: HTTPHeaders? = nil,
                       timeoutInterval: TimeInterval? = 30,
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
    
    public func cancel(requestID:String) {
        if let request = API_REQUESTS[requestID] {
            request.cancel()
            _ = self.queue.sync {
                API_REQUESTS.removeValue(forKey: requestID)
            }
        }
    }
    
    deinit {
        debugPrint("API deinit")
    }
}
