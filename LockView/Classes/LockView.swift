//
//  LockView.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/9.
//  Copyright © 2015年 yuanjilee. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

/// 整个解锁图案随手势的绘制过程及状态
///
/// 参数: 无
///
///
/// @since 1.0
/// @author yuanjilee
class LockView: UIView {

  //MARK: - commons
  
  let marginValue: CGFloat   = 35 * (UIScreen.main.bounds.size.width / 320.0)
  fileprivate var _isColorDefault: Bool   = false
  fileprivate var _dalaytimeMsecond: Int = 100
  
  
  //MARK: - Property
  
  weak var delegate: LockViewDelegate?
  fileprivate var _itemViewsM: [LockItemView] = []
  fileprivate var _nowPoint:   CGPoint = CGPoint.zero
  fileprivate var _itemView: LockItemView!
  
  
  //MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear
    _prepare()
    debugPrint("marginValue =  \(marginValue), \(UIScreen.main.bounds.size.width)")
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clear
    _prepare()
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    if _itemViewsM.count == 0 {return}
    
    let ctx: CGContext = UIGraphicsGetCurrentContext()!
    ctx.addRect(rect)
    
    for(_,itemView) in _itemViewsM.enumerated() {
      ctx.addEllipse(in: itemView.frame)
    }
    ctx.clip()
    let pathM: CGMutablePath = CGMutablePath()
    
    //线条颜色
    (_isColorDefault ? kColorLineError : kColorLineNormal).set()
    ctx.setLineCap(.round)
    ctx.setLineJoin(.round)
    
    //线条宽度
    ctx.setLineWidth(4.0)
    
    for(index,itemView) in _itemViewsM.enumerated() {
      let directPoint: CGPoint = itemView.center
      if index == 0 {
        pathM.move(to: CGPoint(x: directPoint.x, y: directPoint.y))
      } else {
        pathM.addLine(to: CGPoint(x: directPoint.x, y: directPoint.y))
      }
    }
    
    let lastView: LockItemView = _itemViewsM.last!
    ctx.move(to: CGPoint(x: lastView.center.x, y: lastView.center.y))
    ctx.addLine(to: CGPoint(x: _nowPoint.x, y: _nowPoint.y))
    
    ctx.addPath(pathM)
    ctx.strokePath()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      let itemViewWH: CGFloat = 50
      let padding: CGFloat = 50
      let marginx: CGFloat = (bounds.size.width - itemViewWH * 3 - padding * 2) / 2.0
      let marginy: CGFloat = 45
      for(index,subview) in subviews.enumerated() {
        let row: Int = index % 3
        let col: Int = index / 3
        let x: CGFloat = marginx  + (itemViewWH + padding) * CGFloat(row)
        let y: CGFloat = marginy  + (itemViewWH + padding) * CGFloat (col)
        let frame: CGRect = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
        subview.tag = index
        subview.frame = frame
      }
    }
    else {
      let itemW = (44 / 376) * UIScreen.main.bounds.width
      let itemViewWH: CGFloat = (self.frame.size.width - (2 * itemW)) / 3.0
      
      for(index,subview) in subviews.enumerated() {
        let row: Int = index % 3
        let col: Int = index / 3
        let x: CGFloat = itemW * CGFloat(row) + CGFloat(row) * itemViewWH
        let y: CGFloat = itemW * CGFloat(col) + CGFloat(col) * itemViewWH
        let frame: CGRect = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
        subview.tag = index
        subview.frame = frame
      }
    }
  }
  
}

extension LockView {
  fileprivate func _prepare() {
    for _ in 0 ..< 9 {
      _itemView = LockItemView()
      addSubview(_itemView)
    }
  }
  
  fileprivate func _lockHandle(_ touches: NSSet) {
    let touch: UITouch = touches.anyObject() as! UITouch
    let loc: CGPoint = touch.location(in: self)
    _nowPoint = loc
    let itemView = _itemVIewWithTouchLocation(loc)
    if itemView == nil {return}
    if let itemView: LockItemView = itemView {
      if _itemViewsM.contains(itemView) {return}
      _itemViewsM.append(itemView)
      _calDirect()
      _itemHandl(itemView)
    }
  }
  
  fileprivate func _itemVIewWithTouchLocation(_ loc: CGPoint) -> LockItemView? {
    var itemView: LockItemView!
    for itemViewSub in subviews {
      if !itemViewSub.frame.contains(loc) {continue}
      itemView = itemViewSub as? LockItemView
      break
    }
      return itemView
  }
  
  fileprivate func _calDirect() {
    let count: Int = _itemViewsM.count
    if count <= 1 {return}
    let last_1_itemView = _itemViewsM.last
    let last_2_itemView = _itemViewsM[count - 2]
    
    let last_1_x = last_1_itemView?.frame.origin.x
    let last_1_y = last_1_itemView?.frame.origin.y
    let last_2_x = last_2_itemView.frame.origin.x
    let last_2_y = last_2_itemView.frame.origin.y
    
    if(last_2_x == last_1_x && last_2_y > last_1_y) {
      last_2_itemView.direct = .top;
    }
    
    //正左
    if(last_2_y == last_1_y && last_2_x > last_1_x) {
      last_2_itemView.direct = .left;
    }
    
    //正下
    if(last_2_x == last_1_x && last_2_y < last_1_y) {
      last_2_itemView.direct = .bottom;
    }
    
    //正右
    if(last_2_y == last_1_y && last_2_x < last_1_x) {
      last_2_itemView.direct = .right;
    }
    
    //左上
    if(last_2_x > last_1_x && last_2_y > last_1_y) {
      last_2_itemView.direct = .leftTop;
    }
    
    //右上
    if(last_2_x < last_1_x && last_2_y > last_1_y) {
      last_2_itemView.direct = .rightTop;
    }
    
    //左下
    if(last_2_x > last_1_x && last_2_y < last_1_y) {
      last_2_itemView.direct = .leftBottom;
    }
    
    //右下
    if(last_2_x < last_1_x && last_2_y < last_1_y) {
      last_2_itemView.direct = .rightBottom;
    }
  }
  
  fileprivate func _gestureEnd() {
    isUserInteractionEnabled = false
    
    //生成密码串
    var passCode: String = ""
    var passcodeArray:[Int] = []
    for i in 0 ..< _itemViewsM.count {
      let selectedView: LockItemView = _itemViewsM[i]
      //生成Int数组
      passcodeArray.append(selectedView.tag)
      passCode = passCode + String(selectedView.tag)
    }
    if passCode.count > 0 {
      delegate?.lockViewDelegate(self, passCode: passCode, selectedArray: passcodeArray)
    }
    
    let time: DispatchTime = DispatchTime.now() + Double(Int64(_dalaytimeMsecond) * Int64(USEC_PER_SEC)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
      self._isColorDefault = false
      for itemView in self._itemViewsM {
        itemView.selected = false
        //清空方向
        itemView.direct = .never
        //清空颜色
        itemView.isDefaultColor = false
      }
      self._itemViewsM.removeAll()
      self.setNeedsDisplay()
      self.isUserInteractionEnabled = true
    }
    //恢复默认值
    _dalaytimeMsecond = 100
  }
  
  fileprivate func _itemHandl(_ itemView: LockItemView) {
    itemView.selected = true
    setNeedsDisplay()
    
  }
  
}

extension LockView {
  
  
  //MARK: - Public function
  
   func showErrorLockView() {
    
    _isColorDefault = true
    _dalaytimeMsecond = 500

    for i in 0 ..< _itemViewsM.count {
      _itemViewsM[i].isDefaultColor = true
      _itemViewsM[i].setNeedsDisplay()
    }
    
    setNeedsDisplay()
  }
  
  func showDismissLockView() {
    _isColorDefault = false
    _dalaytimeMsecond = 5000
    setNeedsDisplay()
  }
}

extension LockView: UIGestureRecognizerDelegate {
  
  //MARK: - Touches Event
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    _lockHandle(touches as NSSet)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    _lockHandle(touches as NSSet)
    self.setNeedsDisplay()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    _gestureEnd()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    _gestureEnd()
  }
}

protocol LockViewDelegate: NSObjectProtocol {
  func lockViewDelegate(_ lockView: LockView, passCode: String, selectedArray: [Int])
}
