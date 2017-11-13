//
//  IndicatorView.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/13.
//  Copyright © 2015年 yuanjilee. All rights reserved.
//

import UIKit

/// 指示器
///
/// 参数: 无
///
///
/// @since 1.0
/// @author yuanjilee
class LockIndicatorView: UIView {

  //MARK: - Common
  
  let kLockLineWidth: CGFloat = 1
  let CoreLockArcWHR: CGFloat = 0.3
  let CoreLockArcLineW: CGFloat = 1.0

  
  //MARK: -  Property
  
  fileprivate var _selectedArray: [Int] = []
  
  
  //MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clear
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clear
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let ctx: CGContext = UIGraphicsGetCurrentContext()!
    ctx.setLineWidth(kLockLineWidth)
    kColorIndicatorNormal.set()
    
    let pathM: CGMutablePath = CGMutablePath()
    let margin: CGFloat = 5.0
    let padding: CGFloat = 1.0
    let rectWH: CGFloat = (bounds.size.width - margin * 2 * 3 - padding * 2)/3
    for i in 0 ..< 9 {
      let row: Int = i % 3
      let col: Int = i / 3
      let rectX: CGFloat = (rectWH + margin) * CGFloat(row) + padding
      let rectY: CGFloat = (rectWH + margin) * CGFloat(col) + padding
      let rect: CGRect = CGRect(x: rectX, y: rectY, width: rectWH, height: rectWH)
      pathM.addEllipse(in: rect)

      //重画:实心圆
      for j in 0 ..< _selectedArray.count {
        if i == _selectedArray[j] {
          let circlePath: CGMutablePath = CGMutablePath()
          circlePath.addEllipse(in: rect)
          ctx.addPath(circlePath)
          ctx.fillPath()
        }
      }
    }
    
    ctx.addPath(pathM)
    ctx.strokePath()
  }
  
}

extension LockIndicatorView {
  
  func setSelectedArray(_ selectArray: [Int]) {
    debugPrint("selectedArray = \(selectArray)")
    _selectedArray = selectArray
    self.setNeedsDisplay()
  }
}

extension LockIndicatorView {
  
  fileprivate func circleSelected(_ ctx: CGContext, rect: CGRect) {
    let circlePath: CGMutablePath = CGMutablePath()
    circlePath.addEllipse(in: self.getselectedRect())
    ctx.addPath(circlePath)
    ctx.fillPath()
  }
  
  fileprivate func getselectedRect() -> CGRect {
      let rect: CGRect = self.bounds
      let selectRectWH: CGFloat = rect.size.width * CoreLockArcWHR
      let selectRectXY: CGFloat = rect.size.width * (1 - CoreLockArcWHR) * 0.5
      let _selectedRect = CGRect(x: selectRectXY, y: selectRectXY, width: selectRectWH, height: selectRectWH)
    return _selectedRect
  }
  
}
