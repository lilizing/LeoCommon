//
//  PageHeaderView.swift
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
import RxGesture

open class PageTabItemView:UIView {
    public var disposeBag = DisposeBag()
    
    open var isSelected:Bool = false {
        didSet {
            //TODO:
        }
    }
    
    open func width() -> CGFloat {
        return 0
    }
    
    deinit {
        Utils.debugLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

open class PageTabView:UIView {
    public var feedView:FeedViewForPageTab!
    
    public var lineScrollView:UIScrollView!
    public var lineView:UIView!
    
    public var lineHeight:CGFloat = 2
    public var lineBottomOffset:CGFloat = 0
    public var lineSpacing:CGFloat = 0
    public var lineMinWidth:CGFloat = 10
    
    public var lineWidth:CGFloat?
    
    public var disposeBag = DisposeBag()
    
    public var items:[PageTabItemView] = []
    
    public var selectedIndexObservable:Variable<Int> = Variable(-1)
    
    var selectedIndex:Int = -1 {
        didSet {
            var width:CGFloat = 0
            var index = 0
            var selectedTab:PageTabItemView!
            var selectedTabLeft:CGFloat = 0
            
            for tab in self.items {
                if index == self.selectedIndex {
                    selectedTabLeft = width
                    selectedTab = tab
                }
                tab.isSelected = index == self.selectedIndex
                width += tab.width()
                index += 1
            }
            
            if oldValue == selectedIndex {
                Utils.debugLog("Tab - 选中索引未发生改变，这里直接返回，不执行任何动作：\(selectedIndex)")
                return;
            }
            Utils.debugLog("Tab - 改变选中索引：\(selectedIndex)")
            
            self.lineView.isHidden = self.selectedIndex < 0
            
            guard self.selectedIndex > -1 else { return }
            
            let selectedTabCenterX = selectedTabLeft + selectedTab.width() / 2
            
            var contentOffsetX:CGFloat = -self.feedView.collectionView.contentInset.left
            if self.feedView.collectionView.contentSize.width > self.bounds.size.width {
                contentOffsetX = min(max(selectedTabCenterX - self.bounds.size.width / 2, -self.feedView.collectionView.contentInset.left), self.feedView.collectionView.contentSize.width - self.bounds.size.width + self.feedView.collectionView.contentInset.right)
            }
            
            self.feedView.collectionView.setContentOffset(.init(x: contentOffsetX, y: 0), animated: true)
            self.lineScrollView.contentSize = .init(width: self.feedView.collectionView.contentSize.width, height: self.lineHeight)
            
            self.lineScrollView.snp.updateConstraints { (make) in
                make.height.equalTo(self.lineHeight)
            }
            
            self.layoutIfNeeded() //因自动布局的延后性，可能这个时候某些视图的bounds还是.zero，影响计算，所以这里做一下强制布局，提前完成布局工作，即可拿到正确的尺寸
            UIView.animate(withDuration: 0.3, animations: { 
                self.lineView.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(selectedTabCenterX)
                    make.top.equalTo(0)
                    make.height.equalTo(self.lineHeight)
                    if let width = self.lineWidth {
                        make.width.equalTo(width)
                    } else {
                        make.width.equalTo(max(self.lineMinWidth, selectedTab.width() - self.lineSpacing * 2))
                    }
                }
                self.layoutIfNeeded()
            })
            
            self.selectedIndexObservable.value = self.selectedIndex
        }
    }
    
    public var isMoving:Bool = false
    
    public weak var viewController:PageVC?
    
    public func show(at index:Int) {
        guard index < items.count else { return }
        self.selectedIndex = index
    }
    
    public func remove(at index: Int) {
        guard index < items.count && self.feedView.sectionViewModels.count > 0 else { return }
        
        self.items.remove(at: index)
        
        self.feedView.remove(section: 0, at: index, reload:true)
        
        if self.items.count == 0 {
            self.selectedIndex = -1
        } else if self.items.count == 1 {
            self.selectedIndex = 0
        } else if (index <= self.selectedIndex && self.selectedIndex > 0) {
            self.selectedIndex -= 1;
        }
    }
    
    public func removeAll() {
        self.items.removeAll()
        self.feedView.remove(section: 0, reload:true)
        self.selectedIndex = -1
    }
    
    public func insert(newElement: PageTabItemView, at: Int, show: Int = 0) {
        self.insert(contentsOf: [newElement], at: at)
    }
    
    func tap(tap: UITapGestureRecognizer) {
        if let tView = tap.view as? PageTabItemView,
            let index = self.items.index(of: tView) {
            self.selectedIndex = index
        }
    }
    
    public func insert(contentsOf: [PageTabItemView], at: Int, show: Int = 0) {
        guard at <= items.count else { return }
        
        self.items.insert(contentsOf: contentsOf, at: at)
        
        var cellVMS:[FeedViewCellViewModel] = []
        for view in contentsOf {
            let cellVM = FeedViewCellViewModel.init()
            cellVMS.append(cellVM)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tap(tap:)))
            view.addGestureRecognizer(tap)
        }
        self.feedView.insert(contentsOf: cellVMS, at: at, section: 0, reload:true)
        
        self.selectedIndex = show
        
        //        if self.items.count == contentsOf.count {
        //            self.selectedIndex = 0
        //        }
        //
        //        if (at <= self.selectedIndex && self.items.count > contentsOf.count) {
        //            self.selectedIndex += 1;
        //        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.feedView = FeedViewForPageTab.init(frame: .zero, layoutType: .flow, scrollDirection: .horizontal)
        self.feedView.dataSource = self
        self.feedView.collectionView.isPagingEnabled = false
        self.feedView.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.lineScrollView = UIScrollView()
        self.lineScrollView.isUserInteractionEnabled = false
        self.addSubview(self.lineScrollView)
        self.lineScrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-self.lineBottomOffset)
            make.height.equalTo(self.lineHeight)
        }
        
        self.lineView = UIView()
        self.lineScrollView.addSubview(self.lineView)
    }
    
    required public  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Utils.debugLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension PageTabView:FeedViewForPageTabDataSource {
    public func feedView(viewForCellAt index: Int) -> UIView {
        return self.items[index]
    }
}

private let FeedPageCellViewTag = 1000

public protocol FeedViewForPageTabDataSource:class {
    func feedView(viewForCellAt index: Int) -> UIView
}

open class FeedViewForPageTab:FeedView {
    public weak var dataSource:PageTabView!
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let reuseIdentifier = String(describing: cellVM.cellClass(nil))
        
        if self.registerDict[reuseIdentifier] == nil {
            self.registerDict[reuseIdentifier] = reuseIdentifier
            collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
        cell.viewModel = cellVM
        
        if let view = cell.contentView.viewWithTag(FeedPageCellViewTag) {
            let tView = self.dataSource.feedView(viewForCellAt: indexPath.row)
            guard view != tView else { return cell }
            
            view.removeFromSuperview()
            
            tView.tag = FeedPageCellViewTag
            cell.contentView.addSubview(tView)
            tView.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }
        } else {
            let view = self.dataSource.feedView(viewForCellAt: indexPath.row)
            
            view.tag = FeedPageCellViewTag
            cell.contentView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }
        }
        self.dataSource.lineScrollView.contentSize = .init(width: collectionView.contentSize.width, height: self.dataSource.lineHeight)
        return cell
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.dataSource.lineScrollView.contentSize = .init(width: collectionView.contentSize.width, height: self.dataSource.lineHeight)
        let view = self.dataSource.items[indexPath.row]
        return CGSize.init(width: view.width(), height: self.bounds.size.height)
    }
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        self.dataSource.lineScrollView.contentSize = .init(width: scrollView.contentSize.width, height: self.dataSource.lineHeight)
        self.dataSource.lineScrollView.contentOffset = scrollView.contentOffset
        self.dataSource.lineScrollView.contentInset = UIEdgeInsets.init(top: 0, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
    }
}
