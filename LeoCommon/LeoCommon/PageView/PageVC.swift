//
//  PageVC.swift
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

public extension PageVC {
    public func show(at index:Int) {
        guard index < self.viewControllers.count && self.viewControllers.count > 1 else { return }
        
        let toVC = self.viewControllers[index]
        let flag = toVC.parent == nil
        
        let fromVC = self.viewControllers[self.selectedIndex]
        fromVC.beginAppearanceTransition(false, animated: true)
        
        if flag {
            self.addChildViewController(toVC)
        }
        
        self.pageView.show(at: index)
        
        if flag {
            toVC.didMove(toParentViewController: self)
        }
        
        toVC.beginAppearanceTransition(true, animated: true)
        fromVC.endAppearanceTransition()
        toVC.endAppearanceTransition()
    }
    
    public func remove(at index:Int) {
        guard index < self.viewControllers.count && self.viewControllers.count > 0 else { return }
        
        let removeVC = self.viewControllers[index]
        let flag = removeVC.parent == nil
        
        let currentIndex = self.selectedIndex
        var nextIndex = currentIndex
        
        if (index <= currentIndex) {
            nextIndex -= 1;
        }
        
        var nextVC:UIViewController?
        if nextIndex > -1 {
            nextVC = self.viewControllers[nextIndex]
        }
        
        var nextFlag = false
        
        if !flag {
            if index == currentIndex {
                removeVC.willMove(toParentViewController: nil)
                removeVC.beginAppearanceTransition(false, animated: true)
                if let vc = nextVC {
                    if vc.parent == nil {
                        nextFlag = true
                        self.addChildViewController(vc)
                    }
                }
            }
        }
        
        self.pageView.remove(at: index)
        
        if !flag {
            if index == currentIndex {
                removeVC.endAppearanceTransition()
            }
            removeVC.removeFromParentViewController()
        }
        
        if let vc = nextVC {
            if nextFlag {
                vc.didMove(toParentViewController: self)
            }
            vc.beginAppearanceTransition(true, animated: true)
            vc.endAppearanceTransition()
        }
        
        self.viewControllers.remove(at: index)
    }
    
    public func insert(newElement: UIViewController, at: Int) {
        guard at <= viewControllers.count else { return }
        
        let flag = self.viewControllers.count == 0
        
        self.viewControllers.insert(newElement, at: at)
        
        if flag {
            self.addChildViewController(newElement)
        }
        
        self.pageView.insert(newElement: newElement.view, at: at)
        
        if flag {
            newElement.didMove(toParentViewController: self)
            newElement.beginAppearanceTransition(true, animated: true)
            newElement.endAppearanceTransition()
        }
    }
    
    public func insert(contentsOf: [UIViewController], at: Int) {
        guard at <= viewControllers.count, contentsOf.count > 0 else { return }
        
        let flag = self.viewControllers.count == 0
        
        if flag {
            self.addChildViewController(contentsOf[0])
        }
        
        self.viewControllers.insert(contentsOf: contentsOf, at: at)
        
        var views: [UIView] = []
        for vc in contentsOf {
            views.append(vc.view)
        }
        
        self.pageView.insert(contentsOf: views, at: at)
        
        if flag {
            contentsOf[0].didMove(toParentViewController: self)
            contentsOf[0].beginAppearanceTransition(true, animated: true)
            contentsOf[0].endAppearanceTransition()
        }
    }
}

extension PageVC {
    override open var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    override open func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}

open class PageVC:UIViewController {
    var viewControllers:[UIViewController] = []
    var selectedViewController:UIViewController!
    
    var selectedIndexObservable:Variable<Int> {
        get {
            return self.pageView.selectedIndexObservable
        }
    }
    
    var selectedIndex:Int {
        get {
            return self.pageView.selectedIndex
        }
        set {
            self.pageView.selectedIndex = newValue
        }
    }
    
    var isMoving:Bool {
        get {
            return self.pageView.isMoving
        }
        set {
            self.pageView.isMoving = newValue
        }
    }
    
    var pageView:PageView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageView = PageView()
        self.pageView.viewController = self
        self.view.addSubview(self.pageView)
        self.pageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func startMoving(index:Int) {
        self.selectedViewController = self.viewControllers[self.pageView.selectedIndex];
        let toViewController = self.viewControllers[index];
        
        if toViewController.parent == nil {
            self.addChildViewController(toViewController)
            toViewController.didMove(toParentViewController: self)
        }
        
        self.selectedViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
    }
    
    func endMoving(_ scrollView: UIScrollView) {
        guard self.pageView.isMoving else { return }
        
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        
        let toViewController = self.viewControllers[self.pageView.toIndex];
        
        if (self.pageView.toIndex > self.pageView.selectedIndex) {
            if (offsetX >=~ CGFloat(self.pageView.toIndex) * contentWidth) {
                
                Utils.debugLog("[翻页 - 向右] - 成功");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                self.selectedViewController = toViewController
                
                
                self.pageView.selectedIndex = self.pageView.toIndex;
            } else { //回弹
                
                Utils.debugLog("[翻页 - 向右] - 失败，回弹");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                toViewController.beginAppearanceTransition(false, animated: true)
                self.selectedViewController.beginAppearanceTransition(true, animated: true)
                
                toViewController.endAppearanceTransition()
                self.selectedViewController.endAppearanceTransition()
                
            }
        } else {
            if (offsetX <=~ CGFloat(self.pageView.toIndex) * contentWidth) {
                
                Utils.debugLog("[翻页 - 向左] - 成功");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                self.selectedViewController = toViewController
                
                self.pageView.selectedIndex = self.pageView.toIndex;
            } else { //回弹
                
                Utils.debugLog("[翻页 - 向左] - 失败，回弹");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                toViewController.beginAppearanceTransition(false, animated: true)
                self.selectedViewController.beginAppearanceTransition(true, animated: true)
                
                toViewController.endAppearanceTransition()
                self.selectedViewController.endAppearanceTransition()
            }
        }
        
        self.pageView.toIndex = -1;
        self.pageView.isMoving = false;
    }
}
