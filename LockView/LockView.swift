//
//  LockView.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/9.
//  Copyright © 2015年 Worktile. All rights reserved.
//

/**
  abstract: 整个解锁图案随手势的绘制过程及状态
*/

import UIKit

class LockView: UIView {

  //MARK: - commons
  
  let marginValue: CGFloat   = 35 * (UIScreen.mainScreen().bounds.size.width / 320.0)
  var isColorDefault: Bool   = false
  var dalaytimeMsecond: Int = 100
  
  //MARK: - Property
  
  weak var delegate: LockViewDelegate?
  private var _itemViewsM: [LockItemView] = []
  private var _nowPoint:   CGPoint = CGPointZero
  var itemView: LockItemView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
    self.prepare()
    debugPrint("marginValue =  \(marginValue), \(UIScreen.mainScreen().bounds.size.width)")
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = UIColor.clearColor()
    self.prepare()
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    if _itemViewsM.count == 0 {return}
    
    let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextAddRect(ctx, rect)
    
    for(_,itemView) in _itemViewsM.enumerate() {
      CGContextAddEllipseInRect(ctx, itemView.frame)
    }
    CGContextEOClip(ctx)
    let pathM: CGMutablePathRef = CGPathCreateMutable()
    
    //线条颜色
    (isColorDefault ? kColorLineError : kColorLineNormal).set()
    CGContextSetLineCap(ctx, .Round)
    CGContextSetLineJoin(ctx, .Round)
    
    //线条宽度
    CGContextSetLineWidth(ctx, 4.0)
    
    for(index,itemView) in _itemViewsM.enumerate() {
      let directPoint: CGPoint = itemView.center
      if index == 0 {
        CGPathMoveToPoint(pathM, nil, directPoint.x, directPoint.y)
      } else {
        CGPathAddLineToPoint(pathM, nil, directPoint.x, directPoint.y)
      }
    }
    
    let lastView: LockItemView = _itemViewsM.last!
    CGContextMoveToPoint(ctx, lastView.center.x, lastView.center.y)
    CGContextAddLineToPoint(ctx, _nowPoint.x, _nowPoint.y)
    
    CGContextAddPath(ctx, pathM)
    CGContextStrokePath(ctx)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      let itemViewWH: CGFloat = 60
      let padding: CGFloat = 50
      let marginx: CGFloat = (bounds.size.width - itemViewWH * 3 - padding * 2) / 2.0
      let marginy: CGFloat = 45
      for(index,subview) in subviews.enumerate() {
        let row: Int = index % 3
        let col: Int = index / 3
        let x: CGFloat = marginx  + (itemViewWH + padding) * CGFloat(row)
        let y: CGFloat = marginy  + (itemViewWH + padding) * CGFloat (col)
        let frame: CGRect = CGRectMake(x, y, itemViewWH, itemViewWH)
        subview.tag = index
        subview.frame = frame
        debugPrint("yyyyyyyy === \(itemViewWH, x, y, marginx, marginy, bounds.size)")
      }
    }
    else {
      let itemViewWH: CGFloat = (self.frame.size.width - 4 * marginValue) / 3.0
      for(index,subview) in subviews.enumerate() {
        let row: Int = index % 3
        let col: Int = index / 3
        let x: CGFloat = marginValue * CGFloat(row + 1) + CGFloat(row) * itemViewWH
        let y: CGFloat = marginValue * CGFloat(col + 1) + CGFloat(col) * itemViewWH
        let frame: CGRect = CGRectMake(x, y, itemViewWH, itemViewWH)
        subview.tag = index
        subview.frame = frame
      }
    }
  }
  
}

extension LockView {
  private func prepare() {
    for (var i = 0; i < 9; i++) {
      itemView = LockItemView()
      self.addSubview(itemView)
    }
  }
  
  private func lockHandle(touches: NSSet) {
    let touch: UITouch = touches.anyObject() as! UITouch
    let loc: CGPoint = touch.locationInView(self)
    _nowPoint = loc
    let itemView = self.itemVIewWithTouchLocation(loc)
    if itemView == nil {return}
    if let itemView: LockItemView = itemView {
      if _itemViewsM.contains(itemView) {return}
      _itemViewsM.append(itemView)
      self.calDirect()
      self.itemHandl(itemView)
    }
  }
  
  private func itemVIewWithTouchLocation(loc: CGPoint) -> LockItemView? {
    var itemView: LockItemView!
    for itemViewSub in self.subviews {
      if !CGRectContainsPoint(itemViewSub.frame, loc) {continue}
      itemView = itemViewSub as? LockItemView
      break
    }
      return itemView
  }
  
  private func calDirect() {
    let count: Int = _itemViewsM.count
    if count <= 1 {return}
    let last_1_itemView = _itemViewsM.last
    let last_2_itemView = _itemViewsM[count - 2]
    
    let last_1_x = last_1_itemView?.frame.origin.x
    let last_1_y = last_1_itemView?.frame.origin.y
    let last_2_x = last_2_itemView.frame.origin.x
    let last_2_y = last_2_itemView.frame.origin.y
    
    if(last_2_x == last_1_x && last_2_y > last_1_y) {
      last_2_itemView.direct = .Top;
    }
    
    //正左
    if(last_2_y == last_1_y && last_2_x > last_1_x) {
      last_2_itemView.direct = .Left;
    }
    
    //正下
    if(last_2_x == last_1_x && last_2_y < last_1_y) {
      last_2_itemView.direct = .Bottom;
    }
    
    //正右
    if(last_2_y == last_1_y && last_2_x < last_1_x) {
      last_2_itemView.direct = .Right;
    }
    
    //左上
    if(last_2_x > last_1_x && last_2_y > last_1_y) {
      last_2_itemView.direct = .LeftTop;
    }
    
    //右上
    if(last_2_x < last_1_x && last_2_y > last_1_y) {
      last_2_itemView.direct = .RightTop;
    }
    
    //左下
    if(last_2_x > last_1_x && last_2_y < last_1_y) {
      last_2_itemView.direct = .LeftBottom;
    }
    
    //右下
    if(last_2_x < last_1_x && last_2_y < last_1_y) {
      last_2_itemView.direct = .RightBottom;
    }
  }
  
  private func gestureEnd() {
    self.userInteractionEnabled = false
    
    //生成密码串
    var passCode: String = ""
    var passcodeArray:[Int] = []
    for (var i = 0; i < _itemViewsM.count; i++) {
      let selectedView: LockItemView = _itemViewsM[i]
      //生成Int数组
      passcodeArray.append(selectedView.tag)
      passCode = passCode.stringByAppendingString(String(selectedView.tag))
    }
    if passCode.characters.count > 0 {
      delegate?.lockViewDelegate(self, passCode: passCode, selectedArray: passcodeArray)
    }
    
    let time: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(dalaytimeMsecond) * Int64(USEC_PER_SEC))
    dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
      self.isColorDefault = false
      for itemView in self._itemViewsM {
        itemView.selected = false
        //清空方向
        itemView.direct = .Never
        //清空颜色
        itemView.isDefaultColor = false
      }
      self._itemViewsM.removeAll()
      self.setNeedsDisplay()
      self.userInteractionEnabled = true
    }
    //恢复默认值
    dalaytimeMsecond = 100
  }
  
  private func itemHandl(itemView: LockItemView) {
    itemView.selected = true
    self.setNeedsDisplay()
    
  }
  
}

extension LockView {
  
  //MARK: - Public function
  
   func showErrorLockView() {
    
    isColorDefault = true
    dalaytimeMsecond = 500

    for i in 0 ..< _itemViewsM.count {
      _itemViewsM[i].isDefaultColor = true
      _itemViewsM[i].setNeedsDisplay()
    }
    
    self.setNeedsDisplay()
    
  }
  
  func showDismissLockView() {
    isColorDefault = false
    dalaytimeMsecond = 5000
    self.setNeedsDisplay()
  }
}

extension LockView: UIGestureRecognizerDelegate {
  
  //MARK: - Touches Event
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.lockHandle(touches)
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.lockHandle(touches)
    self.setNeedsDisplay()
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.gestureEnd()
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    self.gestureEnd()
  }
}

protocol LockViewDelegate: NSObjectProtocol {
  func lockViewDelegate(lockView: LockView, passCode: String, selectedArray: [Int])
}
