//
//  StickyHeaderCollectionViewFlowLayout.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/15.
//  Copyright © 2017年 李理. All rights reserved.
//

import UIKit

class FeedViewFloatingHeaderViewFlowLayout: UICollectionViewFlowLayout {
    weak var feedView:FeedView?
    
    func headerSticky(section:Int) -> Bool {
        var headerSticky = false
        if
            let fv = self.feedView,
            fv.sectionViewModels.count > section {
            headerSticky = fv.sectionViewModels[section].headerSticky
        }
        return headerSticky
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var visibleSectionsWithoutHeader:[Int] = []
        
        for itemAttributes in attributes {
            if !visibleSectionsWithoutHeader.contains(itemAttributes.indexPath.section) {
                visibleSectionsWithoutHeader.append(itemAttributes.indexPath.section)
            }
            
            if itemAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                let indexOfSectionObject = visibleSectionsWithoutHeader.index(of: itemAttributes.indexPath.section)
                if let indexOfSectionObject = indexOfSectionObject, indexOfSectionObject != NSNotFound {
                    visibleSectionsWithoutHeader.remove(at: indexOfSectionObject)
                }
            }
        }
        
        for sectionNumber in visibleSectionsWithoutHeader {
            let headerSticky = self.headerSticky(section: sectionNumber)
            
            if headerSticky {
                if let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath.init(item: 0, section: sectionNumber)),
                    headerAttributes.frame.size.width > 0 && headerAttributes.frame.size.height > 0 {
                    attributes.append(headerAttributes)
                }
            }
        }
        
        for itemAttributes in attributes {
            if itemAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                let headerAttributes = itemAttributes;
                if self.headerSticky(section: headerAttributes.indexPath.section) {
                    let contentOffset = self.collectionView!.contentOffset
                    var originInCollectionView = CGPoint.init(x: headerAttributes.frame.origin.x - contentOffset.x,
                                                              y: headerAttributes.frame.origin.y - contentOffset.y)
                    originInCollectionView.y -= self.collectionView!.contentInset.top
                    var frame = headerAttributes.frame
                    if originInCollectionView.y < 0 {
                        frame.origin.y += (originInCollectionView.y * -1)
                    }
                    var numberOfSections = 1
                    if let num = self.collectionView?.dataSource?.numberOfSections?(in:self.collectionView!) {
                        numberOfSections = num
                    }
                    if numberOfSections > headerAttributes.indexPath.section + 1 {
                        if let nextHeaderAttributes = self .layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath.init(item: 0, section: headerAttributes.indexPath.section + 1)) {
                            let maxY = nextHeaderAttributes.frame.origin.y
                            if frame.maxY >= maxY {
                                frame.origin.y = maxY - frame.size.height
                            }
                        }
                    }
                    headerAttributes.frame = frame
                }
                headerAttributes.zIndex = 1024
            }
        }
        return attributes
    }
}

class FeedViewStickyHeaderViewFlowLayout: UICollectionViewFlowLayout {
    weak var feedView:FeedView?
    
    // MARK: - Collection View Flow Layout Methods
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Helpers
        let sectionsToAdd = NSMutableIndexSet()
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)
                
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
                
            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
            }
        }
        
        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)
            
            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                newLayoutAttributes.append(sectionAttributes)
            }
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        guard let collectionView = collectionView else {
            return layoutAttributes
        }
        
        var headerSticky = false
        if
            let fv = self.feedView,
            fv.sectionViewModels.count > indexPath.section {
            headerSticky = fv.sectionViewModels[indexPath.section].headerSticky
        }
        
        let contentOffsetY = collectionView.contentOffset.y
        
        guard let boundaries = boundaries(forSection: indexPath.section), headerSticky else {
            return layoutAttributes
        }
        
        // Helpers
        var frameForSupplementaryView = layoutAttributes.frame
        
        let minimum = boundaries.minimum - frameForSupplementaryView.height
        let maximum = boundaries.maximum - frameForSupplementaryView.height
        
        if contentOffsetY < minimum {
            frameForSupplementaryView.origin.y = minimum
        } else if contentOffsetY > maximum {
            frameForSupplementaryView.origin.y = maximum
        } else {
            frameForSupplementaryView.origin.y = contentOffsetY
        }
        
        layoutAttributes.frame = frameForSupplementaryView
        
        return layoutAttributes
    }
    
    // MARK: - Helper Methods
    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
        // Helpers
        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
        
        // Exit Early
        guard let collectionView = collectionView else { return result }
        
        // Fetch Number of Items for Section
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        
        // Exit Early
        guard numberOfItems > 0 else {
            return nil
        }
        
        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY
            
            // Take Header Size Into Account
            result.minimum -= headerReferenceSize.height
            result.maximum -= headerReferenceSize.height
            
            // Take Section Inset Into Account
            result.minimum -= sectionInset.top
            result.maximum += (sectionInset.top + sectionInset.bottom)
        }
        
        return result
    }
}

