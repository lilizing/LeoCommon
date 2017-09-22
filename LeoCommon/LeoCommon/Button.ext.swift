//
//  Button.ext.swift
//  Pods
//
//  Created by 李理 on 2017/8/8.
//
//

import Foundation
import UIKit

extension UIButton {
    private struct AssociatedKeys {
        static var BUTTON_ENLARGE_TOP = "button.enlarge.top"
        static var BUTTON_ENLARGE_BOTTOM = "button.enlarge.bottom"
        static var BUTTON_ENLARGE_LEFT = "button.enlarge.left"
        static var BUTTON_ENLARGE_RIGHT = "button.enlarge.right"
    }
    
    public var enlargeTop: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BUTTON_ENLARGE_TOP) as? NSNumber
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.BUTTON_ENLARGE_TOP,
                    newValue as NSNumber?,
                    .OBJC_ASSOCIATION_RETAIN
                )
            }
        }
    }
    
    public var enlargeBottom: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BUTTON_ENLARGE_BOTTOM) as? NSNumber
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.BUTTON_ENLARGE_BOTTOM,
                    newValue as NSNumber?,
                    .OBJC_ASSOCIATION_RETAIN
                )
            }
        }
    }
    
    public var enlargeLeft: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BUTTON_ENLARGE_LEFT) as? NSNumber
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.BUTTON_ENLARGE_LEFT,
                    newValue as NSNumber?,
                    .OBJC_ASSOCIATION_RETAIN
                )
            }
        }
    }
    
    public var enlargeRight: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BUTTON_ENLARGE_RIGHT) as? NSNumber
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.BUTTON_ENLARGE_RIGHT,
                    newValue as NSNumber?,
                    .OBJC_ASSOCIATION_RETAIN
                )
            }
        }
    }
    
    public func setEnlarge(edge:UIEdgeInsets) {
        self.enlargeTop = NSNumber.init(value: Float(edge.top))
        self.enlargeBottom = NSNumber.init(value: Float(edge.bottom))
        self.enlargeLeft = NSNumber.init(value: Float(edge.left))
        self.enlargeRight = NSNumber.init(value: Float(edge.right))
    }
    
    public func enlargeRect() -> CGRect {
        var top:CGFloat = 0.0
        var bottom:CGFloat = 0.0
        var left:CGFloat = 0.0
        var right:CGFloat = 0.0
        
        if let t = self.enlargeTop?.floatValue {
            top = CGFloat(t)
        }
        if let t = self.enlargeBottom?.floatValue {
            bottom = CGFloat(t)
        }
        if let t = self.enlargeLeft?.floatValue {
            left = CGFloat(t)
        }
        if let t = self.enlargeRight?.floatValue {
            right = CGFloat(t)
        }
        
        return CGRect.init(x: self.bounds.origin.x - left, y: self.bounds.origin.y - top, width: self.bounds.size.width + left + right, height: self.bounds.size.height + top + bottom);
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.enlargeRect()
        if rect.equalTo(self.bounds) {
            return super.point(inside: point, with: event)
        }
        return (!self.isHidden && self.alpha > 0.01 && rect.contains(point)) ? true : false
    }
}
