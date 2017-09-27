//
//  FeedPageView+DataSource.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/16.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ObjectMapper

private let FeedPageViewTabViewTag = 1111

extension FeedPageView {
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == self.sectionViewModels.count {
            return 1
        }
        return self.sectionViewModels[section].items.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == self.sectionViewModels.count {
            let cellVM = self.cellViewModelForPage
            let reuseIdentifier = String(describing: cellVM.cellClass(nil))
            
            if self.registerDict[reuseIdentifier] == nil {
                self.registerDict[reuseIdentifier] = reuseIdentifier
                collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
            }
            
            let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
            cell.viewModel = cellVM
            
            let subView = cell.viewWithTag(FeedPageViewTabViewTag)
            if subView == nil {
                self.pageView.tag = FeedPageViewTabViewTag
                cell.addSubview(self.pageView)
                self.pageView.snp.remakeConstraints({ (make) in
                    make.edges.equalTo(cell)
                })
            }
            
            return cell
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionViewModels.count + 1
    }
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == self.sectionViewModels.count {
            
            let sectionVM = self.sectionViewModelForPage
            if (kind == UICollectionElementKindSectionHeader || kind == LEOCollectionElementKindSectionHeader), let header = sectionVM.header {
                
                let reuseIdentifier = String(describing: header.sectionClass(nil))
                
                if self.registerDict[reuseIdentifier] == nil {
                    self.registerDict[reuseIdentifier] = reuseIdentifier
                    collectionView.register(header.sectionClass(nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                }
                
                let view:FeedViewSectionHeaderOrFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewSectionHeaderOrFooter
                view.viewModel = sectionVM.header
                
                let subView = view.viewWithTag(FeedPageViewTabViewTag)
                if subView == nil {
                    self.pageTab.tag = FeedPageViewTabViewTag
                    view.addSubview(self.pageTab)
                    self.pageTab.snp.remakeConstraints({ (make) in
                        make.top.equalTo(view).offset(self.pageTabInsets.top)
                        make.left.equalTo(view).offset(self.pageTabInsets.left)
                        make.bottom.equalTo(view).offset(-self.pageTabInsets.bottom)
                        make.right.equalTo(view).offset(-self.pageTabInsets.right)
                    })
                }
                
                return view
            }
            
            return UICollectionReusableView.init()
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
}
