//
//  LeoResult.swift
//  LeoCommon
//
//  Created by 李理 on 2017/6/5.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import Result

public typealias LeoAnyError = AnyError
public typealias LeoNoError = NoError
public typealias LeoResult<T> = Result<T, LeoAnyError>
