//
//  FeedView+FlowLayout.swift
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

extension FeedView:UICollectionViewDelegateFlowLayout  {
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section > self.sectionViewModels.count - 1  {
            return .zero
        }
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let cls = cellVM.cellClass(nil)
        let size = cls.sizeThatFits(cellVM, size: self.bounds.size)
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.sectionInset
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumLineSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumInteritemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
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
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
