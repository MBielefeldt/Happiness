//
//  FaceView.swift
//  Happiness
//
//  Created by Mads Bielefeldt on 17/05/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

class FaceView: UIView
{
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.height, bounds.size.width) / 2 * scale
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeigthRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye {
            case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
            case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        eyePath.lineWidth = lineWidth
        
        return eyePath
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeigthRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let smilePath = UIBezierPath()
        smilePath.moveToPoint(start)
        smilePath.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        smilePath.lineWidth = lineWidth
        
        return smilePath
    }
    
    override func drawRect(rect: CGRect)
    {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness = 0.75
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
}
