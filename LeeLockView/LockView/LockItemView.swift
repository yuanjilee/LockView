//
//  LockItemView.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/9.
//  Copyright © 2015年 yuanjilee. All rights reserved.
//

/**
  abstract: 绘制单个手势圆形图形，以及选中状态、错误状态
*/

import UIKit

class LockItemView: UIView {

  enum LockItemViewDirect: Int {
    
    case Never = 0
    
    case Top
    
    case RightTop
    
    case Right
    
    case RightBottom
    
    case Bottom
    
    case LeftBottom
    
    case Left
    
    case LeftTop
    
  }
  
  
  //MARK: Commons
  
  let CoreLockArcWHR: CGFloat = 0.3
  let CoreLockArcLineW: CGFloat = 1.0
  var isDefaultColor: Bool = false
  
  
  //MARK: - Property
  
  /** 是否选中 */
  var selected: Bool = false{
    didSet {
      setNeedsDisplay()
    }
  }
  
  /** 方向 */
  var direct: LockItemViewDirect! {
    didSet {
      _angle = M_PI_4 * Double(direct.rawValue - 1)
      setNeedsDisplay()
    }
  }

  private var _calRect: CGRect = CGRectZero
  private var _angle: Double = 0
  private var _selectedRect: CGRect = CGRectZero

  //MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clearColor()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clearColor()
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    let ctx:CGContextRef = UIGraphicsGetCurrentContext()!
    _transFormCtx(ctx, rect: rect)
    _propertySetting(ctx)
    _circleNormal(ctx, rect: rect)
    
    if selected {
      _circleSelected(ctx, rect: rect)
      _directFlag(ctx, rect: rect)
    }
  }
}

extension LockItemView {
  
  private func _transFormCtx(ctx: CGContextRef, rect: CGRect){
    
    if direct == nil {return}
    if direct == .Never {return}
    
    let translateXY = rect.size.width * 0.5;
    CGContextTranslateCTM(ctx, translateXY, translateXY)
    CGContextRotateCTM(ctx, CGFloat(_angle))
    CGContextTranslateCTM(ctx, -translateXY, -translateXY)
  }
  
  private func _directFlag(ctx: CGContextRef, rect: CGRect) {
    
    //初始化为空,直接return
    if direct == nil {return}
    //手势结束时,重置为.Never,直接返回
    if direct == .Never {return}
    debugPrint("------------->directe =  \(direct)    and raw = \(direct.rawValue)")
    
    let trianglePathM: CGMutablePathRef = CGPathCreateMutable()
    let marginSelectedCirclev: CGFloat = 4.0
    let selectedRect: CGRect = self.getselectedRect()
    let w: CGFloat = 8.0
    let h: CGFloat = 5.0
    let topX: CGFloat = rect.origin.x + rect.size.width * 0.5
    let topY: CGFloat = rect.origin.y + (rect.size.width * 0.5 - h - marginSelectedCirclev - selectedRect.size.height * 0.5)
    CGPathMoveToPoint(trianglePathM, nil, topX, topY)
    
    let leftPointX: CGFloat = topX - w * 0.5
    let leftPointY = topY + h
    CGPathAddLineToPoint(trianglePathM, nil, leftPointX, leftPointY)
    
    let rightPointX: CGFloat = topX + w * 0.5
    CGPathAddLineToPoint(trianglePathM, nil, rightPointX, leftPointY)
    
    CGContextAddPath(ctx, trianglePathM)
    CGContextFillPath(ctx)
  }
  
  private func _propertySetting(ctx: CGContextRef) {
    CGContextSetLineWidth(ctx, CoreLockArcLineW)
    (isDefaultColor ? kColorItemError : kColorItemNormal).set()
  }
  
  private func _circleNormal(ctx: CGContextRef, rect: CGRect) {
    let loopPath: CGMutablePathRef = CGPathCreateMutable()
    let calRect: CGRect = self.getcalRect()
    CGPathAddEllipseInRect(loopPath, nil, calRect)
    CGContextAddPath(ctx, loopPath)
    CGContextStrokePath(ctx)
  }

  private func _circleSelected(ctx: CGContextRef, rect: CGRect) {
    let circlePath: CGMutablePathRef = CGPathCreateMutable()
    CGPathAddEllipseInRect(circlePath, nil, self.getselectedRect())
    CGContextAddPath(ctx, circlePath)
    CGContextFillPath(ctx)
  }
  
  //MARK: - Getter
  
  private func getcalRect() -> CGRect {
    if CGRectEqualToRect(_calRect, CGRectZero) {
      let lineW: CGFloat = CoreLockArcLineW
      let sizeWH: CGFloat = bounds.size.width - lineW
      let orginXY = lineW * 0.5
      _calRect = CGRectMake(orginXY, orginXY, sizeWH, sizeWH)
    }
    return _calRect
  }
  
  private func getselectedRect() -> CGRect {
    if CGRectEqualToRect(_selectedRect, CGRectZero) {
      let rect: CGRect = self.bounds
      let selectRectWH: CGFloat = rect.size.width * CoreLockArcWHR
      let selectRectXY: CGFloat = rect.size.width * (1 - CoreLockArcWHR) * 0.5
      _selectedRect = CGRectMake(selectRectXY, selectRectXY, selectRectWH, selectRectWH)
    }
    return _selectedRect
  }
}

