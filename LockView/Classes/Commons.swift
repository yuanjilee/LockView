//
//  Commons.swift
//  LockView
//
//  Created by yuanjilee on 2017/11/15.
//


func LeeLocalizedString(_ key: String, comment: String) -> String {
//  return NSLocalizedString(key, tableName: "LockView", bundle: Bundle(identifier: "org.cocoapods.LockView")!, value: "", comment: comment)
  
//  let containingBundle = Bundle(for: LockView.self)
//  let bundleURL = containingBundle.url(forResource: "LockView", withExtension: "bundle")
//  let bundle = Bundle(url: bundleURL!)
  
  let containingBundle = Bundle(identifier: "org.cocoapods.LockView")
  let bundlePath = containingBundle?.path(forResource: "LockView", ofType: "bundle")
  return Bundle(path: bundlePath!)?.localizedString(forKey: key, value: "", table: "LockView") ?? ""
}

func getImagePath(name: String) -> String {
  
  let containingBundle = Bundle(identifier: "org.cocoapods.LockView")
  let path = containingBundle?.path(forResource: name, ofType: nil, inDirectory: "LockView.bundle")
  return path ?? ""
}
