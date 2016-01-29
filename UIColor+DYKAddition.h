//
//  UIColor+MSKAddition.h
//  MSeeFans
//
//  Created by Frank Lin on 14-5-18.
//  Copyright (c) 2014年 Frank Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIColor (MSKAddition)

/**
 *  从16进制颜色转成UIColor
 *
 *  @param hexString 十六进制颜色，例如 "dc8310" 或 "#dc8310"
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  颜色转成十六进制
 *
 *  @param color 颜色
 *
 *  @return 十六进制描述string
 */
+ (NSString *)hexValuesFromUIColor:(UIColor *)color;

/**
 *  颜色转成十六进制
 *
 *  @param color 颜色
 *
 *  @return 十六进制Code, eg. 0x0088cc
 */
+ (UIColor *)colorWithHexRGB:(unsigned)rgbValue;

@end
NS_ASSUME_NONNULL_END
