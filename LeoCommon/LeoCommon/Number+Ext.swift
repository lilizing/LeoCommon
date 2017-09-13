//
//  Number+Ext.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

infix operator ==~ : AssignmentPrecedence
public func ==~ (left: Double, right: Double) -> Bool {
    return fabs(left.distance(to: right)) <= 1e-6
}

public func ==~ (left: CGFloat, right: CGFloat) -> Bool {
    return fabs(left.distance(to: right)) <= 1e-6
}

infix operator !=~ : AssignmentPrecedence
public func !=~ (left: Double, right: Double) -> Bool {
    return !(left ==~ right)
}

public func !=~ (left: CGFloat, right: CGFloat) -> Bool {
    return !(left ==~ right)
}

infix operator <=~ : AssignmentPrecedence
public func <=~ (left: Double, right: Double) -> Bool {
    return (left ==~ right) || (left <~ right)
}

public func <=~ (left: CGFloat, right: CGFloat) -> Bool {
    return (left ==~ right) || (left <~ right)
}

infix operator >=~ : AssignmentPrecedence
public func >=~ (left: Double, right: Double) -> Bool {
    return (left ==~ right) || (left >~ right)
}

public func >=~ (left: CGFloat, right: CGFloat) -> Bool {
    return (left ==~ right) || (left >~ right)
}

infix operator <~ : AssignmentPrecedence
public func <~ (left: Double, right: Double) -> Bool {
    return left.distance(to: right) > 1e-6
}

public func <~ (left: CGFloat, right: CGFloat) -> Bool {
    return left.distance(to: right) > 1e-6
}

infix operator >~ : AssignmentPrecedence
public func >~ (left: Double, right: Double) -> Bool {
    return left.distance(to: right) < -1e-6
}

public func >~ (left: CGFloat, right: CGFloat) -> Bool {
    return left.distance(to: right) < -1e-6
}
