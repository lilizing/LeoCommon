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

enum FeedViewLayoutType {
    case flow, water
}

protocol FeedViewOperation {
    
    func append(sectionViewModels:[FeedViewSectionViewModel], reload:Bool)
    
    func append(section:Int,
                headerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                footerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                cellViewModels:[FeedViewCellViewModel], reload:Bool)
    
    func append(section:Int, cellViewModels:[FeedViewCellViewModel], reload:Bool)
    
    func append(cellViewModels:[FeedViewCellViewModel], reload:Bool)
    
}

class FeedView:UIView {
    
    var collectionView:UICollectionView!
    
    fileprivate var registerDict:[String: String] = [:]
    fileprivate var disposeBag = DisposeBag()
    fileprivate var sectionInnerDisposeBag = DisposeBag()
    
    var sectionViewModels:[FeedViewSectionViewModel] = []
    
    var layoutType:FeedViewLayoutType = .flow
    var scrollDirection:UICollectionViewScrollDirection = .vertical
    
    //加载器，即：你的业务处理逻辑
    var loader:(_ page:Int, _ pageSize:Int)->(Void) = { _,_ in }
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    private func initCollectionView() {
        if self.layoutType == .water {
            let layout = LEOCollectionViewWaterfallLayout()
            layout.itemRenderDirection = .leoCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight
            self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = self.scrollDirection
            self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        }
        
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    init(frame: CGRect, layoutType:FeedViewLayoutType = .flow, scrollDirection:UICollectionViewScrollDirection = .vertical) {
        super.init(frame: frame)
        self.scrollDirection = scrollDirection
        self.layoutType = layoutType
        self.initCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedView:FeedViewOperation {
    
    func clear(reload:Bool = false) {
        self.sectionViewModels.removeAll()
        if reload {
            self.reloadData()
        }
    }
    
    func append(sectionViewModels:[FeedViewSectionViewModel], reload:Bool = false) {
        self.sectionViewModels.append(contentsOf: sectionViewModels)
        if reload {
            self.reloadData()
        }
    }
    
    func append(section:Int,
                headerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                footerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        guard section <= self.sectionViewModels.count else { return }
        
        if section == self.sectionViewModels.count {
            let sectionVM = FeedViewSectionViewModel.init(header:headerViewModel, footer:footerViewModel, items: cellViewModels)
            self.sectionViewModels.append(sectionVM)
        } else {
            let sectionVM = self.sectionViewModels[section]
            sectionVM.header = headerViewModel
            sectionVM.footer = footerViewModel
            sectionVM.items.append(contentsOf: cellViewModels)
        }
        if reload {
            self.reloadData()
        }
    }
    
    func append(section:Int, cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        self.append(section: section, headerViewModel: nil, footerViewModel: nil, cellViewModels: cellViewModels, reload: reload)
    }
    
    func append(cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        self.append(section: 0, cellViewModels: cellViewModels, reload: reload)
    }
}

extension FeedView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sectionViewModels.count == 0 {
            return 0
        }
        return self.sectionViewModels[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let reuseIdentifier = String(describing: cellVM.cellClass(nil))
        
        if self.registerDict[reuseIdentifier] == nil {
            self.registerDict[reuseIdentifier] = reuseIdentifier
            collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
        cell.viewModel = cellVM
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionVM = self.sectionViewModels[indexPath.section]
        if (kind == UICollectionElementKindSectionHeader || kind == LEOCollectionElementKindSectionHeader), let header = sectionVM.header {
            
            let reuseIdentifier = String(describing: header.sectionClass(nil))
            
            if self.registerDict[reuseIdentifier] == nil {
                self.registerDict[reuseIdentifier] = reuseIdentifier
                collectionView.register(header.sectionClass(nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
            }
            
            let view:FeedViewSectionHeaderOrFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewSectionHeaderOrFooter
            view.viewModel = sectionVM.header
            return view
        } else if (kind == UICollectionElementKindSectionFooter || kind == LEOCollectionElementKindSectionFooter), let footer = sectionVM.footer {
            let reuseIdentifier = String(describing: footer.sectionClass(nil))
            
            if self.registerDict[reuseIdentifier] == nil {
                self.registerDict[reuseIdentifier] = reuseIdentifier
                collectionView.register(footer.sectionClass(nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
            }
            
            let view:FeedViewSectionHeaderOrFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewSectionHeaderOrFooter
            view.viewModel = sectionVM.footer
            return view
        }
        return UICollectionReusableView.init()
    }
}

extension FeedView:UICollectionViewDelegateFlowLayout  {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section > self.sectionViewModels.count - 1  {
            return .zero
        }
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let cls = cellVM.cellClass(nil)
        let size = cls.sizeThatFits(cellVM, size: self.bounds.size)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumInteritemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let sectionVM = self.sectionViewModels[section]
        if let header = sectionVM.header {
            let cls = header.sectionClass(nil)
            let size = cls.sizeThatFits(header, size:self.bounds.size)
            return size
        }
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let sectionVM = self.sectionViewModels[section]
        if let footer = sectionVM.footer {
            let cls = footer.sectionClass(nil)
            let size = cls.sizeThatFits(footer, size:self.bounds.size)
            return size
        }
        return .zero
    }
}

extension FeedView:LEOCollectionViewDelegateWaterfallLayout {
    
    func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let cls = cellVM.cellClass(nil)
        let size = cls.sizeThatFits(cellVM, size:self.bounds.size)
        return size
    }
    
    func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         heightForHeaderInSection section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        if let header = sectionVM.header {
            let cls = header.sectionClass(nil)
            let size = cls.sizeThatFits(header, size:self.bounds.size)
            return size.height
        }
        return 0
    }
    
    func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         heightForFooterInSection section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        if let footer = sectionVM.footer {
            let cls = footer.sectionClass(nil)
            let size = cls.sizeThatFits(footer, size:self.bounds.size)
            return size.height
        }
        return 0
    }
    
    func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.sectionInset
    }
    
    func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumInteritemSpacing
    }
    
    func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         columnCountForSection section: Int) -> Int {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.columnCount
    }
}

extension FeedView:UICollectionViewDelegate {
    
}
