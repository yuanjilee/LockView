//
//  SettingViewController.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/14.
//  Copyright © 2015年 Worktile. All rights reserved.
//

/**
  abstract: 设置界面 
*/

import UIKit
import LocalAuthentication

class LockSettingViewController: WTKViewController {
  
  //MARK: - Commons
  
  let cellIdentifier: String = "setting_identifier"
  let celltitle: [String] = [NSLocalizedString("PATTERN_PASSWORD", comment: ""),
                             NSLocalizedString("FINGERPRINT_UNLOCK", comment: ""),
                             NSLocalizedString("RESET_PASSWORD_GESTURE", comment: "")]
  
  //MARK: - Property
  
  private var _gestureSwith: UISwitch!
  private var _touchIDSwitch: UISwitch!
  private var _tableView: UITableView!
  
  //MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    hideNavigationButtonTitle = true
    navigationItem.title = NSLocalizedString("GESTURE_LOCK", comment: "")
    _tableView = UITableView(frame: view.bounds, style: .Grouped)
    _tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    _tableView.delegate = self
    _tableView.dataSource = self
    view.addSubview(_tableView)
  }
 
}

extension LockSettingViewController {
  
  //MARK: - UI
  
  private func _setGestureSwitch(superView: UIView) {
    _gestureSwith = UISwitch()
    _gestureSwith.addTarget(self, action: "_gestureSwitchDidClick", forControlEvents: .ValueChanged)
    _gestureSwith.on = LockInfoStorage.getSwitchState()
    superView.addSubview(_gestureSwith)
    _gestureSwith.snp_makeConstraints { (make) -> Void in
      make.trailing.equalTo(superView.snp_trailing).offset(-16)
      make.centerY.equalTo(superView.snp_centerY)
    }
  }
  private func _setTouchIDSwitch(superView: UIView) {
    _touchIDSwitch = UISwitch()
    _touchIDSwitch.addTarget(self, action: "_TouchIDSwitchDidClick:", forControlEvents: .ValueChanged)
    _touchIDSwitch.on = LockInfoStorage.getTouchIDState()
    superView.addSubview(_touchIDSwitch)
    _touchIDSwitch.snp_makeConstraints { (make) -> Void in
      make.trailing.equalTo(superView.snp_trailing).offset(-16)
      make.centerY.equalTo(superView.snp_centerY)
    }
  }
}

extension LockSettingViewController {
  
  //MARK: - Event
  
  internal func _gestureSwitchDidClick() {
    let switchState: Bool = _gestureSwith.on
    LockInfoStorage.setSwitchState(withBoolValue: switchState)
    debugPrint("--------state = \(switchState)")
    _tableView.reloadData()
    //改为动画刷新 TODO: liyuanji@worktile.com
//    let range: NSRange = NSRange(location: 0, length: 2)
//    _tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: .Fade)
  }
  
  internal func _TouchIDSwitchDidClick(let sender: UISwitch) {
    let switchState: Bool = sender.on
    LockInfoStorage.setTouchIDState(withBoolValue: switchState)
  }
}

extension LockSettingViewController: UITableViewDelegate, UITableViewDataSource {
  
  //MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let switchState: Bool = LockInfoStorage.getSwitchState()
    if !switchState{
      return 1
    }
    else {
      if section == 0{
          if self._isSupportTouchID() {
            return 2
          }
          else {
            return 1
          }
      }
      else {
        return 1
      }
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
    if indexPath.section == 0 {
      
      let switchState: Bool = LockInfoStorage.getSwitchState()
      if switchState {
          if self._isSupportTouchID(){
            if indexPath.row == 1{
              cell.textLabel?.text = celltitle[1]
              if _touchIDSwitch != nil {}
              else {
                _setTouchIDSwitch(cell.contentView)
              }
            }
          }
      }
      if indexPath.row == 0 {
        cell.textLabel?.text = celltitle[0]
        if _gestureSwith != nil {}
        else {
          _setGestureSwitch(cell.contentView)
        }
      }
    }
    else {
      cell.textLabel?.text = celltitle[2]
      cell.accessoryType = .DisclosureIndicator
    }
    cell.textLabel?.font = UIFont.systemFontOfSize(15)
    return cell
  }
  
  //MARK: - UITableViewDelegate
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    let switchState: Bool = LockInfoStorage.getSwitchState()
    if !switchState {
      return 1
    }
    else {
      return 2
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.section == 1 {
      LockViewController.showSettingLockViewController(self)
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 3
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 55
  }
}

extension LockSettingViewController {
  
  //MARK: - 是否支持TouchID
  
  func _isSupportTouchID() -> Bool {
    let context: LAContext = LAContext()
    var authorError: NSError?
    
    var result: Bool = false
    
    if #available(iOS 9.0, *)  {
      result = context.canEvaluatePolicy(.DeviceOwnerAuthentication, error: &authorError)
    } else {
      // Fallback on earlier versions
      result = context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &authorError)
    }
    return result
  }
  
}
