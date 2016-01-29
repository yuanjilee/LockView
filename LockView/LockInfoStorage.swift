//
//  LockInfoStorage.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/13.
//  Copyright © 2015年 Worktile. All rights reserved.
//

/**
  abstract: 数据存储
*/

import UIKit

class LockInfoStorage: NSObject {
  
  private static let kPassCodeKey: String = "LockPassCodeKey"
  private static let kTouchIDSwitchKey: String = "touchIDSwitchKey"
  private static let kGestureSwitchKey: String = "gestureSwithKey"
  
  // passcode
  class func setLockInfo(withString str: String) {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(str, forKey: kPassCodeKey)
    defaults.synchronize()
  }
  
  class func getLockInfo() -> String? {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let lockInfo: String? =  defaults.objectForKey(kPassCodeKey) as? String
    return lockInfo
  }
  
  // switch
  class func setSwitchState(withBoolValue value: Bool) {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(value, forKey: kGestureSwitchKey)
    defaults.synchronize()
  }

  class func getSwitchState() -> Bool {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let switchState: Bool? = defaults.objectForKey(kGestureSwitchKey) as? Bool
    if let switchState = switchState {
      return switchState
    }
    else {
      return false
    }
  }
  
  
  // touchID
  class func setTouchIDState(withBoolValue value: Bool) {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(value, forKey: kTouchIDSwitchKey)
    defaults.synchronize()
  }

  class func getTouchIDState() -> Bool {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let touchIDState: Bool? = defaults.objectForKey(kTouchIDSwitchKey) as? Bool
    if let touchIDState = touchIDState {
      return touchIDState
    }
    else {
      return false
    }
  }
  
  
  //clear
  class func clearAllGestureLockInfo() {
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(nil, forKey: kPassCodeKey)
    defaults.setBool(false, forKey: kTouchIDSwitchKey)
    defaults.setBool(false, forKey: kGestureSwitchKey)
  }
}


