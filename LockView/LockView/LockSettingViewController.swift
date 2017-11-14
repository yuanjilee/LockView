//
//  SettingViewController.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/14.
//  Copyright © 2015年 yuanjilee. All rights reserved.
//

import UIKit
import LocalAuthentication

/// 设置界面
///
/// 参数: 无
///
///
/// @since 1.0
/// @author yuanjilee
public class LockSettingViewController: UIViewController {
  
  //MARK: - Commons
  
  let cellIdentifier: String = "setting_identifier"
  let celltitle: [String] = [NSLocalizedString("PATTERN_PASSWORD", comment: ""),
                             NSLocalizedString("FINGERPRINT_UNLOCK", comment: ""),
                             NSLocalizedString("RESET_PASSWORD_GESTURE", comment: "")]
  
  
  //MARK: - Property
  
  fileprivate var _gestureSwith: UISwitch!
  fileprivate var _touchIDSwitch: UISwitch!
  fileprivate var _tableView: UITableView!
  
  //MARK: - Lifecycle
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    _setupApperance()
    
  }
 
}

extension LockSettingViewController {
  
  //MARK: - UI
  
  fileprivate func _setGestureSwitch(_ superView: UIView) {
    _gestureSwith = UISwitch()
    _gestureSwith.addTarget(self, action: #selector(LockSettingViewController._gestureSwitchDidClick), for: .valueChanged)
    _gestureSwith.isOn = LockInfoStorage.getSwitchState()
    superView.addSubview(_gestureSwith)
    _gestureSwith.translatesAutoresizingMaskIntoConstraints = false
    superView.addConstraints([NSLayoutConstraint(item: _gestureSwith, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: -16),
                         NSLayoutConstraint(item: _gestureSwith, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)])
  }
  
  fileprivate func _setTouchIDSwitch(_ superView: UIView) {
    _touchIDSwitch = UISwitch()
    _touchIDSwitch.addTarget(self, action: #selector(LockSettingViewController._TouchIDSwitchDidClick(_:)), for: .valueChanged)
    _touchIDSwitch.isOn = LockInfoStorage.getTouchIDState()
    superView.addSubview(_touchIDSwitch)
    _touchIDSwitch.translatesAutoresizingMaskIntoConstraints = false
    superView.addConstraints([NSLayoutConstraint(item: _touchIDSwitch, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: -16),
                              NSLayoutConstraint(item: _touchIDSwitch, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)])
  }
  
  fileprivate func _setupApperance() {
    
    // 隐藏返回文字以及 navigationBar 透明属性
    
    view.backgroundColor = UIColor.white
    navigationItem.title = NSLocalizedString("GESTURE_LOCK", comment: "")
    navigationController?.navigationBar.isTranslucent = false
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    let backButtonImage: UIImage = UIImage(named: "navigation_back")!
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.backIndicatorImage = backButtonImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    
    _tableView = UITableView(frame: view.bounds, style: .grouped)
    _tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    _tableView.delegate = self
    _tableView.dataSource = self
    view.addSubview(_tableView)
  }
}

extension LockSettingViewController {
  
  //MARK: - Event
  
  @objc fileprivate func _gestureSwitchDidClick() {
    let switchState: Bool = _gestureSwith.isOn
    LockInfoStorage.setSwitchState(withBoolValue: switchState)
    _tableView.reloadData()
    //改为动画刷新 TODO: lyj.step@gmail.com
//    let range: NSRange = NSRange(location: 0, length: 2)
//    _tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: .Fade)
  }
  
  @objc fileprivate func _TouchIDSwitchDidClick(_ sender: UISwitch) {
    let switchState: Bool = sender.isOn
    LockInfoStorage.setTouchIDState(withBoolValue: switchState)
  }
}

extension LockSettingViewController: UITableViewDelegate, UITableViewDataSource {
  
  //MARK: - UITableViewDataSource
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let switchState: Bool = LockInfoStorage.getSwitchState()
    if !switchState{
      return 1
    }
    else {
      if section == 0{
          if _isSupportTouchID() {
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
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    if (indexPath as NSIndexPath).section == 0 {
      
      let switchState: Bool = LockInfoStorage.getSwitchState()
      if switchState {
          if _isSupportTouchID(){
            if (indexPath as NSIndexPath).row == 1{
              cell.textLabel?.text = celltitle[1]
              if _touchIDSwitch != nil {}
              else {
                _setTouchIDSwitch(cell.contentView)
              }
            }
          }
      }
      if (indexPath as NSIndexPath).row == 0 {
        cell.textLabel?.text = celltitle[0]
        if _gestureSwith != nil {}
        else {
          _setGestureSwitch(cell.contentView)
        }
      }
    }
    else {
      cell.textLabel?.text = celltitle[2]
      cell.accessoryType = .disclosureIndicator
    }
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    return cell
  }
  
  //MARK: - UITableViewDelegate
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    let switchState: Bool = LockInfoStorage.getSwitchState()
    if !switchState {
      return 1
    }
    else {
      return 2
    }
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if (indexPath as NSIndexPath).section == 1 {
      _ = LockViewController.showSettingLockViewController(self)
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 3
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
}

extension LockSettingViewController {
  
  //MARK: - 是否支持TouchID
  
  fileprivate func _isSupportTouchID() -> Bool {
    let context: LAContext = LAContext()
    var authorError: NSError?
    
    var result: Bool = false
    
    if #available(iOS 9.0, *)  {
      result = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorError)
    } else {
      // Fallback on earlier versions
      result = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorError)
    }
    return result
  }
  
}
