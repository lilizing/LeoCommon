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
        guard index > -1,
            index < self.viewControllers.count,
            self.viewControllers.count > 0,
            index != self.selectedIndex
            else { return }
        
        if !self.pageView.isMoving {
            if let fromVC = self.selectedViewController {
                fromVC.beginAppearanceTransition(false, animated: false)
                fromVC.endAppearanceTransition()
            }
            
            let toVC = self.viewControllers[index]
            if toVC.parent == nil {
                self.addChildViewController(toVC)
                toVC.didMove(toParentViewController: self)
            }
            toVC.beginAppearanceTransition(true, animated: false)
            toVC.endAppearanceTransition()
            self.selectedViewController = toVC
        }
        
        self.pageView.show(at: index)
    }
    
    public func removeAll() {
        for vc in self.viewControllers {
            vc.willMove(toParentViewController: nil)
            vc.removeFromParentViewController()
            vc.beginAppearanceTransition(false, animated: false)
            vc.endAppearanceTransition()
        }
        self.selectedViewController = nil
        self.viewControllers.removeAll()
        
        self.pageView.removeAll()
    }
    
    public func remove(at index:Int) {
        guard index > -1, index < self.viewControllers.count, self.viewControllers.count > 0 else { return }
        
        let removeVC = self.viewControllers[index]
        if let _ = removeVC.parent {
            removeVC.willMove(toParentViewController: nil)
            removeVC.removeFromParentViewController()
            removeVC.beginAppearanceTransition(false, animated: false)
            removeVC.endAppearanceTransition()
        }
        self.viewControllers.remove(at: index)
        
        self.pageView.remove(at: index)
    }
    
    public func insert(newElement: UIViewController, at: Int) {
        self.insert(contentsOf: [newElement], at: at)
    }
    
    public func insert(contentsOf: [UIViewController], at: Int) {
        guard at <= viewControllers.count, contentsOf.count > 0 else { return }
        
        self.viewControllers.insert(contentsOf: contentsOf, at: at)
        
        var views: [UIView] = []
        for vc in contentsOf {
            views.append(vc.view)
        }
        self.pageView.insert(contentsOf: views, at: at)
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
    public var disposeBag = DisposeBag()
    
    public var viewControllers:[UIViewController] = []
    public var selectedViewController:UIViewController!
    
    public var selectedIndexObservable:Variable<Int> {
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
    
    private var pgView = PageView()
    public var pageView:PageView {
        get {
            return self.pgView
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageView.viewController = self
        self.view.addSubview(self.pageView)
        self.pageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    deinit {
        Utils.debugLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension PageVC {
    func startMoving(index:Int) {}
    
    func endMoving(_ scrollView: UIScrollView) {
        guard self.pageView.isMoving else { return }
        
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        
        self.selectedViewController = self.viewControllers[self.pageView.selectedIndex];
        let toViewController = self.viewControllers[self.pageView.toIndex];
        
        if toViewController.parent == nil {
            self.addChildViewController(toViewController)
            toViewController.didMove(toParentViewController: self)
        }
        
        self.selectedViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
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
