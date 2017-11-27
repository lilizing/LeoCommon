//
//  UIFont+Ext.swift
//  LeoCommon
//
//  Created by 李理 on 2017/10/24.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import SwiftRichString

@objc public enum UIFontWeightType:Int {
    case regular
    case medium
    case semibold
}

@objc extension UIFont {
    public class func font(bold: Bool = false, size: CGFloat) -> UIFont {
        if #available(iOS 9, *) {
            return UIFont.init(name: bold ? FontName.PingFangSC_Medium.rawValue : FontName.PingFangSC_Regular.rawValue, size: size)!
        } else {
            return bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }
    }
    
    public class func font(weight: UIFontWeightType = .regular, size: CGFloat) -> UIFont {
        if #available(iOS 9, *) {
            var value = FontName.PingFangSC_Regular.rawValue
            if weight == .medium {
                value = FontName.PingFangSC_Medium.rawValue
            } else if weight == .semibold {
                value = FontName.PingFangSC_Semibold.rawValue
            }
            return UIFont.init(name: value, size: size)!
        } else {
            return weight == .regular ? UIFont.systemFont(ofSize: size) : UIFont.boldSystemFont(ofSize: size)
        }
    }
}

