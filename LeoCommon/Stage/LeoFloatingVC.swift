//
//  LeoFloatingVC.swift
//  Ping
//
//  Created by 李理 on 2017/5/31.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Presentr

open class LeoFloatingVC:UIViewController {
    var disposable:Disposable?
    
    public func show(container: UIViewController,
              presenter:Presentr,
              keep: TimeInterval,
              animated: Bool,
              showCompletion: (() -> Void)? = nil,
              hideCompletion: (() -> Void)? = nil) {
        container.customPresentViewController(presenter, viewController: self, animated: animated, completion: showCompletion)
        if keep > 0 {
            self.disposable = QueueScheduler().schedule(after: Date.init(timeIntervalSinceNow: keep)) { [weak self] in
                UIScheduler().schedule {
                    if let sSelf = self {
                        sSelf.dismiss(animated: animated, completion: hideCompletion)
                    }
                }
            }
        }
    }
    
    public func hide(animated: Bool, completion: (() -> Void)?) {
        self.disposable?.dispose()
        self.presentingViewController?.dismiss(animated: animated, completion: completion)
    }
}
