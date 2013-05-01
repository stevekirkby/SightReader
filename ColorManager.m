//
//  ColorManager.m
//  SightReader
//
//  Created by House on 10/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

+ (UIColor *) returnColorChangeFrom: (UIColor *)originalColor withToneAdjustment: (float) toneAdjustment {
    
    UIColor *uicolor = originalColor;
    CGColorRef color = [uicolor CGColor];
    
    float red;
    float green;
    float blue;
    
    const CGFloat *components = CGColorGetComponents(color);
    red = components[0];
    green = components[1];
    blue = components[2];
    
    CGFloat adjustmentModifier = (255.0 * toneAdjustment)-255.0;
    
    red += adjustmentModifier/255.0;
    green += adjustmentModifier/255.0;
    blue += adjustmentModifier/255.0;
    
    if (red > 255.0) red = 255.0;
    if (green > 255.0) green = 255.0;
    if (blue > 255.0) blue = 255.0;
    
    if (red < 0.0) red = 0.0;
    if (green < 0.0) green = 0.0;
    if (blue < 0.0) blue = 0.0;
    
    UIColor *darkerColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    return darkerColor;
    
}

+ (UIColor *) returnWhiteKeyColor {
    return [UIColor colorWithWhite:0.889 alpha:1.00];
}

+ (UIColor *) returnWhiteKeyHighlightedColor {
    return [UIColor colorWithRed:225.0/255.0 green:255.0/255.0 blue:156.0/255.0 alpha:1.0];
}

+ (UIColor *) returnBlackKeyColor {
    return [UIColor colorWithWhite:0.261 alpha:1.000];
}

+ (UIColor *) returnBlackKeyHighlightedColor {
    return [UIColor colorWithRed:0.261 green:0.508 blue:0.261 alpha:1.000]
    ;
}

@end
