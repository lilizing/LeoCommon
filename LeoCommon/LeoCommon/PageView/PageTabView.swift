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


class PageTabItemView:UIView {
    var selected:Bool = false {
        didSet {
            self.backgroundColor = self.selected ? .black : .orange
        }
    }
    
    func width() -> CGFloat {
        return 0
    }
}

class PageTabView:UIView {
    var feedView:FeedViewForPageTab!
    
    var disposeBag = DisposeBag()
    
    var items:[PageTabItemView] = []
    
    var selectedIndexObservable:Variable<Int> = Variable(-1)
    
    private var selectedIndex:Int = -1 {
        didSet {
            Utils.debugLog("Tab - 选中索引：\(selectedIndex)")
            
            guard self.selectedIndex > -1 else { return }
            
            var width:CGFloat = 0
            var index = 0
            var selectedTab:PageTabItemView!
            var selectedTabLeft:CGFloat = 0
            
            for tab in self.items {
                if index == self.selectedIndex {
                    selectedTabLeft = width
                    selectedTab = tab
                }
                tab.selected = index == self.selectedIndex
                width += tab.width()
                index += 1
            }
            
            let selectedTabCenterX = selectedTabLeft + selectedTab.width() / 2
            
            var contentOffsetX:CGFloat = 0
            if self.feedView.collectionView.contentSize.width > self.bounds.size.width {
                contentOffsetX = min(max(selectedTabCenterX - self.bounds.size.width / 2, 0), self.feedView.collectionView.contentSize.width - self.bounds.size.width)
            }
            
            self.feedView.collectionView.setContentOffset(.init(x: contentOffsetX, y: 0), animated: true)
            
            self.selectedIndexObservable.value = self.selectedIndex
        }
    }
    
    var isMoving:Bool = false
    
    weak var viewController:PageVC?
    
    func show(at index:Int) {
        guard index < items.count else { return }
        
        self.selectedIndex = index
    }
    
    func remove(at index: Int) {
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
    
    func insert(newElement: PageTabItemView, at: Int) {
        guard at <= items.count else { return }
        
        self.items.insert(newElement, at: at)
        
        let cellVM = FeedViewCellViewModel.init()
        
        self.feedView.insert(newElement: cellVM, at: at, section: 0, reload:true)
        
        if self.items.count == 1 {
            self.selectedIndex = 0
        }
        
        if (at <= self.selectedIndex && self.items.count > 1) {
            self.selectedIndex += 1;
        }
        
        newElement.tapGesture().bind { [weak self, weak newElement] (_) in
            guard let sSelf = self, let sEle = newElement else { return }
            
            if let index = sSelf.items.index(of: sEle) {
                sSelf.selectedIndex = index
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    func insert(contentsOf: [PageTabItemView], at: Int) {
        guard at <= items.count else { return }
        
        self.items.insert(contentsOf: contentsOf, at: at)
        
        for _ in contentsOf {
            let cellVM = FeedViewCellViewModel.init()
            self.feedView.insert(newElement: cellVM, at: at, section: 0)
        }
        
        self.feedView.reloadData()
        
        if self.items.count == contentsOf.count {
            self.selectedIndex = 0
        }
        
        if (at <= self.selectedIndex && self.items.count > contentsOf.count) {
            self.selectedIndex += 1;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.feedView = FeedViewForPageTab.init(frame: .zero, layoutType: .flow, scrollDirection: .horizontal)
        self.feedView.dataSource = self
        self.feedView.collectionView.isPagingEnabled = true
        self.feedView.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTabView:FeedViewForPageTabDataSource {
    func feedView(viewForCellAt index: Int) -> UIView {
        return self.items[index]
    }
}

private let FeedPageCellViewTag = 1000

protocol FeedViewForPageTabDataSource:class {
    func feedView(viewForCellAt index: Int) -> UIView
}

class FeedViewForPageTab:FeedView {
    weak var dataSource:PageTabView!
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let reuseIdentifier = String(describing: cellVM.cellClass(nil))
        
        if self.registerDict[reuseIdentifier] == nil {
            self.registerDict[reuseIdentifier] = reuseIdentifier
            collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
        cell.viewModel = cellVM
        
        if let view = cell.viewWithTag(FeedPageCellViewTag) {
            let tView = self.dataSource.feedView(viewForCellAt: indexPath.row)
            guard view != tView else { return cell }
            
            view.removeFromSuperview()
            cell.addSubview(tView)
            tView.snp.makeConstraints { (make) in
                make.edges.equalTo(cell)
            }
        } else {
            let view = self.dataSource.feedView(viewForCellAt: indexPath.row)
            view.tag = FeedPageCellViewTag
            cell.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalTo(cell)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let view = self.dataSource.items[indexPath.row]
        return CGSize.init(width: view.width(), height: self.bounds.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utils.debugLog("Offset:\(scrollView.contentOffset)")
    }
}
