//
//  LockUtils.swift
//  LockView
//
//  Created by yuanjilee on 2017/11/30.
//

import UIKit
import LocalAuthentication

// MARK: - Enum

enum BiometryType: Int {
  
  /// The device does not support biometry.
  case none
  
  /// The device supports Touch ID.
  case typeTouchID
  
  /// The device supports Face ID.
  case typeFaceID
}

/// Lock Utils
///
/// 参数: 无
///
///
/// @since 3.1.0
/// @author yuanjilee
class LockUtils {
  
  static func getBiometryType() -> BiometryType {
    
    let context: LAContext = LAContext()
    var authorError: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorError) {
      if #available(iOS 11.0, *) {
        if context.biometryType == .none {
          return .none
        } else if context.biometryType == .typeFaceID {
          return .typeFaceID
        } else if context.biometryType == .typeTouchID {
          return .typeTouchID
        }
      } else {
        return .typeTouchID
      }
    } else {
      return .none
    }
    return .none
  }
}


extension UIViewController {
  
  // MARK: - SafeArea
  
  public var lee_safeAreaInsets: UIEdgeInsets {
    if #available(iOS 11, *) {
      return view.safeAreaInsets
    }
    return UIEdgeInsets(top: topLayoutGuide.length, left: 0.0, bottom: bottomLayoutGuide.length, right: 0.0)
  }
  
  public var lee_safeAreaFrame: CGRect {
    if #available(iOS 11, *) {
      return view.safeAreaLayoutGuide.layoutFrame
    }
    return UIEdgeInsetsInsetRect(view.bounds, lee_safeAreaInsets)
  }
  
  public var lee_keyWindowSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11, *) {
      if let window = UIApplication.shared.keyWindow {
        return window.safeAreaInsets
      }
      return .zero
    }
    return .zero
  }
  
}
