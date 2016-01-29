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
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
    navigationItem.title = "手势锁"
    

    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    let backButtonImage: UIImage = UIImage(named: "navigation_back")!
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.backIndicatorImage = backButtonImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    
    navigationController?.navigationBar.translucent = false
  }
  
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let isOpen: String? = LockInfoStorage.getLockInfo()
    if let _ = isOpen {
      let setting: LockSettingViewController = LockSettingViewController()
      
      navigationController?.pushViewController(setting, animated: true)
    } else {
      LockViewController.showSettingLockViewController(self)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

  }
  
}
