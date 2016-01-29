//
//  AppDelegate.swift
//  LeeLockView
//
//  Created by yuanjilee on 16/1/29.
//  Copyright © 2016年 yuanjilee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    //show lockVC
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      let isOpenGestureLock: Bool? = LockInfoStorage.getSwitchState()
      if isOpenGestureLock == true {
        self.showLockViewController()
      }
    }
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    
    //show lockVC
    let isOpenGestureLock: Bool? = LockInfoStorage.getSwitchState()
    if isOpenGestureLock == true {
      showLockViewController()
    }

  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
  //MARK: - Show LockVC
  
  func showLockViewController() {
    //需要设置: 1. LockViewController line 250 设置连续输错五次后跳转至登陆界面。 2. LockViewController line 355 设置"忘记密码"后跳转至登陆界面. 3. LockViewController line 138 设置网络请求头像
    
    LockViewController.showVerifyLockViewController((window?.rootViewController)!);
  }

}

