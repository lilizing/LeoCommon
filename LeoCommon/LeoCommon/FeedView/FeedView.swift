//
//  SYDCollectionView.swift
//  CYZS
//
//  Created by 李理 on 2017/8/24.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ObjectMapper

public enum FeedViewLayoutType {
    case flow, water, flowLeft, flowRight
}

open class FeedCollectionView:UICollectionView {
    public var simultaneously:Bool? //是否支持滑动共存
    
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        if let sim = self.simultaneously {
            return sim
        }
        if let view = shouldRecognizeSimultaneouslyWithGestureRecognizer.view, (view.superview?.isKind(of: FeedPageInnerFeedView.self)) ?? false {
            return true
        }
        return false
    }
}

open class FeedView:UIView {
    var sticky:Bool = false
    var disposeBag = DisposeBag()
    var registerDict:[String: String] = [:]
    
    var _layout:UICollectionViewLayout!
    var _layoutType:FeedViewLayoutType = .flow
    var _scrollDirection:UICollectionViewScrollDirection = .vertical
    
    var _collectionView:FeedCollectionView!
    var _sectionViewModels:[FeedViewSectionViewModel] = []
    var tempSectionViewModel:FeedViewSectionViewModel = FeedViewSectionViewModel.init()
    
    var _didScrollSignal = PublishSubject<UIScrollView>()
    var _didEndDraggingSignal = PublishSubject<(UIScrollView, Bool)>()
    var _didEndDeceleratingSignal = PublishSubject<UIScrollView>()
    var _didEndScrollingAnimation = PublishSubject<UIScrollView>()
    var _willBeginDragging = PublishSubject<UIScrollView>()
    
    public var emptyView:UIView?
    public var loadingView:UIView?
    
    public var loadingViewModel:FeedViewCellViewModel? //用来处理加载中
    public var noDataViewModel:FeedViewCellViewModel? //用来处理无数据、网络异常
    
    public var sectionViewModels:[FeedViewSectionViewModel] {
        get {
            return self._sectionViewModels
        }
    }
    
    public var layout:UICollectionViewLayout {
        get {
            return self._layout
        }
    }
    
    public var layoutType:FeedViewLayoutType {
        get {
            return self._layoutType
        }
    }
    
    public var scrollDirection:UICollectionViewScrollDirection {
        get {
            return self._scrollDirection
        }
    }
    
    public var collectionView:FeedCollectionView {
        get {
            return self._collectionView
        }
    }
    
    public var didScrollSignal:PublishSubject<UIScrollView> {
        get {
            return self._didScrollSignal
        }
    }
    
    public var didEndDraggingSignal:PublishSubject<(UIScrollView, Bool)> {
        get {
            return self._didEndDraggingSignal
        }
    }
    
    public var didEndDeceleratingSignal:PublishSubject<UIScrollView> {
        get {
            return self._didEndDeceleratingSignal
        }
    }
    
    public var didEndScrollingAnimation:PublishSubject<UIScrollView> {
        get {
            return self._didEndScrollingAnimation
        }
    }
    
    public var willBeginDragging:PublishSubject<UIScrollView> {
        get {
            return self._willBeginDragging
        }
    }
    
    //加载器，即：你的业务处理逻辑
    public var loader:(_ page:Int, _ pageSize:Int)->(Void) = { _,_ in }
    
    var footer:LEORefreshFooter?
    
    public func reloadData() {
        var flag = true
        
        for (index, sectionVM) in self._sectionViewModels.enumerated() {
            if sectionVM == self.tempSectionViewModel {
                self._sectionViewModels.remove(at: index)
                break
            }
        }
        
        if self._sectionViewModels.count > 0 {
            flag = false
        }
        
        if flag {
            if self.isLoading {
                if !self.showHeader || !self.collectionView.leo_header.isRefreshing() {
                    if let loadingView = self.loadingView {
                        self.collectionView.addSubview(loadingView)
                        loadingView.snp.remakeConstraints({ (make) in
                            make.top.left.equalTo(0)
                            make.size.equalTo(self.collectionView.bounds.size)
                        })
                        if let emptyView = self.emptyView {
                            emptyView.removeFromSuperview()
                        }
                    } else if let vm = self.loadingViewModel {
                        self.tempSectionViewModel.items = [vm]
                        self._sectionViewModels.append(self.tempSectionViewModel)
                    }
                }
            } else {
                if let emptyView = self.emptyView {
                    self.collectionView.addSubview(emptyView)
                    emptyView.snp.remakeConstraints({ (make) in
                        make.top.left.equalTo(0)
                        make.size.equalTo(self.collectionView.bounds.size)
                    })
                    if let loadingView = self.loadingView {
                        loadingView.removeFromSuperview()
                    }
                } else if let vm = self.noDataViewModel {
                    self.tempSectionViewModel.items = [vm]
                    self._sectionViewModels.append(self.tempSectionViewModel)
                }
            }
        } else {
            if let emptyView = self.emptyView {
                emptyView.removeFromSuperview()
            }
            if let loadingView = self.loadingView {
                loadingView.removeFromSuperview()
            }
        }
        self.collectionView.reloadData()
    }
    
    private func initCollectionView() {
        if self.layoutType == .water {
            let layout = LEOCollectionViewWaterfallLayout()
            layout.itemRenderDirection = .leoCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight
            self._layout = layout
        } else if self.layoutType == .flowLeft {
            let layout = FeedViewAlignFlowLayout()
            layout.align = .left
            layout.delegate = self
            self._layout = layout
        } else if self.layoutType == .flowRight {
            let layout = FeedViewAlignFlowLayout()
            layout.align = .right
            layout.delegate = self
            self._layout = layout
        } else {
            var layout = UICollectionViewFlowLayout()
            if self.sticky {
                let tLayout = FeedViewFloatingHeaderViewFlowLayout()
                tLayout.feedView = self
                layout = tLayout
            }
            layout.scrollDirection = self.scrollDirection
            self._layout = layout
        }
        
        self._collectionView = FeedCollectionView.init(frame: .zero, collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        if #available(iOS 11.0, *) { //解决安全区域问题，兼容iOS11
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public init(frame: CGRect,
                layoutType:FeedViewLayoutType = .flow,
                scrollDirection:UICollectionViewScrollDirection = .vertical,
                sticky:Bool = false) {
        super.init(frame: frame)
        self.sticky = sticky
        self._scrollDirection = scrollDirection
        self._layoutType = layoutType
        self.initCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension FeedView:UICollectionViewDelegate {
    
}

