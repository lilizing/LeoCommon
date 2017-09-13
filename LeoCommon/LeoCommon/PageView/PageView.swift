//
//  PageView.swift
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

class PageView:UIView {
    var feedView:FeedViewForPage!
    
    var items:[UIView] = []
    
    var toIndex:Int = -1
    
    var selectedIndex:Int = -1 {
        didSet {
            Utils.debugLog("选中索引：\(selectedIndex)")
        }
    }
    
    var isMoving:Bool = false
    
    weak var viewController:PageVC?
    
    func show(at index:Int) {
        guard index < items.count else { return }
        
        self.selectedIndex = index
        
        if #available(iOS 9, *) {
            self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: {
                self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
            })
        }
    }
    
    func remove(at index: Int) {
        guard index < items.count && self.feedView.sectionViewModels.count > 0 else { return }
        
        self.items.remove(at: index)
        
        if (index <= self.selectedIndex) {
            self.selectedIndex -= 1;
        }
        
        self.feedView.remove(section: 0, at: index, reload:true)
        
        guard self.selectedIndex > -1 else {
            return
        }
        
        if #available(iOS 9, *) {
            self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: {
                self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
            })
        }
    }
    
    func insert(newElement: UIView, at: Int) {
        guard at <= items.count else { return }
        
        self.items.insert(newElement, at: at)
        
        let cellVM = FeedViewCellViewModel.init()
        
        self.feedView.insert(newElement: cellVM, at: at, section: 0, reload:true)
        
        if self.items.count == 1 {
            self.selectedIndex = 0
        }
        
        if (at <= self.selectedIndex && self.items.count > 1) {
            self.selectedIndex += 1;
            if #available(iOS 9, *) {
                self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: {
                    self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
                })
            }
        }
    }
    
    func insert(contentsOf: [UIView], at: Int) {
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
            if #available(iOS 9, *) {
                self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: {
                    self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.feedView = FeedViewForPage.init(frame: .zero, layoutType: .flow, scrollDirection: .horizontal)
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

extension PageView:FeedViewForPageDataSource {
    func feedView(viewForCellAt index: Int) -> UIView {
        return self.items[index]
    }
}

private let FeedPageCellViewTag = 1000

protocol FeedViewForPageDataSource:class {
    func feedView(viewForCellAt index: Int) -> UIView
}

class FeedViewForPage:FeedView {
    weak var dataSource:PageView!
    
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
        return self.bounds.size
    }
}
