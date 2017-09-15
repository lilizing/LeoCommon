//
//  ASFloatingHeadersFlowLayout.swift
//  FloatingHeadersDemo
//
//  Created by Andrey Syvrachev on 22.04.15.
//  Copyright (c) 2015 Andrey Syvrachev. All rights reserved.
//
import UIKit

class ASFloatingHeadersFlowLayout: UICollectionViewFlowLayout {
    
    var sectionAttributes:[(header:UICollectionViewLayoutAttributes,sectionEnd:CGFloat)] = []
    let offsets = NSMutableOrderedSet()
    var floatingSectionIndex:Int! = nil
    var width:CGFloat! = nil
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attrs = super.layoutAttributesForElements(in: rect)
        let ret = attrs?.map() {
            
            (attribute) -> UICollectionViewLayoutAttributes in
            
            let attr = attribute
            
            if let elementKind = attr.representedElementKind {
                if (elementKind == UICollectionElementKindSectionHeader){
                    return self.sectionAttributes[attr.indexPath.section].header
                }
            }
            
            return attr
        }
        return ret
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                       at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let collectionView = self.collectionView!
        
        let offset:CGFloat = collectionView.contentOffset.y + collectionView.contentInset.top
        let index = indexForOffset(offset: offset)
        
        let section = self.sectionAttributes[index]
        
        let maxOffsetForHeader = section.sectionEnd - section.header.frame.size.height
        let headerResultOffset = offset > 0 ? min(offset,maxOffsetForHeader) : 0
        
        let headerAttrs = section.header
        headerAttrs.frame =  .init(x: 0, y: headerResultOffset, width: headerAttrs.frame.size.width, height: headerAttrs.frame.size.height)
        headerAttrs.zIndex = 1024
        
        let attrs = self.sectionAttributes[indexPath.section]
        return elementKind == UICollectionElementKindSectionHeader ? attrs.header : self.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    private func testWidthChanged(newWidth:CGFloat!) -> Bool {
        if let width = self.width{
            if (width != newWidth){
                self.width = newWidth
                return true
            }
        }
        self.width = newWidth
        return false
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
        let context = super.invalidationContext(forBoundsChange: newBounds)
        
        if (self.testWidthChanged(newWidth: newBounds.size.width)){
            return context
        }
        
        let collectionView = self.collectionView!
        
        let offset:CGFloat = newBounds.origin.y + collectionView.contentInset.top
        let index = indexForOffset(offset: offset)
        
        var invalidatedIndexPaths = IndexPath.init(item: 0, section: index)
        if let floatingSectionIndex = self.floatingSectionIndex {
            if (self.floatingSectionIndex != index){
                
                // have to restore previous section attributes to default
                let ip = IndexPath.init(item: 0, section: floatingSectionIndex)
                if let hd = super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: ip) {
                    self.sectionAttributes[floatingSectionIndex].header = hd
                    invalidatedIndexPaths.append(ip)
                }
            }
        }
        self.floatingSectionIndex = index
        
        context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader,at:[invalidatedIndexPaths])
        return context
    }
    
    override func prepare() {
        
        super.prepare()
        
        self.sectionAttributes.removeAll(keepingCapacity: true)
        self.offsets.removeAllObjects()
        
        let collectionView = self.collectionView!
        
        let numberOfSections = collectionView.numberOfSections
        
        for var section in 0..<numberOfSections {
            
            section += 1
            
            let indexPath = IndexPath.init(item: 0, section: section)
            
            guard let header =  super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at:indexPath) else {
                continue
            }
            
            var sectionEnd = header.frame.origin.y + header.frame.size.height
            let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
            if (numberOfItemsInSection > 0){
                let lastItemAttrs = super.layoutAttributesForItem(at: IndexPath.init(item: numberOfItemsInSection - 1, section: section))
                sectionEnd = lastItemAttrs!.frame.origin.y + lastItemAttrs!.frame.size.height + self.sectionInset.bottom
            }
            let sectionInfo:(header:UICollectionViewLayoutAttributes,sectionEnd:CGFloat) = (header:header, sectionEnd:sectionEnd)
            self.sectionAttributes.append(sectionInfo)
            
            if (section > 0){
                self.offsets.add(header.frame.origin.y)
            }
        }
    }
    
    
    private func indexForOffset(offset: CGFloat) -> Int {
        let range = NSRange.init(location: 0, length: self.offsets.count)
        return self.offsets.index(of: offset, inSortedRange: range, options: NSBinarySearchingOptions.insertionIndex) { (section0, section1) -> ComparisonResult in
            let s0:CGFloat = section0 as! CGFloat
            let s1:CGFloat = section1 as! CGFloat
            return s0 < s1 ? .orderedAscending : .orderedDescending
        }
    }
}
