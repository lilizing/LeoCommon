//
//  PageVC.swift
//  Lottery
//
//  Created by 李理 on 2017/5/19.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

open class PageVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public var headerView:PageHeaderView = PageHeaderView()
    public var containerVC:UIPageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    public var selectedIndex:MutableProperty<Int> = MutableProperty(0)
    
    public var disposable:Disposable?
    
    public var headerViewEdge:UIEdgeInsets = .zero
    public var extendedLayoutToHeader:Bool = false
    
    public var pagesViewControllers: [UIViewController] = [] {
        didSet {
            self.containerVC.setViewControllers([self.pagesViewControllers[0]], direction: .forward, animated: false, completion: nil)
            self.binding()
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerVC.dataSource = self
        self.containerVC.delegate = self
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(self.headerViewEdge.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(40)
        }
        
        self.addChildViewController(self.containerVC)
        self.containerVC.didMove(toParentViewController: self)
        self.view.insertSubview(self.containerVC.view, belowSubview: self.headerView)
        self.containerVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.extendedLayoutToHeader ? self.view.snp.top : self.headerView.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    public convenience init(pagesViewControllers:[UIViewController], headerItems:[PageHeaderItem]) {
        self.init()
        self.headerView.items = headerItems
        self.pagesViewControllers = pagesViewControllers
    }
    
    public func binding() {
        self.disposable?.dispose()
        self.disposable = self.headerView.selectedIndex.producer.take(during: self.reactive.lifetime).skipRepeats().startWithValues { (value) in
            self.selectedIndex.value = value
            
            let currentVC = self.containerVC.viewControllers![0]
            let index = self.pagesViewControllers.index(of: currentVC)!
            if index != value {
                self.containerVC.setViewControllers([self.pagesViewControllers[value]], direction: value > index ? .forward : .reverse, animated: true, completion: nil)
            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        self.selectedIndex.value = self.pagesViewControllers.index(of: viewController)!
        if self.selectedIndex.value == 0 {
            return nil
        }
        self.selectedIndex.value -= 1
        return self.pagesViewControllers[self.selectedIndex.value]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.selectedIndex.value = self.pagesViewControllers.index(of: viewController)!
        if self.selectedIndex.value == self.pagesViewControllers.count - 1 {
            return nil
        }
        self.selectedIndex.value += 1
        return self.pagesViewControllers[self.selectedIndex.value]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let nextVC = pageViewController.viewControllers![0]
            let index = self.pagesViewControllers.index(of: nextVC)!
            self.headerView.selectedIndex.value = index
        }
    }
}
