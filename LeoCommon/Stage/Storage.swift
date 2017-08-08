//
//  Storage.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/11.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import Result

public typealias StorageCallBack = (Result<Any, LeoError>) -> Void
public typealias StorageEncode = (Any) -> Result<Any, LeoError>
public typealias StorageDecode = (Any) -> Result<Any, LeoError>

final public class Storage {

    public static let shared: Storage = Storage()

    private init() { }
    
    let queue = DispatchQueue(label: "com.leo.common.localstorage")
    
    public func save(_ value:Any, forKey:String, async:Bool, encode:@escaping StorageEncode, callback: @escaping StorageCallBack) -> Void {
        if async {
            queue.async {
                let encodeValue = encode(value)
                encodeValue.analysis(ifSuccess: { data in
                    UserDefaults.standard.setValue(data, forKey: forKey)
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                        callback(.success(value))
                    }
                }, ifFailure: { error in
                    callback(.failure(.storageSaveFailured(reason: .encodeFailed(error: error))))
                })
            }
        } else {
            let encodeValue = encode(value)
            encodeValue.analysis(ifSuccess: { data in
                UserDefaults.standard.setValue(data, forKey: forKey)
                UserDefaults.standard.synchronize()
                callback(.success(value))
            }, ifFailure: { error in
                callback(.failure(.storageSaveFailured(reason: .encodeFailed(error: error))))
            })
        }
    }
    
    public func save(_ value:Any, forKey:String, async:Bool, callback: @escaping StorageCallBack) -> Void {
        self.save(value, forKey: forKey, async: async, encode: { (value) -> Result<Any, LeoError> in
            return .success(value)
        }, callback: callback)
    }
    
    public func save(_ value:Any, forKey:String, async:Bool) -> Void {
        self.save(value, forKey: forKey, async: async, callback: { (result) -> Void in
            result.analysis(ifSuccess: { value in
                debugPrint("save value success for key: \(forKey)")
            }, ifFailure: { error in
                debugPrint("save value failure for key: \(forKey), error: \(error.errorDescription!)")
            })
        })
    }
    
    public func save(_ value:Any, forKey:String) -> Void {
        self.save(value, forKey: forKey, async: false)
    }
    
    public func value(_ forKey:String, async:Bool, decode:@escaping StorageDecode, callback: @escaping StorageCallBack) -> Result<Any, LeoError> {
        if async {
            queue.async {
                let data = UserDefaults.standard.value(forKey: forKey)
                if data != nil {
                    let decodeValue = decode(data!)
                    DispatchQueue.main.async {
                        decodeValue.analysis(ifSuccess: { value in
                            callback(.success(value))
                        }, ifFailure: { error in
                            callback(.failure(.storageSaveFailured(reason: .decodeFailed(error: error))))
                        })
                    }
                } else {
                    callback(.failure(.storageSaveFailured(reason:.notfound(key: forKey))))
                }
            }
            return Result<Any, LeoError>.failure(.storageSaveFailured(reason:.noReturnForAsync))
        } else {
            let data = UserDefaults.standard.value(forKey: forKey)
            if data != nil {
                let decodeValue = decode(data!)
                decodeValue.analysis(ifSuccess: { value in
                    callback(.success(value))
                }, ifFailure: { error in
                    callback(.failure(.storageSaveFailured(reason: .decodeFailed(error: error))))
                })
                return decodeValue
            } else {
                let result = Result<Any, LeoError>.failure(.storageSaveFailured(reason:.notfound(key: forKey)))
                callback(result)
                return result
            }
        }
    }
    
    public func value(_ forKey:String, async:Bool, callback: @escaping StorageCallBack) -> Result<Any, LeoError> {
        return self.value(forKey, async: async, decode: { (data) -> Result<Any, LeoError> in
            return .success(data)
        }, callback: callback)
    }

    public func value(_ forKey:String) -> Result<Any, LeoError> {
        return self.value(forKey, async: false, callback: { (result) -> Void in
            result.analysis(ifSuccess: { value in
                debugPrint("restore value success for key: \(forKey), value: \(value)")
            }, ifFailure: { error in
                debugPrint("restore value failure for key: \(forKey), error: \(error.errorDescription!)")
            })
        })
    }
}
