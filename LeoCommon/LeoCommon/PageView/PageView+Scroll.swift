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
        
        if (self.dataSource.toIndex > self.dataSource.selectedIndex) {
            if (offsetX >=~ CGFloat(self.dataSource.toIndex) * contentWidth) {
                Utils.debugLog("[翻页 - 向右] - 成功");
                
                self.dataSource.selectedIndex = self.dataSource.toIndex;
            } else { //回弹
                Utils.debugLog("[翻页 - 向右] - 失败，回弹");
            }
        } else {
            if (offsetX <=~ CGFloat(self.dataSource.toIndex) * contentWidth) {
                Utils.debugLog("[翻页 - 向左] - 成功");
                
                self.dataSource.selectedIndex = self.dataSource.toIndex;
            } else { //回弹
                Utils.debugLog("[翻页 - 向左] - 失败，回弹");
            }
        }
        
        self.dataSource.toIndex = -1;
        self.dataSource.isMoving = false;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        if (offsetX < 0 || offsetX > CGFloat(self.dataSource.items.count - 1) * contentWidth) {
            return
        }
        if (self.dataSource.toIndex > -1) {
            return
        }
        
        if (offsetX >=~ CGFloat(self.dataSource.selectedIndex) * contentWidth) {
            self.dataSource.toIndex = self.dataSource.selectedIndex + 1;
        } else {
            self.dataSource.toIndex = self.dataSource.selectedIndex - 1;
        }
        if (self.dataSource.toIndex > -1 && self.dataSource.toIndex < self.dataSource.items.count) {
            self.startMoving(index: self.dataSource.toIndex)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.endMoving(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.endMoving(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.endMoving(scrollView)
    }
}
