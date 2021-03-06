//
//  DemoTableViewController.swift
//  LeeLockView
//
//  Created by yuanjilee on 16/1/29.
//  Copyright © 2016年 yuanjilee. All rights reserved.
//

import UIKit
import LockView

class DemoTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "手势锁"
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    let backButtonImage: UIImage = UIImage(named: "navigation_back")!
    navigationController?.navigationBar.tintColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.0)
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
      _ = LockViewController.showSettingLockViewController(self)
    }
    tableView.deselectRow(at: indexPath, animated: true)

  }
  
}
