//
//  FeedView+DataSource.swift
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