//
//  UIColor+MSKAddition.m
//  MSeeFans
//
//  Created by Frank Lin on 14-5-18.
//  Copyright (c) 2014年 Frank Lin. All rights reserved.
//
#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "UIColor+DYKAddition.h"

@implementation UIColor (MSKAddition)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
  
  if ([hexString length] == 7) {
    hexString = [hexString substringFromIndex:1];
  }
  
  if ([hexString length] != 6) {
    return nil;
  }
  
  // Brutal and not-very elegant test for non hex-numeric characters
  NSRegularExpression *regex = [NSRegularExpression
                                regularExpressionWithPattern:@"[^a-fA-F|0-9]"
                                options:0
                                error:NULL];
  NSUInteger match = [regex numberOfMatchesInString:hexString
                                            options:NSMatchingReportCompletion
                                              range:NSMakeRange(0, [hexString length])];
  
  if (match != 0) {
    return nil;
  }
  
  NSRange rRange = NSMakeRange(0, 2);
  NSString *rComponent = [hexString substringWithRange:rRange];
  NSUInteger rVal = 0;
  NSScanner *rScanner = [NSScanner scannerWithString:rComponent];
  [rScanner scanHexInt:(unsigned int*)(&rVal)];
  float rRetVal = (float)rVal / 254;
  
  
  NSRange gRange = NSMakeRange(2, 2);
  NSString *gComponent = [hexString substringWithRange:gRange];
  NSUInteger gVal = 0;
  NSScanner *gScanner = [NSScanner scannerWithString:gComponent];
  [gScanner scanHexInt:(unsigned int*)&gVal];
  float gRetVal = (float)gVal / 254;
  
  NSRange bRange = NSMakeRange(4, 2);
  NSString *bComponent = [hexString substringWithRange:bRange];
  NSUInteger bVal = 0;
  NSScanner *bScanner = [NSScanner scannerWithString:bComponent];
  [bScanner scanHexInt:(unsigned int*)&bVal];
  float bRetVal = (float)bVal / 254;
  
  return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:1.0f];
  
}

+ (NSString *)hexValuesFromUIColor:(UIColor *)color {
  
  if (!color) {
    return nil;
  }
  
  if (color == [UIColor whiteColor]) {
    // Special case, as white doesn't fall into the RGB color space
    return @"ffffff";
  }
  
  CGFloat red;
  CGFloat blue;
  CGFloat green;
  CGFloat alpha;
  
  [color getRed:&red green:&green blue:&blue alpha:&alpha];
  
  int redDec = (int)(red * 255);
  int greenDec = (int)(green * 255);
  int blueDec = (int)(blue * 255);
  
  NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x",
                            (unsigned int)redDec,
                            (unsigned int)greenDec,
                            (unsigned int)blueDec];
  
  return returnString;
  
}

+ (UIColor *)colorWithHexRGB:(unsigned)rgbValue {
  return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@end
