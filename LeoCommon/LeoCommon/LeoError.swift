//
//  ErrorExt.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/11.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import Alamofire

public enum LeoError:Error {
    
    public enum StorageSaveFailureReason {
        case unknown(desc: String)
        case notfound(key: String)
        case noReturnForAsync
        case encodeFailed(error: Error)
        case decodeFailed(error: Error)
    }
    
    public enum StorageEncodeFailureReason {
        case unknown(value: Any)
    }
    
    public enum StorageDecodeFailureReason {
        case unknown(value: Any)
    }
    
    case storageSaveFailured(reason: StorageSaveFailureReason)
    case storageEncodeFailured(reason: StorageEncodeFailureReason)
    case storageDecodeFailured(reason: StorageDecodeFailureReason)
    case unknown(desc: String)
}

extension LeoError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .storageSaveFailured(let reason):
            return reason.localizedDescription
        case .storageEncodeFailured(let reason):
            return reason.localizedDescription
        case .storageDecodeFailured(let reason):
            return reason.localizedDescription
        case .unknown(let desc):
            return "unknow error: \(desc)"
        }
    }
}

extension LeoError.StorageSaveFailureReason {
    var localizedDescription: String {
        switch self {
        case .unknown(let desc):
            return "unknow error: \(desc)"
        case .notfound(let key):
            return "not found for key: \(key)"
        case .noReturnForAsync():
            return "not return value for async restore"
        case .encodeFailed(let error):
            return "could not be save because of error: \(error.localizedDescription)"
        case .decodeFailed(let error):
            return "could not be restore because of error: \(error.localizedDescription)"
        }
    }
}

extension LeoError.StorageEncodeFailureReason {
    var localizedDescription: String {
        switch self {
        case .unknown(let value):
            return "encode failed for value: \(value)"
        }
    }
}

extension LeoError.StorageDecodeFailureReason {
    var localizedDescription: String {
        switch self {
        case .unknown(let value):
            return "decode failed for value: \(value)"
        }
    }
}
