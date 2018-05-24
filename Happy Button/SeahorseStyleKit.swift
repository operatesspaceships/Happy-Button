//
//  SeahorseStyleKit.swift
//  Happy Button
//
//  Created by Pierre Liebenberg on 5/21/18.
//  Copyright © 2018 The Seahorse Company. All rights reserved.
//
//


import UIKit

public class SeahorseStyleKit : NSObject {
    
    // Drawing Methods
    @objc dynamic public class func drawCheck(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 26, height: 21), resizing: ResizingBehavior = .aspectFit, color: UIColor = UIColor.white) {
        
        // General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        // Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 26, height: 21), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 26, y: resizedFrame.height / 21)


        // Color Declarations
        let strokeColor = color // UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        // Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 2, y: 11.14))
        bezierPath.addLine(to: CGPoint(x: 8.52, y: 17.66))
        bezierPath.addLine(to: CGPoint(x: 24.18, y: 2))
        strokeColor.setStroke()
        bezierPath.lineWidth = 4
        bezierPath.stroke()
        
        context.restoreGState()

    }




    @objc(QTStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
