//
//  LockPreference.swift
//  Worktile
//
//  Created by yuanjilee on 15/12/30.
//  Copyright © 2015年 yuanjilee All rights reserved.
//

/**
*  界面颜色、大小等属性参数
*/
import Foundation
import UIKit

//MARK: - UIColor

/// 绘制过程线条颜色
let kColorLineNormal: UIColor = UIColor(red: 0.20, green: 0.84, blue: 0.73, alpha: 1.0)

/// 绘制错误线条颜色
let kColorLineError: UIColor   = UIColor(red: 0.99, green: 0.28, blue: 0.27, alpha: 1.0)

/// 解锁圆环边框色、实心色以及指示箭头色(正常状态)
let kColorItemNormal: UIColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.0)

/// 解锁圆环框色、实心色以及指示箭头色(选定状态)
let kColorItemSelected: UIColor = kColorLineNormal

/// 解锁圆环边框色、实心色以及指示箭头错误颜色
let kColorItemError: UIColor = kColorLineError

/// 提示文字颜色
let kTipColorNormal: UIColor = UIColor.black

/// 提示错误问题颜色
let kTipColorError: UIColor = kColorLineError

/// 指示图片空心以及实心颜色
let kColorIndicatorNormal: UIColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.0)

/// 忘记密码、指纹锁按钮字体颜色
let kForgetBtnColorNormal: UIColor  = UIColor.black

/// 验证页面背景颜色
let kVerifyBackgroundColor: UIColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)

/// 设置页面背景颜色

let kSettingBackgroundColor: UIColor = kVerifyBackgroundColor


//MARK: - UIFont

let kSmallFontSize: CGFloat = 13

let kNormalFontSize: CGFloat = 15
