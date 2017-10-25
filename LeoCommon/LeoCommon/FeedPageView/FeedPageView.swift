//
//  FeedPageView.swift
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

open class FeedPageView:FeedView {
    var canScroll = true
    var contentOffset:CGPoint = .zero
    
    public var topOffset:CGFloat = 0
    
    public var pageTabInsets:UIEdgeInsets = .zero {
        didSet {
            self.pageTab.feedView.collectionView.contentInset = pageTabInsets
        }
    }
    
    public var pageTabHeight:CGFloat = 0 {
        didSet {
            self.sectionHeaderViewModelForPage.height = self.pageTabHeight
        }
    }
    
    public var pageViewHeight:CGFloat = 0 {
        didSet {
            self.cellViewModelForPage.height = self.pageViewHeight
        }
    }
    
    private var pgTab:PageTabView = PageTabView()
    public var pageTab:PageTabView {
        get {
            return self.pgTab
        }
    }
    
    var pgView:PageView = PageView()
    public var pageView:PageView {
        get {
            if let vc = self.viewController {
                return vc.pageVC.pageView
            }
            return self.pgView
        }
    }
    
    weak var viewController: FeedPageVC? {
        didSet {
            self.bind()
        }
    }
    
    public init(frame: CGRect,
                layoutType:FeedViewLayoutType = .flow,
                sticky:Bool = true) {
        
        super.init(frame: frame, layoutType: layoutType, scrollDirection: .vertical, sticky: sticky)
        
        self.sectionViewModelForPage.header = self.sectionHeaderViewModelForPage
        self.sectionViewModelForPage.items = [self.cellViewModelForPage]
        self.bind()
    }
    
    public func show(at index:Int) {
        //这里做个演示处理，解决无限联动问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.pageTab.show(at: index)
        }
    }
    
    func bind() {
        self.disposeBag = DisposeBag()
        
        NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: FeedPageViewOuterCanScroll)).bind { [weak self] (notification) in
            guard let sSelf = self,let canScroll = notification.object as? Bool else { return }
            
            Utils.commonLog("外部 - 切换 - \(canScroll)")
            
            sSelf.canScroll = canScroll
            
            sSelf.collectionView.scrollsToTop = canScroll
            
        }.addDisposableTo(self.disposeBag)
        
        self.pageTab.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1
                else {
                    return
            }
            
            if let vc = sSelf.viewController {
                vc.pageVC.show(at: index)
            } else {
                sSelf.pageView.show(at: index)
            }
        }.addDisposableTo(self.disposeBag)
        
        self.pageView.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1
                else {
                    return
            }
            
            sSelf.pageTab.show(at: index)
        }.addDisposableTo(self.disposeBag)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
    
    //以下变量为辅助变量，框架外不可访问
    var sectionViewModelForPage:FeedViewSectionViewModel = FeedViewSectionViewModel()
    var sectionHeaderViewModelForPage:FeedViewPageSectionHeaderViewModel = FeedViewPageSectionHeaderViewModel()
    var cellViewModelForPage:FeedViewPageCellViewModel = FeedViewPageCellViewModel()
}

let FeedPageViewInnerCanScroll = "FeedPageViewInnerCanScroll"
let FeedPageViewOuterCanScroll = "FeedPageViewOuterCanScroll"

extension FeedPageView {
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if !self.canScroll {
            //            self.collectionView.showsVerticalScrollIndicator = false
            scrollView.contentOffset = self.contentOffset
            return
        }
        self.collectionView.showsVerticalScrollIndicator = false
        //        DispatchQueue.global().async {
        var tabHasShow = false
        for cell in self.collectionView.visibleCells {
            let indexPath = self.collectionView.indexPath(for: cell)
            if let id = indexPath?.section, id == self.sectionViewModels.count {
                tabHasShow = true
                break
            }
        }
        
        if tabHasShow {
            //let point = self.pageTab.convert(self.pageTab.frame.origin, to: self)
            //Utils.commonLog("外部 位置：\(point.x) - \(point.y)")
            let height = self.heightForAllSections()
            if scrollView.contentOffset.y >= height - topOffset {
                self.canScroll = false
                
                self.contentOffset = .init(x:0, y:height - topOffset)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: FeedPageViewInnerCanScroll), object: true)
                
                self.collectionView.scrollsToTop = false
            }
        }
        //        }
    }
    
    func heightForAllSections() -> CGFloat {
        var height:CGFloat = 0
        for section in 0..<self.sectionViewModels.count {
            let sectionVM = self.sectionViewModels[section]
            
            for row in 0..<sectionVM.items.count {
                let cellVM = sectionVM.items[row]
                let cls = cellVM.cellClass(nil)
                let size = cls.sizeThatFits(cellVM, size: self.bounds.size)
                
                height += size.height
            }
            
            if let header = sectionVM.header {
                let cls = header.sectionClass(nil)
                let size = cls.sizeThatFits(header, size:self.bounds.size)
                
                height += size.height
            }
            
            if let footer = sectionVM.footer {
                let cls = footer.sectionClass(nil)
                let size = cls.sizeThatFits(footer, size:self.bounds.size)
                
                height += size.height
            }
        }
        return height
    }
}

open class FeedPageInnerFeedView:FeedView {
    var canScroll = false
    var contentOffset:CGPoint = .zero
    
    public override init(frame: CGRect,
                layoutType:FeedViewLayoutType = .flow,
                scrollDirection:UICollectionViewScrollDirection = .vertical,
                sticky:Bool = false) {
        super.init(frame: frame, layoutType: layoutType, scrollDirection: scrollDirection, sticky: sticky)
        self.bind()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: FeedPageViewInnerCanScroll)).bind { [weak self] (notification) in
            guard let sSelf = self,let canScroll = notification.object as? Bool else { return }
            
            Utils.commonLog("内部 - 切换 - \(canScroll)")
            sSelf.canScroll = canScroll
            
            sSelf.collectionView.scrollsToTop = canScroll
            
        }.addDisposableTo(self.disposeBag)
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if !self.canScroll {
            //            self.collectionView.showsVerticalScrollIndicator = false
            scrollView.contentOffset = .init(x:0, y:0)
            return
        }
        self.collectionView.showsVerticalScrollIndicator = false
        //        DispatchQueue.global().async {
        let point = scrollView.contentOffset
        // Utils.commonLog("内部 - 位置：\(point.x) - \(point.y)")
        if point.y < 0 {
            self.canScroll = false
            self.contentOffset = scrollView.contentOffset
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FeedPageViewOuterCanScroll), object: true)
            
            self.collectionView.scrollsToTop = false
        }
        //        }
    }
}

class FeedViewPageCellViewModel:FeedViewCellViewModel {
    var height:CGFloat = 0
    
    override func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return FeedViewPageCell.self
    }
}

class FeedViewPageSectionHeaderViewModel:FeedViewSectionHeaderOrFooterViewModel {
    var height:CGFloat = 0
    
    func sectionClass(_ context:Dictionary<String, Any>?) -> FeedViewSectionHeaderOrFooter.Type {
        return FeedViewPageSectionHeader.self
    }
}

class FeedViewPageCell:FeedViewCell {
    open override func set() {}
    
    open override func bind() {}
    
    open override func layout() {}
    
    open override class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        guard let vm = viewModel as? FeedViewPageCellViewModel else { return .zero }
        return .init(width: size.width, height: vm.height)
    }
}

class FeedViewPageSectionHeader:FeedViewSectionHeaderOrFooter {
    open override func set() {}
    open override func bind() {}
    open override func layout() {}
    
    open override class func sizeThatFits(_ viewModel:FeedViewSectionHeaderOrFooterViewModel?, size: CGSize = .zero) -> CGSize {
        guard let vm = viewModel as? FeedViewPageSectionHeaderViewModel else { return .zero }
        return .init(width: size.width, height: vm.height)
    }
}
