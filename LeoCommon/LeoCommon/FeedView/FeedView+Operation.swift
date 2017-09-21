//
//  FeedView+Operation.swift
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

public protocol FeedViewOperation {
    
    func append(sectionViewModels:[FeedViewSectionViewModel], reload:Bool)
    
    func append(section:Int,
                headerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                footerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                cellViewModels:[FeedViewCellViewModel], reload:Bool)
    
    func append(section:Int, cellViewModels:[FeedViewCellViewModel], reload:Bool)
    
    func append(cellViewModels:[FeedViewCellViewModel], reload:Bool)
    
    func insert(newElement: FeedViewSectionViewModel, section: Int, reload:Bool)
    
    func insert(contentsOf: [FeedViewSectionViewModel], section: Int, reload:Bool)
    
    func insert(newElement: FeedViewCellViewModel, at: Int, section: Int, reload:Bool)
    
    func insert(contentsOf: [FeedViewCellViewModel], at: Int, section: Int, reload:Bool)
    
    func remove(section:Int, at:Int, reload:Bool)
    
    func remove(section:Int, reload:Bool)
}

extension FeedView:FeedViewOperation {
    
    public func clear(reload:Bool = false) {
        self._sectionViewModels.removeAll()
        if reload {
            self.reloadData()
        }
    }
    
    public func append(sectionViewModels:[FeedViewSectionViewModel], reload:Bool = false) {
        self._sectionViewModels.append(contentsOf: sectionViewModels)
        if reload {
            self.reloadData()
        }
    }
    
    public func append(section:Int,
                headerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                footerViewModel:FeedViewSectionHeaderOrFooterViewModel?,
                cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        guard section <= self._sectionViewModels.count else { return }
        
        if section == self._sectionViewModels.count {
            let sectionVM = FeedViewSectionViewModel.init(header:headerViewModel, footer:footerViewModel, items: cellViewModels)
            self._sectionViewModels.append(sectionVM)
        } else {
            let sectionVM = self._sectionViewModels[section]
            sectionVM.header = headerViewModel ?? sectionVM.header
            sectionVM.footer = footerViewModel ?? sectionVM.footer
            sectionVM.items.append(contentsOf: cellViewModels)
        }
        if reload {
            self.reloadData()
        }
    }
    
    public func append(section:Int, cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        self.append(section: section, headerViewModel: nil, footerViewModel: nil, cellViewModels: cellViewModels, reload: reload)
    }
    
    public func append(cellViewModels:[FeedViewCellViewModel], reload:Bool = false) {
        self.append(section: 0, cellViewModels: cellViewModels, reload: reload)
    }
    
    public func insert(newElement: FeedViewSectionViewModel, section: Int, reload:Bool = false) {
        guard section <= self._sectionViewModels.count else {
            assert(section <= self._sectionViewModels.count, "下标越界...")
            return
        }
        self._sectionViewModels.insert(newElement, at: section)
        if reload {
            self.reloadData()
        }
    }
    
    public func insert(contentsOf: [FeedViewSectionViewModel], section: Int, reload:Bool = false) {
        guard section <= self._sectionViewModels.count else {
            assert(section <= self._sectionViewModels.count, "下标越界...")
            return
        }
        self._sectionViewModels.insert(contentsOf: contentsOf, at: section)
        if reload {
            self.reloadData()
        }
    }
    
    public func insert(newElement: FeedViewCellViewModel, at: Int, section: Int, reload:Bool = false) {
        guard
            section <= self._sectionViewModels.count
        else {
            assert(section <= self._sectionViewModels.count, "下标越界...")
            return
        }
        if section == self._sectionViewModels.count {
            self.append(section: section, cellViewModels: [newElement])
        } else {
            guard at <= self._sectionViewModels[section].items.count else {
                assert(at <= self._sectionViewModels[section].items.count, "下标越界...")
                return
            }
            self._sectionViewModels[section].items.insert(newElement, at: at)
        }
        if reload {
            self.reloadData()
        }
    }
    
    public func insert(contentsOf: [FeedViewCellViewModel], at: Int, section: Int, reload:Bool = false) {
        guard
            section <= self._sectionViewModels.count
            else {
                assert(section <= self._sectionViewModels.count, "下标越界...")
                return
        }
        if section == self._sectionViewModels.count {
            self.append(section: section, cellViewModels: contentsOf)
        } else {
            guard at <= self._sectionViewModels[section].items.count else {
                assert(at <= self._sectionViewModels[section].items.count, "下标越界...")
                return
            }
            self._sectionViewModels[section].items.insert(contentsOf: contentsOf, at: at)
        }
        if reload {
            self.reloadData()
        }
    }
    
    public func remove(section:Int, at:Int, reload:Bool = false) {
        guard section <= self._sectionViewModels.count else {
            assert(section <= self._sectionViewModels.count, "下标越界...")
            return
        }
        guard at <= self._sectionViewModels[section].items.count else {
            assert(at <= self._sectionViewModels[section].items.count, "下标越界...")
            return
        }
        self._sectionViewModels[section].items.remove(at: at)
        if reload {
            self.reloadData()
        }
    }
    
    public func remove(section:Int, reload:Bool = false) {
        guard section <= self._sectionViewModels.count else {
            assert(section <= self._sectionViewModels.count, "下标越界...")
            return
        }
        self._sectionViewModels.remove(at: section)
        if reload {
            self.reloadData()
        }
    }
}
