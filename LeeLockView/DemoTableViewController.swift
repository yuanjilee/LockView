//
//  DemoTableViewController.swift
//  LeeLockView
//
//  Created by yuanjilee on 16/1/29.
//  Copyright © 2016年 yuanjilee. All rights reserved.
//

import UIKit

class DemoTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    UINavigationBar.appearance().barTintColor = UIColor(hexRGB: 0x3c3d47)
//    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//    
//    UINavigationBar.appearance().backIndicatorImage = UIImage(named: "navigation_back")
    

    
    navigationController?.navigationBar.barTintColor = UIColor(hexRGB: 0x3c3d47)
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    navigationItem.title = "手势锁"
    

    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    let backButtonImage: UIImage = UIImage(named: "navigation_back")!
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.backIndicatorImage = backButtonImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    
    navigationController?.navigationBar.isTranslucent = false
  }
  
  
  //MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let isOpen: String? = LockInfoStorage.getLockInfo()
    if let _ = isOpen {
      let setting: LockSettingViewController = LockSettingViewController()
      
      navigationController?.pushViewController(setting, animated: true)
    } else {
      LockViewController.showSettingLockViewController(self)
    }
    tableView.deselectRow(at: indexPath, animated: true)

  }
  
}
