//
//  IndicatorView.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/13.
//  Copyright © 2015年 Worktile. All rights reserved.
//

/**
  abstract: 指示器
*/

import UIKit

class LockIndicatorView: UIView {

  //MARK: - Common
  
  let kLockLineWidth: CGFloat = 1
  let CoreLockArcWHR: CGFloat = 0.3
  let CoreLockArcLineW: CGFloat = 1.0

  
  //MARK: -  Property
  
  var _selectedArray: [Int] = []
  
  //MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = UIColor.clearColor()
    fatalError("init(coder:) has not been implemented")
  }

  override func drawRect(rect: CGRect) {
    let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextSetLineWidth(ctx, kLockLineWidth)
    kColorIndicatorNormal.set()
    
    let pathM: CGMutablePathRef = CGPathCreateMutable()
    let margin: CGFloat = 5.0
    let padding: CGFloat = 1.0
    let rectWH: CGFloat = (bounds.size.width - margin * 2 * 3 - padding * 2)/3
    for i in 0 ..< 9 {
      let row: Int = i % 3
      let col: Int = i / 3
      let rectX: CGFloat = (rectWH + margin) * CGFloat(row) + padding
      let rectY: CGFloat = (rectWH + margin) * CGFloat(col) + padding
      let rect: CGRect = CGRectMake(rectX, rectY, rectWH, rectWH)
      CGPathAddEllipseInRect(pathM, nil, rect)

      //重画:实心圆
      for j in 0 ..< _selectedArray.count {
        if i == _selectedArray[j] {
          let circlePath: CGMutablePathRef = CGPathCreateMutable()
          CGPathAddEllipseInRect(circlePath, nil, rect)
          CGContextAddPath(ctx, circlePath)
          CGContextFillPath(ctx)
        }
      }
    }
    
    CGContextAddPath(ctx, pathM)
    CGContextStrokePath(ctx)
    
    debugPrint("\(NSDate().timeIntervalSinceNow)")

  }
  
}

extension LockIndicatorView {
  
  func setSelectedArray(selectArray: [Int]) {
    debugPrint("selectedArray = \(selectArray)")
    _selectedArray = selectArray
    self.setNeedsDisplay()
  }
}

extension LockIndicatorView {
  
  private func circleSelected(ctx: CGContextRef, rect: CGRect) {
    let circlePath: CGMutablePathRef = CGPathCreateMutable()
    CGPathAddEllipseInRect(circlePath, nil, self.getselectedRect())
    CGContextAddPath(ctx, circlePath)
    CGContextFillPath(ctx)
  }
  
  private func getselectedRect() -> CGRect {
      let rect: CGRect = self.bounds
      let selectRectWH: CGFloat = rect.size.width * CoreLockArcWHR
      let selectRectXY: CGFloat = rect.size.width * (1 - CoreLockArcWHR) * 0.5
      let _selectedRect = CGRectMake(selectRectXY, selectRectXY, selectRectWH, selectRectWH)
    return _selectedRect
  }
  
}