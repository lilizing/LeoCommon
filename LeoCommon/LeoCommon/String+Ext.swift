//
//  String.ext.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/19.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift
import SwiftRichString

extension String {
    public subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return self.substring(with: startIndex..<endIndex)
        }
    }
}

@objc extension NSAttributedString {
    public func size(fixHeight:CGFloat) -> CGSize {
        return self.boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude, height: fixHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
    
    public func size(fixWidth:CGFloat) -> CGSize {
        return self.boundingRect(with: .init(width: fixWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
    
    @nonobjc static public func += (left: inout NSAttributedString, right: NSAttributedString) {
        let ns = left is NSMutableAttributedString ? (left as! NSMutableAttributedString) : NSMutableAttributedString(attributedString: left)
        ns.append(right)
        left = ns
    }
}

@objc extension NSString {
    public func size(font:UIFont, color:UIColor, fixHeight:CGFloat) -> CGSize {
        let sVal = self as String
        return sVal.size(font:font, color:color, fixHeight:fixHeight)
    }
    
    public func size(font:UIFont, color:UIColor, fixWidth:CGFloat) -> CGSize {
        let sVal = self as String
        return sVal.size(font:font, color:color, fixWidth:fixWidth)
    }
}

extension String {
    public func size(font:UIFont, color:UIColor, fixHeight:CGFloat) -> CGSize {
        return self.string(font:font, color:color, lineBreak:.byWordWrapping).size(fixHeight: fixHeight)
    }
    
    public func size(font:UIFont, color:UIColor, fixWidth:CGFloat) -> CGSize {
        return self.string(font:font, color:color, lineBreak:.byWordWrapping).size(fixWidth: fixWidth)
    }
}

@objc extension NSString {
    public func trim() -> String {
        let sVal = self as String
        return sVal.trimmingCharacters(in: .whitespaces)
    }
    
    public func len() -> Int {
        let sVal = self as String
        return sVal.len()
    }
}

extension String {
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    public func len() -> Int {
        return self.characters.count
    }
}

@objc extension NSString {
    public func string(bold:Bool, size:CGFloat, hex:String) -> NSMutableAttributedString {
        let sVal = self as String
        return sVal.string(font: UIFont.font(bold:bold, size:size), hex: hex)
    }
    
    public func string(bold:Bool, size:CGFloat, color:UIColor) -> NSMutableAttributedString {
        let sVal = self as String
        return sVal.string(font: UIFont.font(bold:bold, size:size), color: color)
    }
    
    public func string(font:UIFont, hex:String) -> NSMutableAttributedString {
        let sVal = self as String
        return sVal.string(font:font, hex:hex)
    }
    
    public func string(font:UIFont, color:UIColor) -> NSMutableAttributedString {
        let sVal = self as String
        return sVal.string(font:font, color:color)
    }
    
    public func string(font:UIFont, hex:String, lineBreak: NSLineBreakMode) -> NSMutableAttributedString {
        let sVal = self as String
        return sVal.string(font:font, hex:hex, lineBreak:lineBreak)
    }
    
    public func string(font:UIFont, color:UIColor, lineBreak: NSLineBreakMode) -> NSMutableAttributedString {
        let sVal = self as String
        return sVal.string(font:font, color:color, lineBreak:lineBreak)
    }
}

extension String {
    
    public func string(bold:Bool, size:CGFloat, hex:String) -> NSMutableAttributedString {
        return self.string(font: UIFont.font(bold:bold, size:size), hex: hex)
    }
    
    public func string(bold:Bool, size:CGFloat, color:UIColor) -> NSMutableAttributedString {
        return self.string(font: UIFont.font(bold:bold, size:size), color: color)
    }
    
    public func string(font:UIFont, hex:String) -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(font: font)
            style.color = UIColor(hex)
            style.lineBreak = .byTruncatingTail
        }
        return self.set(style: style)
    }
    
    public func string(font:UIFont, color:UIColor = .black) -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(font: font)
            style.color = color
            style.lineBreak = .byTruncatingTail
        }
        return self.set(style: style)
    }
    
    public func string(font:UIFont, hex:String, lineBreak: NSLineBreakMode) -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(font: font)
            style.color = UIColor(hex)
            style.lineBreak = lineBreak
        }
        return self.set(style: style)
    }
    
    public func string(font:UIFont, color:UIColor = .black, lineBreak: NSLineBreakMode) -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(font: font)
            style.color = color
            style.lineBreak = lineBreak
        }
        return self.set(style: style)
    }
}

extension String {
    public func string(name:String? = FontName.PingFangSC_Regular.rawValue, size:Int? = 15, hex:String? = "#000000") -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(name!, size: Float(size!))
            style.color = UIColor(hex!)
        }
        return self.set(style: style)
    }
    
    public func string(name:String? = FontName.PingFangSC_Regular.rawValue, size:Int? = 15, color:UIColor? = .black) -> NSMutableAttributedString {
        let style = Style.init { style in
            style.font = FontAttribute.init(name!, size: Float(size!))
            style.color = color!
        }
        return self.set(style: style)
    }
}
