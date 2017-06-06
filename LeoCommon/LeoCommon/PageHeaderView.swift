//
//  PageHeaderView.swift
//  Lottery
//
//  Created by 李理 on 2017/5/3.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

public enum PageHeaderCellStatus {
    case normal
    case selected
}

open class PageHeaderItem:ViewModel<Any?> {
    public var title:NSAttributedString?
    public var selectedTitle:NSAttributedString?
    public var size:CGSize = .zero
    public var status:MutableProperty<PageHeaderCellStatus> = MutableProperty(.normal)
}

open class PageHeaderCell:CollectionCell<PageHeaderItem> {
    public var titleLabel:UILabel = UILabel()
    
    public var disposable:Disposable?
    
    override open func initSubviews() {
        guard self.titleLabel.superview == nil else {
            return
        }
        self.contentView.addSubview(self.titleLabel)
    }
    
    override open func relayout() {
        self.titleLabel.snp.remakeConstraints { (make) in
            make.center.equalTo(self.contentView.snp.center)
        }
    }
    
    override open func set() {
        
    }
    
    override open func binding() {
        self.disposable?.dispose()
        self.disposable = self.viewModel!.status.producer.take(during: self.reactive.lifetime).startWithValues { [weak self] (value) in
            if let strongSelf = self {
                if value == .normal {
                    strongSelf.titleLabel.attributedText = strongSelf.viewModel!.title
                } else {
                    strongSelf.titleLabel.attributedText = strongSelf.viewModel!.selectedTitle
                }
            }
        }
    }
}

open class PageHeaderView:UIView,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    public var blurView:UIToolbar?
    public var itemsContainerView:UICollectionView?
    public var lineContainerView:UIScrollView = UIScrollView()
    public var lineView:UIView = UIView()
    public var selectedIndex:MutableProperty<Int> = MutableProperty(0)
    public var disposable:Disposable?
    
    public var items:[PageHeaderItem] = [] {
        didSet {
            var tSize = CGSize.init(width: 0, height: 2)
            for item in self.items {
                tSize.width += item.size.width
            }
            let tw = self.items[self.selectedIndex.value].size.width
            self.lineContainerView.contentSize = tSize
            self.lineView.snp.remakeConstraints { (make) in
                make.left.equalTo(self.lineContainerView.snp.left)
                make.centerY.equalTo(self.lineContainerView.snp.centerY)
                make.height.equalTo(2)
                make.width.equalTo(tw)
            }
            
            self.binding()
        }
    }
    
    public convenience init() {
        self.init(frame: .zero)
        
        self.blurView = UIToolbar.init()
        self.addSubview(self.blurView!)
        self.blurView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.itemsContainerView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.addSubview(self.itemsContainerView!)
        self.itemsContainerView!.backgroundColor = .clear
        self.itemsContainerView!.dataSource = self
        self.itemsContainerView!.delegate = self
        self.itemsContainerView!.showsHorizontalScrollIndicator = false
        self.itemsContainerView!.showsVerticalScrollIndicator = false
        self.itemsContainerView!.register(PageHeaderCell.self, forCellWithReuseIdentifier: "CELL")
        self.itemsContainerView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        
        self.lineContainerView = UIScrollView()
        self.addSubview(self.lineContainerView)
        self.lineContainerView.isScrollEnabled = false
        self.lineContainerView.isUserInteractionEnabled = false
        self.lineContainerView.showsHorizontalScrollIndicator = false
        self.lineContainerView.showsVerticalScrollIndicator = false
        self.lineContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(2)
        }
        self.lineContainerView.addSubview(self.lineView)
    }
    
    public convenience init(items:[PageHeaderItem]) {
        self.init()
        self.items = items
    }
    
    public func binding() {
        self.disposable?.dispose()
        self.disposable = self.selectedIndex.producer.take(during: self.reactive.lifetime).skipRepeats().startWithValues { (value) in
            for i in 0..<self.items.count {
                let viewModel = self.items[i]
                if i == value {
                    viewModel.status.value = .selected
                } else {
                    viewModel.status.value = .normal
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                var left:CGFloat = 0.0
                let width = self.items[self.selectedIndex.value].size.width
                for i in 0..<self.selectedIndex.value {
                    left = self.items[i].size.width + left
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.lineView.snp.remakeConstraints { (make) in
                        make.left.equalTo(self.lineContainerView.snp.left).offset(left)
                        make.centerY.equalTo(self.lineContainerView.snp.centerY)
                        make.height.equalTo(2)
                        make.width.equalTo(width)
                    }
                    self.lineContainerView.layoutIfNeeded()
                }) { (_) in
                    
                }
            }
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! PageHeaderCell
        cell.viewModel = self.items[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.items[indexPath.row].size
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex.value = indexPath.row
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lineContainerView.contentOffset = scrollView.contentOffset
    }
    
    
}
