//
//  FeedPageVC.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/27.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

open class FeedPageVC:UIViewController {
    var _feedPageView:FeedPageView!
    
    public var topOffset:CGFloat {
        get {
            return self.feedPageView.topOffset
        }
        set {
            self.feedPageView.topOffset = newValue
        }
    }
    
    public var pageTabInsets:UIEdgeInsets {
        get {
            return self.feedPageView.pageTabInsets
        }
        set {
            self.feedPageView.pageTabInsets = newValue
        }
    }
    
    public var pageTabHeight:CGFloat {
        get {
            return self.feedPageView.pageTabHeight
        }
        set {
            self.feedPageView.pageTabHeight = newValue
        }
    }
    
    public var pageViewHeight:CGFloat {
        get {
            return self.feedPageView.pageViewHeight
        }
        set {
            self.feedPageView.pageViewHeight = newValue
        }
    }
    
    public var pageTab:PageTabView {
        get {
            return self.feedPageView.pageTab
        }
    }
    
    private var pgVC:PageVC = PageVC()
    public var pageVC:PageVC {
        get {
            return self.pgVC
        }
    }
    
    public var feedPageView:FeedPageView! {
        get {
            return self._feedPageView
        }
    }
    
    public convenience init(layoutType:FeedViewLayoutType,
                            sticky:Bool = false) {
        self.init()
        self._feedPageView = FeedPageView.init(frame: .zero,
                                              layoutType: layoutType,
                                              sticky: sticky)
        self.feedPageView.viewController = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.feedPageView)
        self.feedPageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.pageVC.didMove(toParentViewController: self)
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension FeedPageVC {
    public func reloadData() {
        self.feedPageView.reloadData()
    }

    public func showPage(at index:Int) {
        //这里做个延迟处理，解决无限联动问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.pageVC.show(at: index)
        }
    }
    
    public func removeAllForPage() {
        self.pageTab.removeAll()
        self.pageVC.removeAll()
        self.pageTabHeight = 0
        self.pageViewHeight = 0
        self.feedPageView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FeedPageViewOuterCanScroll), object: true)
    }

    public func removeForPage(at index:Int) {
        self.pageTab.remove(at: index)
        self.pageVC.remove(at: index)
    }

    public func insertForPage(tab: PageTabItemView, vc: UIViewController, at: Int) {
        self.pageTab.insert(newElement: tab, at: at)
        self.pageVC.insert(newElement: vc, at: at)
    }

    public func insertForPage(tabs: [PageTabItemView], vcs: [UIViewController], at: Int) {
        self.pageTab.insert(contentsOf: tabs, at: at)
        self.pageVC.insert(contentsOf: vcs, at: at)
    }
}

extension FeedPageVC {
    public func clear(reload:Bool = false) {
        self.feedPageView.clear()
        self.pageTab.removeAll()
        self.pageVC.removeAll()
        if reload {
           self.pageTabHeight = 0
           self.pageViewHeight = 0
           self.feedPageView.reloadData()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FeedPageViewOuterCanScroll), object: true)
    }
    
    public func append(sectionViewModels:[FeedViewSectionViewModel], reload:Bool = false) {
        self.feedPageView.append(sectionViewModels: sectionViewModels, reload:reload)
    }
    
    public func append(section:Int,
                headerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                footerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                cellViewModels:[FeedViewCellViewModel],
                reload:Bool) {
        self.feedPageView.append(section: section, headerViewModel: headerViewModel, footerViewModel: footerViewModel, cellViewModels: cellViewModels, reload: reload)
    }
    
    public func append(section:Int, cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        self.feedPageView.append(section: section, cellViewModels: cellViewModels, reload:reload)
    }
    
    public func append(cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        self.feedPageView.append(cellViewModels: cellViewModels, reload: reload)
    }
    
    public func insert(newElement: FeedViewSectionViewModel, section: Int, reload:Bool = false) {
        self.feedPageView.insert(newElement: newElement, section: section, reload:reload)
    }
    
    public func insert(contentsOf: [FeedViewSectionViewModel], section: Int, reload:Bool = false) {
        self.feedPageView.insert(contentsOf: contentsOf, section: section, reload:reload)
    }
    
    public func insert(newElement: FeedViewCellViewModel, at: Int, section: Int, reload:Bool = false) {
        self.feedPageView.insert(newElement: newElement, at: at, section:section, reload:reload)
    }
    
    public func insert(contentsOf: [FeedViewCellViewModel], at: Int, section: Int, reload:Bool = false) {
        self.feedPageView.insert(contentsOf: contentsOf, at: at, section:section, reload:reload)
    }
    
    public func remove(section:Int, at:Int, reload:Bool = false) {
        self.feedPageView.remove(section: section, at: at, reload:reload)
    }
    
    public func remove(section:Int, reload:Bool = false) {
        self.feedPageView.remove(section: section, reload:reload)
    }
}

