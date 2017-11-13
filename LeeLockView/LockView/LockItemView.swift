//
//  LockItemView.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/9.
//  Copyright © 2015年 yuanjilee. All rights reserved.
//

import UIKit

/// 绘制单个手势圆形图形，以及选中状态、错误状态
///
/// 参数: 无
///
///
/// @since 1.0
/// @author yuanjilee
class LockItemView: UIView {

  enum LockItemViewDirect: Int {
    
    case never = 0
    
    case top
    
    case rightTop
    
    case right
    
    case rightBottom
    
    case bottom
    
    case leftBottom
    
    case left
    
    case leftTop
    
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
      _angle = .pi/4 * Double(direct.rawValue - 1)
      setNeedsDisplay()
    }
  }

  fileprivate var _calRect: CGRect = CGRect.zero
  fileprivate var _angle: Double = 0
  fileprivate var _selectedRect: CGRect = CGRect.zero

  //MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clear
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    let ctx:CGContext = UIGraphicsGetCurrentContext()!
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
  
  fileprivate func _transFormCtx(_ ctx: CGContext, rect: CGRect){
    
    if direct == nil {return}
    if direct == .never {return}
    
    let translateXY = rect.size.width * 0.5;
    ctx.translateBy(x: translateXY, y: translateXY)
    ctx.rotate(by: CGFloat(_angle))
    ctx.translateBy(x: -translateXY, y: -translateXY)
  }
  
  fileprivate func _directFlag(_ ctx: CGContext, rect: CGRect) {
    
    //初始化为空,直接return
    if direct == nil {return}
    //手势结束时,重置为.Never,直接返回
    if direct == .never {return}
    
    let trianglePathM: CGMutablePath = CGMutablePath()
    let marginSelectedCirclev: CGFloat = 4.0
    let selectedRect: CGRect = self.getselectedRect()
    let w: CGFloat = 8.0
    let h: CGFloat = 5.0
    let topX: CGFloat = rect.origin.x + rect.size.width * 0.5
    let topY: CGFloat = rect.origin.y + (rect.size.width * 0.5 - h - marginSelectedCirclev - selectedRect.size.height * 0.5)
    trianglePathM.move(to: CGPoint(x: topX, y: topY))
    
    let leftPointX: CGFloat = topX - w * 0.5
    let leftPointY = topY + h
    trianglePathM.addLine(to: CGPoint(x: leftPointX, y: leftPointY))
    
    let rightPointX: CGFloat = topX + w * 0.5
    trianglePathM.addLine(to: CGPoint(x: rightPointX, y: leftPointY))
    
    ctx.addPath(trianglePathM)
    (isDefaultColor ? kColorItemError : kColorItemSelected).set()
    ctx.fillPath()
  }
  
  fileprivate func _propertySetting(_ ctx: CGContext) {
    ctx.setLineWidth(CoreLockArcLineW)
    (isDefaultColor ? kColorItemError : kColorItemNormal).set()
  }
  
  fileprivate func _circleNormal(_ ctx: CGContext, rect: CGRect) {
    let loopPath: CGMutablePath = CGMutablePath()
    let calRect: CGRect = self.getcalRect()
    loopPath.addEllipse(in: calRect)
    ctx.addPath(loopPath)
    kColorItemNormal.set()
    ctx.strokePath()
  }

  fileprivate func _circleSelected(_ ctx: CGContext, rect: CGRect) {
    // 空心外圆
    let loopPath: CGMutablePath = CGMutablePath()
    let calRect: CGRect = self.getcalRect()
    loopPath.addEllipse(in: calRect)
    ctx.addPath(loopPath)
    (isDefaultColor ? kColorItemError : kColorItemSelected).set()
    ctx.strokePath()
    
    // 实心内圆
    let circlePath: CGMutablePath = CGMutablePath()
    circlePath.addEllipse(in: self.getselectedRect())
    ctx.addPath(circlePath)
    (isDefaultColor ? kColorItemError : kColorItemSelected).set()
    ctx.fillPath()
  }
  
  //MARK: - Getter
  
  fileprivate func getcalRect() -> CGRect {
    if _calRect.equalTo(CGRect.zero) {
      let lineW: CGFloat = CoreLockArcLineW
      let sizeWH: CGFloat = bounds.size.width - lineW
      let orginXY = lineW * 0.5
      _calRect = CGRect(x: orginXY, y: orginXY, width: sizeWH, height: sizeWH)
    }
    return _calRect
  }
  
  fileprivate func getselectedRect() -> CGRect {
    if _selectedRect.equalTo(CGRect.zero) {
      let rect: CGRect = self.bounds
      let selectRectWH: CGFloat = rect.size.width * CoreLockArcWHR
      let selectRectXY: CGFloat = rect.size.width * (1 - CoreLockArcWHR) * 0.5
      _selectedRect = CGRect(x: selectRectXY, y: selectRectXY, width: selectRectWH, height: selectRectWH)
    }
    return _selectedRect
  }
}

