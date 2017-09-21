//
//  FeedView+Scroll.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/21.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension FeedView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.didScrollSignal.onNext(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.didEndDraggingSignal.onNext((scrollView, decelerate))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.didEndDeceleratingSignal.onNext(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.didEndScrollingAnimation.onNext(scrollView)
    }
}
