//
//  PageView+Scroll.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ObjectMapper

extension FeedViewForPage {
    
    func startMoving(index:Int) {
        self.dataSource.isMoving = true;
        if let vc = self.dataSource.viewController {
            vc.startMoving(index: index)
        }
    }
    
    func endMoving(_ scrollView:UIScrollView) {
        if let vc = self.dataSource.viewController {
        
            vc.endMoving(scrollView)
            
            return
        }
        
        guard self.dataSource.isMoving else { return }
        
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        
        if (self.dataSource.toIndex > self.dataSource.currentIndex) {
            if (offsetX >=~ CGFloat(self.dataSource.toIndex) * contentWidth) {
                Utils.debugLog("[翻页 - 向右] - 成功");
                
                self.dataSource.currentIndex = self.dataSource.toIndex;
            } else { //回弹
                Utils.debugLog("[翻页 - 向右] - 失败，回弹");
            }
        } else {
            if (offsetX <=~ CGFloat(self.dataSource.toIndex) * contentWidth) {
                Utils.debugLog("[翻页 - 向左] - 成功");
                
                self.dataSource.currentIndex = self.dataSource.toIndex;
            } else { //回弹
                Utils.debugLog("[翻页 - 向左] - 失败，回弹");
            }
        }
        
        self.dataSource.toIndex = -1;
        self.dataSource.isMoving = false;
    }
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        guard scrollView.isDragging else { return }
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        if (offsetX < 0 || offsetX > CGFloat(self.dataSource.items.count - 1) * contentWidth) {
            return
        }
        if (self.dataSource.toIndex > -1) {
            return
        }
        
        if (offsetX >=~ CGFloat(self.dataSource.currentIndex) * contentWidth) {
            self.dataSource.toIndex = self.dataSource.currentIndex + 1;
        } else {
            self.dataSource.toIndex = self.dataSource.currentIndex - 1;
        }
        if (self.dataSource.toIndex > -1 && self.dataSource.toIndex < self.dataSource.items.count) {
            self.startMoving(index: self.dataSource.toIndex)
        }
    }
    
    override public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        if !decelerate {
            self.endMoving(scrollView)
        }
    }
    
    override public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        self.endMoving(scrollView)
    }
    
    override public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        self.endMoving(scrollView)
    }
}

