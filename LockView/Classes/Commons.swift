//
//  Commons.swift
//  LockView
//
//  Created by yuanjilee on 2017/11/15.
//


func LeeLocalizedString(_ key: String, comment: String) -> String {
//  return NSLocalizedString(key, tableName: nil, bundle: Bundle(for: LockView.self), value: "", comment: comment)
  
//  NSBundle *containingBundle = [NSBundle bundleForClass:[ClassInFramework class]];
//  NSURL *bundleURL = [containingBundle URLForResource:@"CTAssetsPickerController" withExtension:@"bundle"];
//  NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
  
  let containingBundle = Bundle(for: LockView.self)
  let bundleURL = containingBundle.url(forResource: "LockView", withExtension: "bundle")
  let bundle = Bundle(url: bundleURL!)
  
  return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: comment)
}
