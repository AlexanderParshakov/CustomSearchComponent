//
//  CrumbSeparator.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 28.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

internal class CrumbSeparator: UIButton {

    var iconSize: CGFloat = 10
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.white.withAlphaComponent(0.54)

    weak var crumbView: CrumbView?

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.lineWidth = lineWidth
        path.lineCapStyle = .round

        let iconFrame = CGRect(
            x: (rect.width - iconSize) / 2.0,
            y: (rect.height - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )

        path.move(to: CGPoint(x: 6.7, y: 13.0))
        path.addLine(to: CGPoint(x: iconFrame.maxX * 3, y: iconFrame.maxY / 2))
        
        path.move(to: CGPoint(x: iconFrame.maxX / 1.1, y: iconFrame.maxY / 2))
        path.addLine(to: CGPoint(x: iconFrame.minX + 6, y: iconFrame.maxY - 0))
        
        path.move(to: CGPoint(x: iconFrame.minX - 5, y: iconFrame.maxY + 0.5))
        path.addLine(to: CGPoint(x: iconFrame.minX - 1, y: iconFrame.maxY + 0.5))

        lineColor.setStroke()

        path.stroke()
    }

}
