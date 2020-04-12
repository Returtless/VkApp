//
//  NewsPhotoCellCollectionViewLayout.swift
//  VKApp
//
//  Created by Владислав Лихачев on 11.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NewsPhotoCellCollectionViewLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columnsCount = 2
    let viewHeight: CGFloat = 400
    var cellHeight: CGFloat = 400
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        cacheAttributes = [:]
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return }
        let dataSourceCell = collectionView.dataSource as! NewsTableViewCell
        
        //нужно посчитать каких фото в массиве больше, горизонтальных или вертикальных
        var sizesOfPhotos : (x: UInt, y: UInt) = (0,0)
        for img in dataSourceCell.photos {
            if img.size.height < img.size.width {
                sizesOfPhotos.x += 1
            } else {
                sizesOfPhotos.y += 1
            }
        }
        let horizontal = sizesOfPhotos.x > sizesOfPhotos.y
        let linesCount = calculateCountOfLines(for: itemsCount)
        
        let arrayCellsInLines = calculateCellCountInLines(for: linesCount, itemsCount)
        
        
        let cellWidth = collectionView.bounds.width
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        var numberOfCurrenSection = 1
        var currentCellInSection = 1
        
        for index in 0..<itemsCount {
            
            
            
            let indexPath = IndexPath(item: index, section: 0)
            let attributtes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let realItemsCount : CGFloat = CGFloat(arrayCellsInLines[numberOfCurrenSection-1])
            let currentWidth = horizontal ? cellWidth / realItemsCount : cellWidth / CGFloat(linesCount)
            let currentHeight = horizontal ? viewHeight / CGFloat(linesCount) : viewHeight / realItemsCount
            attributtes.frame = CGRect(
                x: lastX,
                y: lastY,
                width: currentWidth,
                height: currentHeight)
            if horizontal {
                lastX += currentWidth + 1

            } else {
                lastY += currentHeight + 1

            }
            if currentCellInSection == arrayCellsInLines[numberOfCurrenSection-1] {
                numberOfCurrenSection+=1
                currentCellInSection = 1
                if horizontal {
                    lastY = CGFloat((numberOfCurrenSection-1) * (Int(viewHeight) / linesCount) + numberOfCurrenSection )
                    lastX = 0
                } else {
                    lastX = CGFloat((numberOfCurrenSection-1) * (Int(cellWidth) / linesCount) + numberOfCurrenSection)
                    lastY = 0
                }
            } else {
                currentCellInSection+=1
            }
            cacheAttributes[indexPath] = attributtes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0,
                      height: totalCellsHeight)
    }
    
    func calculateCountOfLines(for count: Int) -> Int{
        switch count {
        case 1:
            return 1
        case 2...6:
            return 2
        case 7...10:
            return 3
        default:
            return 0
        }
    }
    func calculateCellCountInLines(for line: Int, _ allCount : Int) -> [Int]{
        var array = [Int]()
        var currentAllCount = allCount
        switch allCount {
        case 1:
            return [1]
        case 2...4:
            return [1, allCount-1]
        case 5...10:
            for i in (1...line).reversed() {
                let cells = currentAllCount/i
                array.append(cells)
                currentAllCount -= cells
            }
            fallthrough
        default:
            return array
        }
    }
}
