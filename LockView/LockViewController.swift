//
//  LockViewController.swift
//  LeeGesturesPassword
//
//  Created by yuanjilee on 15/10/12.
//  Copyright © 2015年 Worktile. All rights reserved.
//

/**
  abstract: 绘制完手势后的事件处理 (Setting + Verifiy)
*/

import UIKit
import LocalAuthentication

class LockViewController: WTKViewController {
  
  enum LockType: String {
    
    case Setting = "Setting"
    
    case Verify = "Verify"
    
    case Modify = "Modify"
  }
  
  //MARK: - Commons
  
  var lock: LockView!
  var indicator: LockIndicatorView!
  let SCREEN_SIZE: CGSize = UIScreen.mainScreen().bounds.size
  let kpassCodeAttemptAmount: Int = 4
  let LCK_DEFAULT_CORNER_RADIUS = 5.0
  
  //MARK: - Property
  
  var lockType: LockType = .Setting
  private var _lockTitleLabel: UILabel?
  private var _avatarImageView: UIImageView!
  //三步提示
  private var _tip1: String = ""
  private var _tip2: String = ""
  private var _tip3: String = ""
  //密码
  private var _passcodefirst: String = ""
  private var _passcodeConfirm: String = ""
  private var _passcodeSaved: String = ""
  private var _passcodeAttemtCount: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _setupApperance()
    
    _prepare()
    
    // TouchID
    let isOpenTouchIDSwitch = LockInfoStorage.getTouchIDState()
    if isOpenTouchIDSwitch {
      _touchID()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.translucent = true
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.translucent = false
  }
}

extension LockViewController {
  
  private func _prepare() {
    lock = LockView()
    lock.delegate = self
    view.addSubview(lock)
    
    switch lockType {
      
    case .Setting:
      self._initIndicatorView()
      self._initLockTitleLabel()
      _lockTitleLabel?.text = NSLocalizedString("DRAW_GESTURE_PASSWORD", comment: "")

    case .Verify:
      
      self._initView()
      self._initAvatarImageView()
      self._initLockTitleLabel()
      _lockTitleLabel?.text = NSLocalizedString("ENTER_THE_GESTURE_PASSWORD", comment: "")
      
    default:
      break
    }
    _initLockView()
  }
  
  private func _initView() {
    let forgetBtn: UIButton = UIButton(type: .Custom)
    forgetBtn.addTarget(self, action: "_forgetBtnClick", forControlEvents: .TouchUpInside)
    forgetBtn.setTitle(NSLocalizedString("FORGET_PASSWORD", comment: ""), forState: .Normal)
    forgetBtn.setTitleColor(kForgetBtnColorNormal, forState: .Normal)
    forgetBtn.titleLabel?.font = UIFont.systemFontOfSize(kSmallFontSize)
    view.addSubview(forgetBtn)
    forgetBtn.snp_makeConstraints { (make) -> Void in
      make.centerX.equalTo(view.snp_centerX)
      make.bottom.equalTo(view.snp_bottom).offset(-10)
    }
    
    let isOpenTouchIDSwitch = LockInfoStorage.getTouchIDState()
    if isOpenTouchIDSwitch {
      let fingerBtn: UIButton = UIButton(type: .Custom)
      fingerBtn.addTarget(self, action: "_touchID", forControlEvents: .TouchUpInside)
      fingerBtn.setTitle(NSLocalizedString("FINGERPRINT_UNLOCK", comment: ""), forState: .Normal)
      fingerBtn.setTitleColor(kForgetBtnColorNormal, forState: .Normal)
      fingerBtn.titleLabel?.font = UIFont.systemFontOfSize(kSmallFontSize)
      view.addSubview(fingerBtn)
      fingerBtn.snp_makeConstraints { (make) -> Void in
        make.trailing.equalTo(view.snp_trailing).offset(-20)
        make.bottom.equalTo(view.snp_bottom).offset(-10)
      }
      //忘记密码位置左移,并移除其上所有约束  或 snp_remakeContraints
      forgetBtn.removeConstraints(forgetBtn.constraints)
      for constraints in (forgetBtn.superview?.constraints)! {
        if constraints.firstItem.isEqual(forgetBtn) {
          forgetBtn.superview?.removeConstraint(constraints)
        }
      }
      forgetBtn.snp_makeConstraints { (make) -> Void in
        make.leading.equalTo(view.snp_leading).offset(20)
        make.bottom.equalTo(view.snp_bottom).offset(-10)
      }
    }
  }
  
  
  private func _initAvatarImageView() {
    
    if lockType == .Verify {
      _avatarImageView = UIImageView()
      _avatarImageView.layer.masksToBounds = true
      _avatarImageView.layer.cornerRadius = CGFloat(35)
      
      // 头像
      let me: WTCUser = WTCDirector.sharedDirector().me()
      _avatarImageView.WTK_setAvatarForUser(me, length: 35)
      
      view.addSubview(_avatarImageView)
      
      _avatarImageView.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(view.snp_top).offset(60)
        make.centerX.equalTo(view.snp_centerX)
        make.height.equalTo(70)
        make.width.equalTo(70)
      }
    }
  }
  
  private func _initIndicatorView() {
    indicator = LockIndicatorView()
    view.addSubview(indicator)
    indicator.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(view.snp_top).offset(24 + 20 + 64)
      make.centerX.equalTo(view.snp_centerX).offset(8)
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
  }
  
  private func _initLockTitleLabel() {
    if let _ = _lockTitleLabel {return}
    else {
      _lockTitleLabel = UILabel()
      view.addSubview(_lockTitleLabel!)
      _lockTitleLabel?.textAlignment = .Center
      _lockTitleLabel?.textColor = kTipColorNormal
      _lockTitleLabel?.font = UIFont.systemFontOfSize(kNormalFontSize)
      _lockTitleLabel?.snp_makeConstraints(closure: { (make) -> Void in
        make.leading.equalTo(view.snp_leading)
        make.trailing.equalTo(view.snp_trailing)
        if lockType == .Verify {
          make.top.equalTo(_avatarImageView.snp_bottom).offset(20)
        }
        else if lockType == .Setting {
          make.top.equalTo(indicator.snp_bottom).offset(0)
        }
        make.height.equalTo(20)
      })
    }
  }
  
  private func _initLockView() {
    lock.snp_makeConstraints { (make) -> Void in
      make.leading.equalTo(view.snp_leading)
      make.trailing.equalTo(view.snp_trailing)
      make.top.equalTo(_lockTitleLabel!.snp_bottom)
      make.height.equalTo(SCREEN_SIZE.width)
    }
  }
  
  //创建密码
  private func _creatPasscode(passcode: String) {
    
    if _passcodefirst == "" && _passcodeConfirm == ""{
      _passcodefirst = passcode
      self._setTip(_tip2)
      
    }
    else if _passcodefirst != "" && _passcodeConfirm == "" {
      _passcodeConfirm = passcode
      if _passcodefirst != _passcodeConfirm {
        debugPrint("与上次输入不一致，请重新设置");
        _tip2 = NSLocalizedString("INCORRECT_PATTERN", comment: "")
        _passcodeConfirm = ""
        _passcodefirst = ""
        self._setTip(_tip2)
        //置空
        indicator.setSelectedArray([])
        lock.showErrorLockView()
      }
      else {
        debugPrint("两次密码一致")
        self._setTip(_tip3)
        //设置成功,插入VC
        let lockInfo: String? = LockInfoStorage.getLockInfo()
        if lockInfo == nil {
          let setting:UIViewController = LockSettingViewController()
          let count = navigationController?.viewControllers.count
          navigationController?.viewControllers.insert(setting, atIndex: count!-1)
        }
        
        LockInfoStorage.setLockInfo(withString: _passcodefirst)
        LockInfoStorage.setSwitchState(withBoolValue: true)
        lock.showDismissLockView()
        //成功提示语
//        MBProgressHUD.showMessage("设置成功", hideAfterDelay: 1, complete: nil)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1000 * USEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
          self.navigationController?.popViewControllerAnimated(true)
        })
      }
    }
  }
  
  //验证密码
  private func _verifyPassCode(passcode: String) {
    let storageCode = LockInfoStorage.getLockInfo()
    if passcode == storageCode {
      dismissViewControllerAnimated(true, completion: nil)
    }
    else {
      if _passcodeAttemtCount <= 0 { // 连续输错五次密码
        dismissViewControllerAnimated(true) { () -> Void in
          //清空手势数据
          LockInfoStorage.clearAllGestureLockInfo()
        }
        _logout()
      }
      else {
        _passcodeAttemtCount--
        self._setErrorTip(_tip2)
      }
    }
  }
  
  private func _setTip(tip: String) {
    _lockTitleLabel?.text = tip
    _lockTitleLabel?.textColor = kTipColorNormal
  }
  
  private func _setErrorTip(tip: String) {
    //图形错误
    lock.showErrorLockView()
    //错误标签
    _lockTitleLabel?.text = tip
    _lockTitleLabel?.textColor = kTipColorError
    self._shake()
  }
  
  private func _shake() {
    let caAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    let offset: CGFloat = 15
    caAnimation.values = [(-offset),(0),(offset),(0),(-offset),(0),(offset),(0)]
    caAnimation.duration = 0.2
    caAnimation.repeatCount = 2
    caAnimation.removedOnCompletion = true
    _lockTitleLabel?.layer.addAnimation(caAnimation, forKey: "shake")
  }
  
}

extension LockViewController: LockViewDelegate {
  
  //MARK: - LockViewDelegate
  
  func lockViewDelegate(lockView: LockView, passCode: String, selectedArray: [Int]) {

    let passcode = passCode
    debugPrint("passcode = \(passcode)")
    
    switch lockType {
    case .Setting:
      _tip1 = NSLocalizedString("SET_A_PATTERN_PASSWORD", comment: "")
      _tip2 = NSLocalizedString("ENTER_AGAIN_FOR_CONFIRAMTION", comment: "")
      _tip3 = NSLocalizedString("CREATING_SUCCESS", comment: "")
      
      //密码长度4位
      if passcode.characters.count < 4 {
        _tip2 = NSLocalizedString("AT_LAST_4_POINTS_SET_AGAIN", comment: "")
        self._setTip(_tip2)
      }
      else {
        //刷新 indicator
        if lockType == .Setting {
          indicator.setSelectedArray(selectedArray)
        }
        self._creatPasscode(passcode)
      }
      
    case .Verify:
      _tip1 = NSLocalizedString("ENTER_THE_GESTURE_PASSWORD", comment: "")
      _tip2 = "密码错误，还可以再输入\(_passcodeAttemtCount)次"
      let alert: String = String(format:NSLocalizedString("INCORRECT_PATTERN_CHANCE_LEFT", comment: "") , _passcodeAttemtCount)
      _tip2 = NSLocalizedString(alert, comment: "")
      _tip3 = NSLocalizedString("ENTER_THE_GESTURE_PASSWORD", comment: "")
      self._verifyPassCode(passcode)
    default:
      break
    }
    
  }
  
}

extension LockViewController {
  
  //MARK: - LockType
  
  class func showSettingLockViewController(aboveViewController: WTKViewController) -> LockViewController {
    let lockVC: LockViewController = LockViewController()
    lockVC.navigationItem.title = NSLocalizedString("PATTERN_PASSWORD", comment: "");
    lockVC.lockType = .Setting
    lockVC._passcodeAttemtCount = lockVC.kpassCodeAttemptAmount
    aboveViewController.navigationController?.pushViewController(lockVC, animated: true)
    return lockVC
  }
  
  class func showVerifyLockViewController(aboveViewController: UIViewController) -> LockViewController {
    let lockVC: LockViewController = LockViewController()
    lockVC.navigationController?.navigationBarHidden = true
    lockVC.lockType = .Verify
    lockVC._passcodeAttemtCount = lockVC.kpassCodeAttemptAmount
    aboveViewController.presentViewController(lockVC, animated: false, completion: nil)
    return lockVC
  }
}

extension LockViewController {
  
  internal func _forgetBtnClick() {
    dismissViewControllerAnimated(true) { () -> Void in
      //清空手势数据
      LockInfoStorage.clearAllGestureLockInfo()
    }
    _logout()
  }
  
  //MARK: - TouchID
  
  @available(iOS 8.0, *)
   internal func _touchID() {
    let context: LAContext = LAContext()
    var authorError: NSError?
    context.localizedFallbackTitle = ""
    
    if #available(iOS 9.0, *) {
      if  context.canEvaluatePolicy(.DeviceOwnerAuthentication, error: &authorError) {
        
        context.evaluatePolicy(.DeviceOwnerAuthentication, localizedReason: NSLocalizedString("UNLOCK_VALIDATION_WORKTILE", comment: ""), reply: { (success: Bool, error: NSError?) -> Void in
          
          if success {
            debugPrint("验证成功 \(success)")
            self.dismissViewControllerAnimated(false, completion: nil)
          }
          else {
            if let error = error {
              switch error.code {
                
              case LAError.AuthenticationFailed.rawValue:
                debugPrint("Faild")
                
              case LAError.UserCancel.rawValue:
                debugPrint("User cancel")
                
              case LAError.SystemCancel.rawValue:
                debugPrint("System cancel")
                
              case LAError.TouchIDLockout.rawValue:
                debugPrint("Lock out")
                
              case LAError.TouchIDNotAvailable.rawValue:
                debugPrint("Not avaliable")
                
              case LAError.UserFallback.rawValue:
                debugPrint("Fallback")
                
              default:
                debugPrint("Default")
                break
              }
            }
          }
        })
      }
      else {
        let unSupportAlert: UIAlertView = UIAlertView(title: NSLocalizedString("TOUCH_ID_SYSTEM_IS_NOT_TUENED_ON", comment: ""), message: NSLocalizedString("PLEASE_OPEN_THE_SYSTEM_SETTING_FOR_TOUCHID", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
        unSupportAlert.tag = 10
        unSupportAlert.show()
      }
    }
    else {
      // Fallback on earlier versions
      if  context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &authorError) {
        
        context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: NSLocalizedString("UNLOCK_VALIDATION_WORKTILE", comment: ""), reply: { (success: Bool, error: NSError?) -> Void in
          
          if success {
            debugPrint("验证成功 \(success)")
            self.dismissViewControllerAnimated(false, completion: nil)
          }
          else {
            if let error = error {
              switch error.code {
                
              case LAError.AuthenticationFailed.rawValue:
                debugPrint("Faild")
                
              case LAError.UserCancel.rawValue:
                debugPrint("User cancel")
                
              case LAError.SystemCancel.rawValue:
                debugPrint("System cancel")
                
              case LAError.TouchIDNotAvailable.rawValue:
                debugPrint("Not avaliable")
                
              case LAError.UserFallback.rawValue:
                debugPrint("Fallback")
                
              default:
                debugPrint("Default")
                break
              }
            }
          }
        })
      }
      else {
        let unSupportAlert: UIAlertView = UIAlertView(title: NSLocalizedString("TOUCH_ID_SYSTEM_IS_NOT_TUENED_ON", comment: ""), message: NSLocalizedString("PLEASE_OPEN_THE_SYSTEM_SETTING_FOR_TOUCHID", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
        unSupportAlert.tag = 10
        unSupportAlert.show()
      }
    }
  }
  
  
  private func _authenticateUser() {
    //
  }
  
  //MARK: - Apperance
  
  private func _setupApperance() {
    
    view.backgroundColor = UIColor(hexString: "#D13635")
//    _setBackView()
  }
  
  private func _setBackView() {
    let backView: UIView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
    backView.backgroundColor = UIColor.redColor()
    view.addSubview(backView)
  }
  
  // 登陆
  
  private func _logout() {
    let HUD: MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    WTCDirector.sharedDirector().logoutWithDeviceToken(WTKAccountManager.sharedManager.deviceToken,
      success: { () -> Void in
        HUD.hide(true)
        
        // 注销当前帐户
        WTKAccountManager.sharedManager.removeCurrentAccount()
        
        // 返回第一个页面
        WTKSceneController.sharedController.replaceSceneWithIntroView()
      }, failure: { (authError: WTCAuthError) -> Void in
        debugPrint("WTCDirector logoutWithDeviceToken failed \(authError.rawValue)")
        HUD.hide(true)
    })
  }
  
}
