//
//  CustomLayout.swift
//  GetMyParking
//
//  Created by Suruchi Sinha on 1/14/18.
//  Copyright © 2018 Suruchi Sinha. All rights reserved.
//

import UIKit

protocol CustomDataSource: class {
    func contentSizeForIndex()-> CGSize
}

class CustomLayout: UICollectionViewLayout {
    
    var itemOffset: UIOffset!
    var horizontalOffset: CGFloat!
    var verticalOffset: CGFloat!
    var maxWidth: CGFloat!
    var maxHeight: CGFloat!
    var contentSize = CGSize.zero
    var contentWidth: CGFloat!
    var contentHeight: CGFloat!
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    weak var delegate: CustomDataSource?
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func prepare() {
        super.prepare()
        contentWidth = maxWidth
        contentHeight = maxHeight
        
        var xPos: CGFloat = horizontalOffset
        var yPos: CGFloat = verticalOffset
        let numberOfItems = collectionView!.numberOfItems(inSection: 0)
        for index in 0..<numberOfItems {
            let itemSize = delegate?.contentSizeForIndex()
            let indexpath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexpath)
            attributes.frame = CGRect(x: xPos, y: yPos, width: (itemSize?.width)!, height: (itemSize?.height)!)
            layoutAttributes.append(attributes)
            
            xPos = xPos + (itemSize?.width)! + horizontalOffset
            let newXPos = xPos + (itemSize?.width)!
            if newXPos > maxWidth {
                if newXPos  > contentWidth {
                    contentWidth = xPos
                }
                xPos = horizontalOffset
                yPos = yPos + (itemSize?.height)! + verticalOffset
            }
            
            if yPos > contentHeight {
                contentHeight = yPos
            }
        }
        
        contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
