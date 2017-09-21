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
    public var simultaneously:Bool = false //是否支持滑动共存
    
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return self.simultaneously
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
    
    var _didScrollSignal = PublishSubject<UIScrollView>()
    var _didEndDraggingSignal = PublishSubject<(UIScrollView, Bool)>()
    var _didEndDeceleratingSignal = PublishSubject<UIScrollView>()
    var _didEndScrollingAnimation = PublishSubject<UIScrollView>()
    
    public var emptyView:UIView?
    
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
    
    //加载器，即：你的业务处理逻辑
    public var loader:(_ page:Int, _ pageSize:Int)->(Void) = { _,_ in }
    
    var footer:LEORefreshFooter?
    
    public func reloadData() {
        if self.sectionViewModels.count == 0 {
            
            if let emptyView = self.emptyView {
                self.addSubview(emptyView)
                emptyView.snp.remakeConstraints({ (make) in
                    make.edges.equalTo(self)
                })
            }
            
            if self.showFooter, let footer = self.collectionView.leo_footer {
                self.footer = footer
                footer.removeFromSuperview()
                footer.endRefreshingWithNoMoreData()
                self.collectionView.leo_footer = nil
            }
        } else {
            if self.showFooter, let ft = self.footer {
                self.collectionView.leo_footer = ft
                if let emptyView = self.emptyView {
                    emptyView.removeFromSuperview()
                }
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
                let tLayout = FeedViewStickyHeaderViewFlowLayout()
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
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
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
}

extension FeedView:UICollectionViewDelegate {
    
}
