//
//  String.ext.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/19.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import HEXColor
import SwiftRichString

extension String {
    public func string(name:String? = FontName.HelveticaNeue.rawValue, size:Int? = 15, hex:String? = "#000000") -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(name!, size: Float(size!))
            style.color = UIColor(hex!)
        }
        return self.set(style: style)
    }
    
    public func string(name:String? = FontName.HelveticaNeue.rawValue, size:Int? = 15, color:UIColor? = .black) -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(name!, size: Float(size!))
            style.color = color!
        }
        return self.set(style: style)
    }
}

extension NSAttributedString {
    static public func += (left: inout NSAttributedString, right: NSAttributedString) {
        let ns = left is NSMutableAttributedString ? (left as! NSMutableAttributedString) : NSMutableAttributedString(attributedString: left)
        ns.append(right)
        left = ns
    }
}
