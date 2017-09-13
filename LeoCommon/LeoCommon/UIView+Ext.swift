//
//  UIView+Ext.swift
//  CYZS
//
//  Created by 李理 on 2017/9/4.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

extension UIView {
    public func tapGesture() -> Observable<UITapGestureRecognizer> {
        let result = self.rx.tapGesture{ (gestureRecognizer, delegate) in
            delegate.simultaneousRecognitionPolicy = .never
        }.when(UIGestureRecognizerState.recognized)
        return result
    }
}

//protocol ReusableView: class {
//    static var reuseIdentifier: String { get }
//}
//
//extension ReusableView {
//    static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}
//
//extension UICollectionViewCell: ReusableView {
//}
